console.log "demo_10.13 Normal maps"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 0
    camera.position.y = 12
    camera.position.z = 28
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer
    

    # 材质选择
    createMesh = (geom, imageFile, normal)->
        if normal
            t = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + imageFile
            m = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + normal
            mat2 = new THREE.MeshPhongMaterial()
            mat2.map = t
            mat2.normalMap = m
            mesh = new THREE.Mesh geom, mat2
            return mesh
        else
            t = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + imageFile
            mat1 = new THREE.MeshPhongMaterial {map: t}
            mesh = new THREE.Mesh geom, mat1
            return mesh
        return mesh

    # 更细致的贴图
    createNormalmapShaderMaterial = (diffuseMap, normalMap)->
        shader = THREE.ShaderLib["normalmap"]
        uniforms = THREE.UniformsUtils.clone shader.uniforms

        dT = THREE.ImageUtils.loadTexture diffuseMap 
        nT = THREE.ImageUtils.loadTexture normalMap 

        uniforms["uShininess"].value = 50
        uniforms["enableDiffuse"].value = true
        uniforms["uDiffuseColor"].value.setHex 0xffffff
        uniforms["tDiffuse"].value = dT
        uniforms["tNormal"].value = nT

        uniforms["uNormalScale"].value.set 1, 1
        uniforms["uSpecularColor"].value.setHex 0xffffff
        uniforms["enableSpecular"].value = true

        return new THREE.ShaderMaterial {
            fragmentShader: shader.fragmentShader,
            vertexShader: shader.vertexShader,
            uniforms: uniforms,
            lights: true}

    # 创建添加材质的物体
    sphere1 = createMesh new THREE.BoxGeometry(15, 15, 2), "stone.jpg"
    sphere1.rotation.y = -0.5
    sphere1.position.x = 12
    scene.add sphere1

    sphere2 = createMesh new THREE.BoxGeometry(15, 15, 2), "stone.jpg", "stone-bump.jpg"
    sphere2.rotation.y = 0.5
    sphere2.position.x = -12
    scene.add sphere2
    console.log sphere2.geometry.faceVertexUvs

    floorTex = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/floor-wood.jpg"
    plane = new THREE.Mesh(
        new THREE.BoxGeometry(200, 100, 0.1, 30),
        new THREE.MeshPhongMaterial {color: 0x3c3c3c,map: floorTex} )
    plane.position.y = -7.5
    plane.rotation.x = -0.5 * Math.PI
    scene.add plane

    #灯光
    ambiLight = new THREE.AmbientLight 0x242424
    scene.add ambiLight

    light = new THREE.DirectionalLight()
    light.position.set 0, 30, 30
    light.intensity = 1.2
    scene.add light

    pointColor = "#ff5808"
    directionalLight = new THREE.PointLight pointColor
    scene.add directionalLight

    sphereLight = new THREE.SphereGeometry 0.2
    sphereLightMaterial = new THREE.MeshBasicMaterial {color: 0xac6c25}
    sphereLightMesh = new THREE.Mesh sphereLight, sphereLightMaterial
    sphereLightMesh.castShadow = true
    sphereLightMesh.position = new THREE.Vector3 3, 3, 3
    scene.add sphereLightMesh

    # 控制条
    controls = new ()->
        this.normalScale = 1
        this.changeTexture = "plaster"
        this.rotate = false

        this.changeTexture = (e)->
            texture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + e + ".jpg"
            sphere2.material.map = texture
            sphere1.material.map = texture

            bump = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + e + "-normal.jpg"
            sphere2.material.normalMap = bump

        this.updateBump = (e)->
            sphere2.material.normalScale.set e, e 
        return this
   
    # UI呈现
    gui = new dat.GUI()
    gui.add(controls, "normalScale", -2, 2).onChange controls.updateBump
    gui.add(controls, "changeTexture", ["plaster", "bathroom", "metal-floor"]).onChange controls.changeTexture
    gui.add controls, "rotate"
    
    invert = 1
    phase = 0
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        step += 0.1
        if controls.rotate
            sphere1.rotation.y -= 0.01
            sphere2.rotation.y += 0.01

        if phase > 2 * Math.PI
            invert = invert * -1
            phase -= 2 * Math.PI
        else
            phase += 0.03
        sphereLightMesh.position.z = +(21 * (Math.sin(phase)))
        sphereLightMesh.position.x = -14 + (14 * (Math.cos(phase)))


        if invert < 0
            pivot = 0
            sphereLightMesh.position.x = (invert * (sphereLightMesh.position.x - pivot)) + pivot
        directionalLight.position.copy sphereLightMesh.position

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
