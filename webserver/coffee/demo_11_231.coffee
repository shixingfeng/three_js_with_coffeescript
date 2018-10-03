console.log "demo_11.231 Shader Pass simple"
camera = null
scene = null
renderer = null
mesh = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 20
    camera.position.y = 30
    camera.position.z = 40
    camera.lookAt new THREE.Vector3(-15, -10, -25)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xaaaaff, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    #灯光
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.castShadow = true
    spotLight.position.set 0, 60, 50
    spotLight.intensity = 1
    spotLight.shadowMapWidth = 2048
    spotLight.shadowMapHeight = 2048
    spotLight.shadowCameraFov = 120
    spotLight.shadowCameraNear = 1
    spotLight.shadowCameraFar = 1000
    scene.add spotLight
    ambiLight = new THREE.AmbientLight 0x444444
    scene.add ambiLight
    

       
  
    # 地面，物体，材质
    plane = new THREE.BoxGeometry 1600, 1600, 0.1, 40, 40


    cube = new THREE.Mesh plane, new THREE.MeshPhongMaterial({
        color: 0xffffff,
        map: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/general/plaster-diffuse.jpg"),
        normalMap: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/general/plaster-normal.jpg"),
        normalScale: new THREE.Vector2(0.6, 0.6)})
    cube.material.map.wrapS = THREE.RepeatWrapping
    cube.material.map.wrapT = THREE.RepeatWrapping
    cube.material.normalMap.wrapS = THREE.RepeatWrapping
    cube.material.normalMap.wrapT = THREE.RepeatWrapping
    cube.rotation.x = Math.PI / 2
    cube.material.map.repeat.set 80, 80
    cube.receiveShadow = true
    cube.position.z = -150
    cube.position.x = -150
    scene.add cube


    cube1 = new THREE.Mesh(
        new THREE.BoxGeometry(30, 10, 2),
        new THREE.MeshPhongMaterial({color: 0xff0000}))
    cube1.position.x = -15
    cube1.position.y = 5
    cube1.position.z = 15
    cube1.castShadow = true
    scene.add cube1

    cube2 = cube1.clone()
    cube2.material = cube1.material.clone()
    cube2.material.color = new THREE.Color 0x00ff00
    cube2.position.z = 5
    cube2.position.x = -20
    scene.add cube2

    cube3 = cube1.clone()
    cube3.material = cube1.material.clone()
    cube3.material.color = new THREE.Color 0x0000ff
    cube3.position.z = -8
    cube3.position.x = -25
    scene.add cube3


    # 纹理外部纹理
    loader = new THREE.OBJMTLLoader()
    loader.load "/static/pictures/assets/models/sol/libertStatue.obj","/static/pictures/assets/models/sol/libertStatue.mtl",(event)->
        object = event
        console.log event
        geom = object.children[0].geometry
        uv3 = geom.faceVertexUvs[0][0]
        uv4 = geom.faceVertexUvs[0][10]
        for j in [0..7616 - 7206 -1]
            if geom.faces[j + 7206] instanceof THREE.Face4
                geom.faceVertexUvs[0].push(uv4)
            else
                geom.faceVertexUvs[0].push(uv4)
        object.children.forEach (e)->
            e.castShadow = true

        object.scale.set 20, 20, 20
        mesh = object
        mesh.position.x = 15
        mesh.position.z = 5
        scene.add object


    mirror = new THREE.ShaderPass THREE.MirrorShader
    mirror.enabled = false

    hue = new THREE.ShaderPass THREE.HueSaturationShader
    hue.enabled = false

    vignette = new THREE.ShaderPass THREE.VignetteShader
    vignette.enabled = false

    colorCorrection = new THREE.ShaderPass THREE.ColorCorrectionShader
    colorCorrection.enabled = false
    
    rgbShift = new THREE.ShaderPass THREE.RGBShiftShader
    rgbShift.enabled = false

    brightness = new THREE.ShaderPass THREE.BrightnessContrastShader
    brightness.uniforms.brightness.value = 0
    brightness.uniforms.contrast.value = 0
    brightness.enabled = false
    brightness.uniforms.brightness.value = 0
    brightness.uniforms.contrast.value = 0


    colorify = new THREE.ShaderPass THREE.ColorifyShader
    colorify.uniforms.color.value = new THREE.Color 0xffffff
    colorify.enabled = false

    sepia = new THREE.ShaderPass THREE.SepiaShader
    sepia.uniforms.amount.value = 1
    sepia.enabled = false

    kal = new THREE.ShaderPass THREE.KaleidoShader
    kal.enabled = false

    lum = new THREE.ShaderPass THREE.LuminosityShader
    lum.enabled = false

    techni = new THREE.ShaderPass THREE.TechnicolorShader
    techni.enabled = false

    unpack = new THREE.ShaderPass THREE.UnpackDepthRGBAShader
    unpack.enabled = false

    renderPass = new THREE.RenderPass scene, camera
    effectCopy = new THREE.ShaderPass THREE.CopyShader
    effectCopy.renderToScreen = true

    composer = new THREE.EffectComposer webGLRenderer
    composer.addPass renderPass
    composer.addPass brightness
    composer.addPass sepia
    composer.addPass mirror
    composer.addPass colorify
    composer.addPass colorCorrection
    composer.addPass rgbShift
    composer.addPass vignette
    composer.addPass hue
    composer.addPass kal
    composer.addPass lum
    composer.addPass techni
    composer.addPass unpack
    composer.addPass effectCopy




    # 控制条
    controls = new ()->
        this.brightness = 0.01
        this.contrast = 0.01
        this.select = "none"
        this.color = 0xffffff
        this.amount = 1
        this.powRGB_R = 2
        this.mulRGB_R = 1
        this.powRGB_G = 2
        this.mulRGB_G = 1
        this.powRGB_B = 2
        this.mulRGB_B = 1
        this.rgbAmount = 0.005
        this.angle = 0.0
        this.side = 1
        this.offset = 1
        this.darkness = 1
        this.hue = 0.01
        this.saturation = 0.01
        this.kalAngle = 0
        this.kalSides = 6
        this.rotate = false
        this.switchShader = ()->
           switch controls.select
                when  "none" then enableShader()
                when  "colorify" then enableShader(colorify)
                when  "brightness" then enableShader(brightness)
                when  "sepia" then enableShader(sepia)
                when  "colorCorrection" then enableShader(colorCorrection)
                when  "rgbShift" then enableShader(rgbShift)
                when  "mirror" then enableShader(mirror)
                when  "vignette" then enableShader(vignette)
                when  "hueAndSaturation" then enableShader(hueAndSaturation)
                when  "kaleidoscope" then enableShader(kaleidoscope)
                when  "luminosity" then enableShader(luminosity)
                when  "technicolor" then enableShader(technicolor)
                when  "unpackDepth" then enableShader(unpackDepth)
        this.changeBrightness = ()->
            brightness.uniforms.brightness.value = controls.brightness
            brightness.uniforms.contrast.value = controls.contrast

        this.changeColor = ()->
            colorify.uniforms.color.value = new THREE.Color controls.color

        this.changeSepia = ()->
            sepia.uniforms.amount.value = controls.amount

        this.changeCorrection = ()->
            colorCorrection.uniforms.mulRGB.value = new THREE.Vector3(controls.mulRGB_R, controls.mulRGB_G, controls.mulRGB_B)
            colorCorrection.uniforms.powRGB.value = new THREE.Vector3(controls.powRGB_R, controls.powRGB_G, controls.powRGB_B)

        this.changeRGBShifter = ()->
            rgbShift.uniforms.amount.value = controls.rgbAmount
            rgbShift.uniforms.angle.value = controls.angle

        this.changeMirror = ()->
            mirror.uniforms.side.value = controls.side

        this.changeVignette = ()->
            vignette.uniforms.darkness.value = controls.darkness
            vignette.uniforms.offset.value = controls.offset

        this.changeHue = ()->
            hue.uniforms.hue.value = controls.hue
            hue.uniforms.saturation.value = controls.saturation

        this.changeKal = ()->
            kal.uniforms.sides.value = controls.kalSides
            kal.uniforms.angle.value = controls.kalAngle      

        enableShader = (shader)->
            for i in [1..composer.passes.length - 1 - 1]
                if composer.passes[i] == shader
                    composer.passes[i].enabled = true
                else
                    composer.passes[i].enabled = false

        return this
    # UI
    gui  = new dat.GUI
    gui.add(controls, "select", ["none", "colorify", "brightness", "sepia", "colorCorrection", "rgbShift", "mirror", "vignette", "hueAndSaturation", "kaleidoscope", "luminosity", "technicolor"]).onChange controls.switchShader
    gui.add controls, "rotate"

    bnFolder = gui.addFolder "Brightness"
    bnFolder.add(controls, "brightness", -1, 1).onChange controls.changeBrightness 
    bnFolder.add(controls, "contrast", -1, 1).onChange controls.changeBrightness 

    clFolder = gui.addFolder "Colorify"
    clFolder.addColor(controls, "color").onChange controls.changeColor

    colFolder = gui.addFolder "Color Correction"
    colFolder.add(controls, "powRGB_R", 0, 5).onChange controls.changeCorrection 
    colFolder.add(controls, "powRGB_G", 0, 5).onChange controls.changeCorrection 
    colFolder.add(controls, "powRGB_B", 0, 5).onChange controls.changeCorrection 
    colFolder.add(controls, "mulRGB_R", 0, 5).onChange controls.changeCorrection 
    colFolder.add(controls, "mulRGB_G", 0, 5).onChange controls.changeCorrection 
    colFolder.add(controls, "mulRGB_B", 0, 5).onChange controls.changeCorrection 

    sepiaFolder = gui.addFolder "Sepia"
    sepiaFolder.add(controls, "amount", 0, 2).step(0.1).onChange controls.changeSepia

    shiftFolder = gui.addFolder "RGB Shift"
    shiftFolder.add(controls, "rgbAmount", 0, 0.1).step(0.001).onChange controls.changeRGBShifter
    shiftFolder.add(controls, "angle", 0, 3.14).step(0.001).onChange controls.changeRGBShifter

    mirrorFolder = gui.addFolder "mirror"
    mirrorFolder.add(controls, "side", 0, 3).step(1).onChange controls.changeMirror

    vignetteFolder = gui.addFolder "vignette"
    vignetteFolder.add(controls, "darkness", 0, 2).onChange controls.changeVignette
    vignetteFolder.add(controls, "offset", 0, 2).onChange controls.changeVignette

    hueAndSat = gui.addFolder "hue and saturation"
    hueAndSat.add(controls, "hue", -1, 1).step(0.01).onChange controls.changeHue
    hueAndSat.add(controls, "saturation", -1, 1).step(0.01).onChange controls.changeHue


    kalMenu = gui.addFolder "Kaleidoscope"
    kalMenu.add(controls, "kalAngle", -2 * Math.PI, 2 * Math.PI).onChange controls.changeKal
    kalMenu.add(controls, "kalSides", 2, 20).onChange controls.changeKal
    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        if controls.rotate
            if mesh
                mesh.rotation.y += 0.01
                cube1.rotation.y += 0.01
                cube2.rotation.y += 0.01
                cube3.rotation.y += 0.01
        
    
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
