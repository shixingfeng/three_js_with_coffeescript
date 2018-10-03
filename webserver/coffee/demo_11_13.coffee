console.log "demo_11.13 Effect composings"
camera = null
scene = null
renderer = null
mesh = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -10
    camera.position.y = 15
    camera.position.z = 25
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    orbitControls = new THREE.OrbitControls camera
    orbitControls.autoRotate = false

    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer


    #灯光
    ambi = new THREE.AmbientLight 0x686868
    scene.add ambi
    spotLight = new THREE.DirectionalLight 0xffffff
    spotLight.position.set 550, 100, 550
    spotLight.intensity = 0.6
    scene.add spotLight


    renderPass = new THREE.RenderPass scene, camera
    effectGlitch = new THREE.GlitchPass 64
    effectGlitch.renderToScreen = true
    composer = new THREE.EffectComposer webGLRenderer
    composer.addPass renderPass
    composer.addPass effectGlitch

    # 方法
    createMesh = (geom)->
        planetTexture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/planets/Earth.png"
        specularTexture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/planets/EarthSpec.png"
        normalTexture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/planets/EarthNormal.png"

        planetMaterial = new THREE.MeshPhongMaterial()
        planetMaterial.specularMap = specularTexture
        planetMaterial.specular = new THREE.Color 0x4444aa

        planetMaterial.normalMap = normalTexture
        planetMaterial.map = planetTexture
        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [planetMaterial]
        return mesh

    sphere = createMesh new THREE.SphereGeometry(10, 40, 40)
    scene.add sphere

    
    # 控制条
    controls = new ()->
        this.goWild = false
        this.updateEffect = ()->
            effectGlitch.goWild = controls.goWild
        return this
    # UI
    gui  = new dat.GUI
    gui.add(controls, "goWild").onChange controls.updateEffect
    
    step = 0
    clock = new THREE.Clock()
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        delta = clock.getDelta()
        orbitControls.update delta
        sphere.rotation.y += 0.002
        
        requestAnimationFrame renderScene
        composer.render delta
        
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
