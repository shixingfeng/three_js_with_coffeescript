console.log "demo_12.31 Physijs shapes"
camera = null
scene = null
renderer = null
mesh = null
stepX = null
direction = 1
"use strict"
scale = chroma.scale ["white", "blue"]
Physijs.scripts.worker = "/static/js/libs/physijs_worker.js"
Physijs.scripts.ammo = "/static/js/libs/ammo.js"
initScene = []
render = []
applyForce = []
setMousePosition = []
mouse_position = []
ground_material = []
projector = []
box_material = []
renderer = []
render_stats = []
physics_stats = []
scene = []
ground = []
light = []
camera = []
box = []
boxes = []



# 实时渲染
render = ()->
    render_stats.update()
    requestAnimationFrame render
    renderer.render scene, camera
    scene.simulate undefined, 2


createHeightMap = (pn)->
    ground_material = Physijs.createMaterial(
        new THREE.MeshLambertMaterial({
            map: THREE.ImageUtils.loadTexture(
                "/static/pictures/assets/textures/ground/grasslight-big.jpg")}),
        .3, .8)
    ground_geometry = new THREE.PlaneGeometry 120, 100, 100, 100
    for i in [0..ground_geometry.vertices.length-1]
        vertex = ground_geometry.vertices[i]
        value = pn.noise vertex.x / 10, vertex.y / 10, 0
        vertex.z = value * 10
    ground_geometry.computeFaceNormals()
    ground_geometry.computeVertexNormals()

    ground = new Physijs.HeightfieldMesh(
        ground_geometry,
        ground_material,
        0,
        100,
        100)
    ground.rotation.x = Math.PI / -2
    ground.rotation.y = 0.4
    ground.receiveShadow = true
    return ground

createShape = ()->
    points = []
    for i in [0..29]
        randomX = -5 + Math.round(Math.random() * 10)
        randomY = -5 + Math.round(Math.random() * 10)
        randomZ = -5 + Math.round(Math.random() * 10)
        points.push new THREE.Vector3(randomX, randomY, randomZ)
    hullGeometry = new THREE.ConvexGeometry points
    return hullGeometry


setPosAndShade = (obj)->
    obj.position.set(
        Math.random() * 20 - 45,
        40,
        Math.random() * 20 - 5)
    obj.rotation.set(Math.random() * 2 * Math.PI, Math.random() * 2 * Math.PI, Math.random() * 2 * Math.PI)
    obj.castShadow = true

getMaterial = ()->
    material = Physijs.createMaterial(
        new THREE.MeshLambertMaterial({
            color: scale(Math.random()).hex()}), 0.5, 0.7)
    return material


createGround = ()->
    length = 120
    width = 120
    ground_material = Physijs.createMaterial(
        new THREE.MeshPhongMaterial({
            map: THREE.ImageUtils.loadTexture(
                "/static/pictures/assets/textures/general/floor-wood.jpg'")}),
        1, .7 )


    ground = new Physijs.BoxMesh(
        new THREE.BoxGeometry(length, 1, width),
        ground_material,0)

    ground.receiveShadow = true


    borderLeft = new Physijs.BoxMesh(
        new THREE.BoxGeometry(2, 6, width),
        ground_material,0)

    borderLeft.position.x = -1 * length / 2 - 1
    borderLeft.position.y = 2
    borderLeft.receiveShadow = true
    ground.add borderLeft

    
    borderRight = new Physijs.BoxMesh(
        new THREE.BoxGeometry(2, 6, width),
        ground_material,0)
    borderRight.position.x = length / 2 + 1
    borderRight.position.y = 2
    borderRight.receiveShadow = true
    ground.add borderRight


    borderBottom = new Physijs.BoxMesh(
        new THREE.BoxGeometry(width - 1, 6, 2),
        ground_material,0)

    borderBottom.position.z = width / 2
    borderBottom.position.y = 1.5
    borderBottom.receiveShadow = true
    ground.add borderBottom

    borderTop = new Physijs.BoxMesh(
        new THREE.BoxGeometry(width, 6, 2),
        ground_material,0)
    borderTop.position.z = -width / 2
    borderTop.position.y = 2
    borderTop.receiveShadow = true

    ground.position.x = 0
    ground.position.z = 0
    ground.add borderTop
    ground.receiveShadow = true
    scene.add ground


