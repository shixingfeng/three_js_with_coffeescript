console.log "demo_12.11 Physijs"
camera = null
scene = null
renderer = null
mesh = null
stepX = null

"use strict"
scale = chroma.scale ["green", "white"]
Physijs.scripts.worker = "/static/js/libs/physijs_worker.js"
Physijs.scripts.ammo = "/static/js/libs/ammo.js"
initScene = []
render = []
applyForce = []
setMousePosition = []
mouse_position = []
ground_material = []
box_material = []
renderer = []
render_stats = []
scene = []
ground = []
light = []
camera = []
box = []
boxes = []


createGround = ()->
    ground_material = Physijs.createMaterial new THREE.MeshPhongMaterial({map: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/general/wood-2.jpg")}), .9, .3
    ground = new Physijs.BoxMesh(new THREE.BoxGeometry(60, 1, 60), ground_material, 0)
    
    borderLeft = new Physijs.BoxMesh(new THREE.BoxGeometry(2, 3, 60), ground_material, 0)
    borderLeft.position.x = -31
    borderLeft.position.y = 2
    ground.add borderLeft

    borderRight = new Physijs.BoxMesh(new THREE.BoxGeometry(2, 3, 60), ground_material, 0)
    borderRight.position.x = 31
    borderRight.position.y = 2
    ground.add borderRight

    borderBottom = new Physijs.BoxMesh(new THREE.BoxGeometry(64, 3, 2), ground_material, 0)
    borderBottom.position.z = 30
    borderBottom.position.y = 2
    ground.add borderBottom

    borderTop = new Physijs.BoxMesh(new THREE.BoxGeometry(64, 3, 2), ground_material, 0)
    borderTop.position.z = -30
    borderTop.position.y = 2
    ground.add borderTop
    scene.add ground

getPoints = ()->
    points = []
    r = 27
    cX = 0
    cY = 0

    circleOffset = 0
    for i in [0..999] by  6 + circleOffset
        circleOffset = 4.5 * (i / 360)
        x = (r / 1440) * (1440 - i) * Math.cos(i * (Math.PI / 180)) + cX
        z = (r / 1440) * (1440 - i) * Math.sin(i * (Math.PI / 180)) + cY
        y = 0
        points.push new THREE.Vector3(x, y, z)
    return points

# 实时渲染
render = ()->
    render_stats.update()
    
    requestAnimationFrame render
    renderer.render scene, camera
    
    scene.simulate undefined, 1



initScene = ()->
    # 场景
    scene = new Physijs.Scene
    scene.setGravity new THREE.Vector3(0, -50, 0)
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 35, window.innerWidth/window.innerHeight, 1, 1000
    camera.position.set 50, 30, 50
    camera.lookAt new THREE.Vector3(10, 0, 10)
    scene.add camera
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.antialias = true
    webGLRenderer.setClearColor new THREE.Color(0x000000)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    renderer = webGLRenderer
    $("#viewport").append renderer.domElement

    #灯光
    light = new THREE.SpotLight 0xFFFFFF
    light.position.set 20, 100, 50
    scene.add light
    
    createGround()
    
    points = getPoints()
    stones = []
    
    requestAnimationFrame render

    # 控制条
    controls = new ()->
        this.gravityX = 0
        this.gravityY = -50
        this.gravityZ = 0
        this.resetScene = ()->
            scene.setGravity new THREE.Vector3(controls.gravityX, controls.gravityY, controls.gravityZ)
            stones.forEach (st)->
                scene.remove(st)
            stones = []
            points.forEach (point)->
                stoneGeom = new THREE.BoxGeometry 0.6, 6, 2
                stone = new Physijs.BoxMesh(
                    stoneGeom,
                    Physijs.createMaterial(
                        new THREE.MeshPhongMaterial({
                            color: scale(Math.random()).hex(),
                            transparent: true,
                            opacity: 0.8,})))
                console.log stone.position
                stone.position.copy point
                stone.lookAt scene.position
                stone.__dirtyRotation = true
                stone.position.y = 3.5

                scene.add stone
                stones.push stone

            stones[0].rotation.x = 0.2
            stones[0].__dirtyRotation = true
        return this
    
    # UI
    gui = new dat.GUI()
    gui.add controls, "gravityX", -100, 100
    gui.add controls, "gravityY", -100, 100
    gui.add controls, "gravityZ", -100, 100
    gui.add controls, "resetScene"

    controls.resetScene()
    
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
