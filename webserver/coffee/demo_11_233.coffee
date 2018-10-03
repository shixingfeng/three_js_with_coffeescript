console.log "demo_11.233 Advanced"
camera = null
scene = null
renderer = null
mesh = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 30
    camera.position.y = 30
    camera.position.z = 30
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xaaaaff, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    webGLRenderer.antialias = false
    renderer = webGLRenderer

    #灯光
    dirLight = new THREE.DirectionalLight 0xffffff
    dirLight.position.set 30, 30, 30
    dirLight.intensity = 0.8
    scene.add dirLight
    
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.castShadow = true
    spotLight.position.set -30, 30, -100
    spotLight.target.position.x = -10
    spotLight.target.position.z = -10
    spotLight.intensity = 0.6
    spotLight.shadowMapWidth = 4096
    spotLight.shadowMapHeight = 4096
    spotLight.shadowCameraFov = 120
    spotLight.shadowCameraNear = 1
    spotLight.shadowCameraFar = 200
    scene.add spotLight
    

    scale = chroma.scale ['white', 'blue']
    
  
    # 地面，物体，材质
    plane = new THREE.BoxGeometry 1600, 1600, 0.1, 40, 40


    cube = new THREE.Mesh plane, new THREE.MeshPhongMaterial {
        color: 0xffffff,
        map: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/general/floor-wood.jpg"),
        normalScale: new THREE.Vector2(0.6, 0.6)}
    cube.material.map.wrapS = THREE.RepeatWrapping
    cube.material.map.wrapT = THREE.RepeatWrapping
    cube.rotation.x = Math.PI / 2
    cube.material.map.repeat.set 80, 80
    cube.receiveShadow = true
    cube.position.z = -150
    cube.position.x = -150
    scene.add cube



    range = 3
    stepX = 8
    stepZ = 8
    for i  in [-25..4]
        for j in [-15..14]
            cube = new THREE.Mesh(
                new THREE.BoxGeometry(3, 4, 3),
                new THREE.MeshPhongMaterial({
                                color: scale(Math.random()).hex(),
                                opacity: 0.8,
                                transparent: true}))
            cube.position.x = i * stepX + (Math.random() - 0.5) * range
            cube.position.z = j * stepZ + (Math.random() - 0.5) * range
            cube.position.y = (Math.random() - 0.5) * 2
            cube.castShadow = true
            scene.add cube


    bleachFilter = new THREE.ShaderPass THREE.BleachBypassShader
    bleachFilter.enabled = false

    edgeShader = new THREE.ShaderPass THREE.EdgeShader
    edgeShader.enabled = false

    FXAAShader = new THREE.ShaderPass THREE.FXAAShader
    FXAAShader.enabled = false

    focusShader = new THREE.ShaderPass THREE.FocusShader
    focusShader.enabled = false

    renderPass = new THREE.RenderPass scene, camera
    effectCopy = new THREE.ShaderPass THREE.CopyShader
    effectCopy.renderToScreen = true

    composer = new THREE.EffectComposer webGLRenderer
    composer.addPass renderPass
    composer.addPass bleachFilter
    composer.addPass edgeShader
    composer.addPass FXAAShader
    composer.addPass focusShader
    composer.addPass effectCopy



    # 控制条
    controls = new ()->
        this.bleachOpacity = 1
        this.bleach = false
        this.edgeDetect = false
        this.edgeAspect = 512
        this.FXAA = false

        this.focus = false
        this.sampleDistance = 0.94
        this.waveFactor = 0.00125
        this.screenWidth = window.innerWidth
        this.screenHeight = window.innerHeight

        this.onChange = ()->
            bleachFilter.enabled = controls.bleach
            bleachFilter.uniforms.opacity.value = controls.bleachOpacity

            edgeShader.enabled = controls.edgeDetect
            edgeShader.uniforms.aspect.value = new THREE.Vector2 controls.edgeAspect, controls.edgeAspect 

            FXAAShader.enabled = controls.FXAA
            FXAAShader.uniforms.resolution.value = new THREE.Vector2 1 / window.innerWidth, 1 / window.innerHeight

            focusShader.enabled = controls.focus
            focusShader.uniforms.screenWidth.value = controls.screenWidth
            focusShader.uniforms.screenHeight.value = controls.screenHeight
            focusShader.uniforms.waveFactor.value = controls.waveFactor
            focusShader.uniforms.sampleDistance.value = controls.sampleDistance
        return this
    # UI
    gui  = new dat.GUI
    gui.add(controls, "bleach").onChange controls.onChange
    gui.add(controls, "bleachOpacity", 0, 2).onChange controls.onChange
    gui.add(controls, "edgeDetect").onChange controls.onChange
    gui.add(controls, "edgeAspect", 128, 2048).step(128).onChange controls.onChange
    gui.add(controls, "FXAA").onChange controls.onChange
    gui.add(controls, "focus").onChange controls.onChange
    gui.add(controls, "sampleDistance", 0, 2).step(0.01).onChange controls.onChange
    gui.add(controls, "waveFactor", 0, 0.005).step(0.0001).onChange controls.onChange

    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    
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
