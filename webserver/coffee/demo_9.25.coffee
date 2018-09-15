console.log "启用coffee demo_3.31"
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -20
    camera.position.y = 30
    camera.position.z = 40
    camera.lookAt new THREE.Vector3(0, 0, 0)
    

    # 摄像机控件
    orbitControls = new THREE.OrbitControls camera
    orbitControls.autoRotate = false
    clock = new THREE.Clock()

    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0x000, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    
    # 创建地面方块
    createMesh = (geom) ->
        planetTexture = THREE.ImageUtils.loadTexture "/static/pictures/mars_1k_color.jpg"
        normalTexture = THREE.ImageUtils.loadTexture "/static/pictures/mars_1k_normal.jpg"
        planetMaterial = new THREE.MeshPhongMaterial {map: planetTexture, bumpMap: normalTexture}
        
        wireFrameMat = new THREE.MeshBasicMaterial()
        wireFrameMat.wireframe = true
        
        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [planetMaterial]
        return mesh
    
    # 创建网格上的物体
    sphere = createMesh new THREE.SphereGeometry(20, 40, 40)
    scene.add sphere
    

    #灯光
    ambiLight = new THREE.AmbientLight 0x111111
    scene.add ambiLight
        
    spotLight = new THREE.DirectionalLight 0xffffff
    spotLight.position.set -20, 30, 40
    spotLight.intensity = 1.5
    scene.add spotLight


    # 控制台
    # controls = new ()->
        
    #控制条UI
    # gui = new dat.GUI()
    
    # 实时渲染
    step = 0
    renderScene = ()->
        stats.update()
        
        delta = clock.getDelta()
        orbitControls.update(delta)

        
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

# 屏幕适配
onResize = ()->
    console.log "onResize"
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

window.onload = init()
window.addEventListener "resize", onResize, false
