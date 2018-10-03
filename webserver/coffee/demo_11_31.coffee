console.log "demo_11.31 custom shaderpass"
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
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    orbitControls = new THREE.OrbitControls camera
    orbitControls.autoRotate = false

    #灯光
    ambi = new THREE.AmbientLight 0x181818
    scene.add ambi

    spotLight = new THREE.DirectionalLight 0xffffff
    spotLight.position.set 550, 100, 550
    spotLight.intensity = 0.6
    scene.add spotLight
    
    # 方法区
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


    # 创建球体
    sphere = createMesh new THREE.SphereGeometry(10, 40, 40)
    scene.add sphere


    renderPass = new THREE.RenderPass scene, camera 
    effectCopy = new THREE.ShaderPass THREE.CopyShader 
    effectCopy.renderToScreen = true
    
    shaderPass = new THREE.ShaderPass THREE.CustomGrayScaleShader 
    shaderPass.enabled = false

    bitPass = new THREE.ShaderPass THREE.CustomBitShader 
    bitPass.enabled = false


    composer = new THREE.EffectComposer webGLRenderer 
    composer.addPass renderPass 
    composer.addPass shaderPass 
    composer.addPass bitPass 
    composer.addPass effectCopy 

    # 控制条
    controls = new ()->
        this.grayScale = false
        this.rPower = 0.2126
        this.gPower = 0.7152
        this.bPower = 0.0722
        this.bitShader = false
        this.bitSize = 8
        this.updateEffectFilm = ()->
            shaderPass.enabled = controls.grayScale
            shaderPass.uniforms.rPower.value = controls.rPower
            shaderPass.uniforms.gPower.value = controls.gPower
            shaderPass.uniforms.bPower.value = controls.bPower
        this.updateBit = ()->
            bitPass.enabled = controls.bitShader
            bitPass.uniforms.bitSize.value = controls.bitSize
        return this
    # UI
    gui  = new dat.GUI
    grayMenu = gui.addFolder "gray scale"
    grayMenu.add(controls, "grayScale").onChange controls.updateEffectFilm
    grayMenu.add(controls, "rPower", 0, 1).onChange controls.updateEffectFilm
    grayMenu.add(controls, "gPower", 0, 1).onChange controls.updateEffectFilm
    grayMenu.add(controls, "bPower", 0, 1).onChange controls.updateEffectFilm

    clock = new THREE.Clock()
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    

        delta = clock.getDelta()
        orbitControls.update delta

        sphere.rotation.y += 0.002
        requestAnimationFrame renderScene
        # renderer.render scene,camera
        composer.render()

    
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
