console.log "demo_10.16 Specular map"
camera = null
cubeCamera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 15
    camera.position.y = 15
    camera.position.z = 15
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer
    # 方法区
    createMesh = (geom)->
        planetTexture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/planets/Earth.png"
        specularTexture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/planets/EarthSpec.png"
        normalTexture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/planets/EarthNormal.png"

        planetMaterial = new THREE.MeshPhongMaterial()
        planetMaterial.specularMap = specularTexture
        planetMaterial.specular = new THREE.Color 0xff0000
        planetMaterial.shininess = 2
        planetMaterial.normalMap = normalTexture

        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [planetMaterial]
        return mesh

    # 创建形状，添加材质
    sphere = createMesh new THREE.SphereGeometry(10, 40, 40)
    scene.add sphere


    #控制器
    orbitControls = new THREE.OrbitControls camera
    orbitControls.autoRotate = false

    
    # 灯光
    ambi = new THREE.AmbientLight 0x3300000
    scene.add ambi
    spotLight = new THREE.DirectionalLight 0xffffff
    spotLight.position.set 350, 350, 150
    spotLight.intensity = 0.4
    scene.add spotLight

    # 控制条
    control = new ()->
        this.rotationSpeed = 0.005
        this.scale = 1
        return this
    
    clock = new THREE.Clock()
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        delta = clock.getDelta()
        orbitControls.update delta
        sphere.rotation.y += 0.005
        

        requestAnimationFrame renderScene
        renderer.render scene,camera
    
    # 状态条
    initStats = ()->
        stats = new Stats()
        stats.setMode 0
        stats.domElement.style.position = "absolute"
        stats.domElement.style.left = "0px"
        stats.domElement.style.top = "0px"
        $("#Stats-output").append stats.domElement
        return stats
    
    stats = initStats()
    
    $("#WebGL-output").append renderer.domElement
    renderScene()

#屏幕适配
onResize =()->
    console.log "onResize"
    camera.aspect = window.innerWidth/window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight


window.onload = init()
window.addEventListener "resize", onResize, false
