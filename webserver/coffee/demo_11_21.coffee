console.log "demo_11.21 Post processing masks"
camera = null
scene = null
renderer = null
mesh = null
init = ()->
    # 场景
    sceneEarth = new THREE.Scene()
    sceneMars = new THREE.Scene()
    sceneBG = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth / window.innerHeight, 0.1, 1000
    cameraBG = new THREE.OrthographicCamera -window.innerWidth, window.innerWidth, window.innerHeight, -window.innerHeight, -10000, 10000
    camera.position.x = -10
    camera.position.y = 15
    camera.position.z = 25

    camera.lookAt new THREE.Vector3(0, 0, 0)
    cameraBG.position.z = 50
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    # 轨道控制器
    orbitControls = new THREE.OrbitControls camera
    orbitControls.autoRotate = false
    
    #灯光
    ambi = new THREE.AmbientLight 0x181818
    ambi2 = new THREE.AmbientLight 0x181818
    sceneEarth.add ambi
    sceneMars.add ambi2

    spotLight = new THREE.DirectionalLight 0xffffff
    spotLight.position.set 550, 100, 550
    spotLight.intensity = 0.6

    spotLight2 = new THREE.DirectionalLight 0xffffff
    spotLight.position.set 550, 100, 550
    spotLight.intensity = 0.6

    sceneEarth.add spotLight
    sceneMars.add spotLight2


    materialColor = new THREE.MeshBasicMaterial {
            map: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/starry-deep-outer-space-galaxy.jpg"),
            depthTest: false}
    bgPlane = new THREE.Mesh new THREE.PlaneGeometry(1, 1), materialColor
    bgPlane.position.z = -100
    bgPlane.scale.set window.innerWidth * 2, window.innerHeight * 2, 1
    sceneBG.add bgPlane
    

    bgPass = new THREE.RenderPass sceneBG, cameraBG
    renderPass = new THREE.RenderPass sceneEarth, camera
    renderPass.clear = false 
    renderPass2 = new THREE.RenderPass sceneMars, camera
    renderPass2.clear = false 


    effectCopy = new THREE.ShaderPass THREE.CopyShader
    effectCopy.renderToScreen = true


    clearMask = new THREE.ClearMaskPass()
    earthMask = new THREE.MaskPass sceneEarth, camera
    marsMask = new THREE.MaskPass sceneMars, camera


    effectSepia = new THREE.ShaderPass THREE.SepiaShader
    effectSepia.uniforms["amount"].value = 0.8

    effectColorify = new THREE.ShaderPass THREE.ColorifyShader
    effectColorify.uniforms["color"].value.setRGB 0.5, 0.5, 1


    composer = new THREE.EffectComposer webGLRenderer
    composer.renderTarget1.stencilBuffer = true
    composer.renderTarget2.stencilBuffer = true

    composer.addPass bgPass
    composer.addPass renderPass
    composer.addPass renderPass2
    composer.addPass marsMask
    composer.addPass effectColorify
    composer.addPass clearMask
    composer.addPass earthMask
    composer.addPass effectSepia
    composer.addPass clearMask
    composer.addPass effectCopy


    # 方法
    createMarshMesh = (geom)->
        planetTexture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/planets/Mars_2k-050104.png"
        normalTexture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/planets/Mars-normalmap_2k.png"

        planetMaterial = new THREE.MeshPhongMaterial()
        planetMaterial.normalMap = normalTexture
        planetMaterial.map = planetTexture

        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [planetMaterial]
        return mesh


    createEarthMesh = (geom)->
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

    # 星球
    sphere = createEarthMesh new THREE.SphereGeometry(10, 40, 40)
    sphere.position.x = -10
    
    sphere2 = createMarshMesh new THREE.SphereGeometry(5, 40, 40)
    sphere2.position.x = 10
    
    sceneEarth.add sphere
    sceneMars.add sphere2
    
    # 控制条
    controls = new ()->
       
    # UI
    gui  = new dat.GUI
    
    
    step = 0
    clock = new THREE.Clock()
    # 实时渲染
    renderScene = ()->
        stats.update()
        webGLRenderer.autoClear = false
        
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
