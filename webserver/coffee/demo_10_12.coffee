console.log "demo_10.12 Bump maps"
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
    createMesh = (geom, imageFile, bump)->
        texture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + imageFile
        geom.computeVertexNormals()
        mat = new THREE.MeshPhongMaterial()
        mat.map = texture

        if bump
            bump = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + bump
            mat.bumpMap = bump
            mat.bumpScale = 0.2
            console.log "d"
        mesh = new THREE.Mesh geom, mat
        return mesh


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


    # 控制条
    controls = new ()->
        this.bumpScale = 0.2
        this.changeTexture = "weave"
        this.rotate = false
        
        this.changeTexture = (e)->
            texture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + e + ".jpg"
            sphere2.material.map = texture
            sphere1.material.map = texture

            bump = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + e + "-bump.jpg"
            sphere2.material.bumpMap = bump
        this.updateBump = (e)->
            console.log sphere2.material.bumpScale
            sphere2.material.bumpScale = e
        return this
    # UI呈现
    gui = new dat.GUI()
    gui.add(controls, "bumpScale", -2, 2).onChange controls.updateBump
    gui.add(controls, "changeTexture", ["stone", "weave"]).onChange controls.changeTexture
    gui.add controls, "rotate"
    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        if controls.rotate
            sphere1.rotation.y -= 0.01
            sphere2.rotation.y += 0.01

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