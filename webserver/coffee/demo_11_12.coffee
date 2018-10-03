console.log "demo_11.12 Simple passes"
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

    
    #球体
    sphere = createMesh new THREE.SphereGeometry(10, 40, 40)
    scene.add sphere
       

    # 效果组合器,渲染，然后输出到定义的目标上
    renderPass = new THREE.RenderPass scene, camera 
    effectCopy = new THREE.ShaderPass THREE.CopyShader 
    effectCopy.renderToScreen = true

    bloomPass = new THREE.BloomPass 3, 25, 5.0, 256 
    effectFilm = new THREE.FilmPass 0.8, 0.325, 256, false 
    effectFilm.renderToScreen = true

    dotScreenPass = new THREE.DotScreenPass()


    composer = new THREE.EffectComposer webGLRenderer
    composer.addPass renderPass
    composer.addPass effectFilm

    # 定义可重用部分的纹理
    renderScene = new THREE.TexturePass composer.renderTarget2

    composer1 = new THREE.EffectComposer webGLRenderer 
    composer1.addPass renderScene
    composer1.addPass dotScreenPass 
    composer1.addPass effectCopy 

    composer2 = new THREE.EffectComposer webGLRenderer 
    composer2.addPass renderScene
    composer2.addPass effectCopy

    composer3 = new THREE.EffectComposer webGLRenderer 
    composer3.addPass renderScene
    composer3.addPass bloomPass
    composer3.addPass effectCopy

    composer4 = new THREE.EffectComposer webGLRenderer 
    composer4.addPass renderScene
    composer4.addPass effectFilm
    


    # 控制条
    controls = new ()->
        #  film
        this.scanlinesCount = 256
        this.grayscale = false
        this.scanlinesIntensity = 0.3
        this.noiseIntensity = 0.8

        # bloompass
        this.strength = 3
        this.kernelSize = 25
        this.sigma = 5.0
        this.resolution = 256

        # dotscreen
        this.centerX = 0.5
        this.centerY = 0.5
        this.angle = 1.57
        this.scale = 1

        this.updateEffectFilm = ()->
            effectFilm.uniforms.grayscale.value = controls.grayscale
            effectFilm.uniforms.nIntensity.value = controls.noiseIntensity
            effectFilm.uniforms.sIntensity.value = controls.scanlinesIntensity
            effectFilm.uniforms.sCount.value = controls.scanlinesCount

        this.updateDotScreen = ()->
            dotScreenPass = new THREE.DotScreenPass(new THREE.Vector2(controls.centerX,controls.centerY),controls.angle, controls.scale)
            composer1 = new THREE.EffectComposer webGLRenderer
            composer1.addPass renderScene
            composer1.addPass dotScreenPass
            composer1.addPass effectCopy
        

        this.updateEffectBloom = ()->
            bloomPass = new THREE.BloomPass controls.strength, controls.kernelSize, controls.sigma, controls.resolution
            composer3 = new THREE.EffectComposer webGLRenderer
            composer3.addPass renderScene
            composer3.addPass bloomPass
            composer3.addPass effectCopy
        return this
    # UI
    gui  = new dat.GUI
    bpFolder = gui.addFolder "BloomPass"
    bpFolder.add(controls, "strength", 1, 10).onChange controls.updateEffectBloom
    bpFolder.add(controls, "kernelSize", 1, 100).onChange controls.updateEffectBloom
    bpFolder.add(controls, "sigma", 1, 10).onChange controls.updateEffectBloom
    bpFolder.add(controls, "resolution", 0, 1024).onChange controls.updateEffectBloom


    fpFolder = gui.addFolder "FilmPass"
    fpFolder.add(controls, "scanlinesIntensity", 0, 1).onChange controls.updateEffectFilm
    fpFolder.add(controls, "noiseIntensity", 0, 3).onChange controls.updateEffectFilm
    fpFolder.add(controls, "grayscale").onChange controls.updateEffectFilm
    fpFolder.add(controls, "scanlinesCount", 0, 2048).step(1).onChange controls.updateEffectFilm

    dsFolder = gui.addFolder "DotScreenPass"
    dsFolder.add(controls, "centerX", 0, 1).onChange controls.updateDotScreen
    dsFolder.add(controls, "centerY", 0, 1).onChange controls.updateDotScreen
    dsFolder.add(controls, "angle", 0, 3.14).onChange controls.updateDotScreen
    dsFolder.add(controls, "scale", 0, 10).onChange controls.updateDotScreen
    
    step = 0
    clock = new THREE.Clock()
    width = window.innerWidth || 2
    height = window.innerHeight || 2
    halfWidth = width / 2
    halfHeight = height / 2
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        delta = clock.getDelta()
        orbitControls.update delta
        sphere.rotation.y += 0.002
        
        requestAnimationFrame renderScene

                
        webGLRenderer.autoClear = false
        webGLRenderer.clear()

        webGLRenderer.setViewport 0, 0, 2 * halfWidth, 2 * halfHeight 
        composer.render delta

        webGLRenderer.setViewport 0, 0, halfWidth, halfHeight 
        composer1.render delta

        webGLRenderer.setViewport halfWidth, 0, halfWidth, halfHeight 
        composer2.render delta

        webGLRenderer.setViewport 0, halfHeight, halfWidth, halfHeight 
        composer3.render delta

        webGLRenderer.setViewport halfWidth, halfHeight, halfWidth, halfHeight 
        composer4.render delta
    
        
    
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