initScene = ()->
    # 场景
    scene = new Physijs.Scene {reportSize: 10, fixedTimeStep: 1 / 60}
    scene.setGravity new THREE.Vector3(0, -20, 0)
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 35, window.innerWidth/window.innerHeight, 1, 1000
    camera.position.set 105, 85, 85
    camera.lookAt new THREE.Vector3(0, 0, 0)
    scene.add camera
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.antialias = true
    webGLRenderer.setClearColor new THREE.Color(0x000000)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    renderer = webGLRenderer
    $("#viewport").append renderer.domElement

    #灯光
    ambi = new THREE.AmbientLight 0x222222
    scene.add ambi

    light = new THREE.SpotLight 0xFFFFFF
    light.position.set 40, 50, 100 
    light.castShadow = true
    light.shadowMapDebug = true
    light.shadowCameraNear = 10
    light.shadowCameraFar = 200
    light.intensity = 1.5
    scene.add light
    
    meshes = []
    # 控制条
    controls = new ()->
        this.addSphereMesh = ()->
            sphere = new Physijs.SphereMesh(
                new THREE.SphereGeometry(3, 20),getMaterial())
            setPosAndShade sphere
            meshes.push sphere
            scene.add sphere
        this.addBoxMesh = ()->
            cube = new Physijs.BoxMesh(
                new THREE.BoxGeometry(4, 2, 6),getMaterial())
            setPosAndShade cube
            meshes.push cube
            scene.add cube

        this.addCylinderMesh = ()->
            cylinder = new Physijs.CylinderMesh(
                new THREE.CylinderGeometry(2, 2, 6),getMaterial())
            setPosAndShade cylinder
            meshes.push cylinder
            scene.add cylinder
        this.addConeMesh = ()->
            cone = new Physijs.ConeMesh(
                new THREE.CylinderGeometry(0, 3, 7, 20, 10),getMaterial())
            setPosAndShade cone
            meshes.push cone
            scene.add cone
        this.addPlaneMesh = ()->
            plane = new Physijs.PlaneMesh(
                new THREE.PlaneGeometry(5, 5, 10, 10),getMaterial())
            setPosAndShade plane
            meshes.push plane
            scene.add plane
        this.addCapsuleMesh = ()->
            merged = new THREE.Geometry()
            cyl = new THREE.CylinderGeometry 2, 2, 6 
            top = new THREE.SphereGeometry 2 
            bot = new THREE.SphereGeometry 2 

            matrix = new THREE.Matrix4()
            matrix.makeTranslation 0, 3, 0
            top.applyMatrix matrix

            matrix = new THREE.Matrix4()
            matrix.makeTranslation 0, -3, 0
            bot.applyMatrix matrix

            merged.merge top
            merged.merge bot
            merged.merge cyl

            capsule = new Physijs.CapsuleMesh(merged,getMaterial())
            setPosAndShade capsule

            meshes.push capsule
            scene.add capsule
        this.addConvexMesh = ()->
            convex = new Physijs.ConvexMesh(
                new THREE.TorusKnotGeometry(0.5, 0.3, 64, 8, 2, 3, 10),getMaterial())

            setPosAndShade convex
            meshes.push convex
            scene.add convex

        this.clearMeshes = ()->
            meshes.forEach (e)->
                scene.remove e
            meshes = []
        return this
    
    # UI
    gui = new dat.GUI()
    gui.add controls, "addPlaneMesh"
    gui.add controls, "addBoxMesh"
    gui.add controls, "addSphereMesh"
    gui.add controls, "addCylinderMesh"
    gui.add controls, "addConeMesh"
    gui.add controls, "addCapsuleMesh"
    gui.add controls, "addConvexMesh"
    gui.add controls, "clearMeshes"

    date = new Date()
    pn = new Perlin("rnd" + date.getTime())
    map = createHeightMap pn
    scene.add map

    requestAnimationFrame render
    scene.simulate()

    
# 状态条
    render_stats = new Stats()
    render_stats.setMode 0
    render_stats.domElement.style.position = "absolute"
    render_stats.domElement.style.top = "1px"
    render_stats.domElement.style.zIndex = 100
    $("#viewport").append render_stats.domElement


#屏幕适配
onResize =()->
    console.log "onResize"
    camera.aspect = window.innerWidth/window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight


window.onload = initScene
window.addEventListener "resize", onResize, false
