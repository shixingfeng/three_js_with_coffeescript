console.log "demo_12.51 Physijs dof -Constraints"
camera = null
scene = null
renderer = null
mesh = null
stepX = null
direction = 1
"use strict"
scale = chroma.scale ["white", "blue", "red", "yellow"]
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
    # render_stats.update()
    requestAnimationFrame render
    renderer.render scene, camera

    scene.simulate undefined, 2



createGround = ()->
    length = 120
    width = 120
    ground_material = Physijs.createMaterial(
        new THREE.MeshPhongMaterial({
            map: THREE.ImageUtils.loadTexture(
                "/static/pictures/assets/textures/general/floor-wood.jpg")}),
        1, .7)

    ground = new Physijs.BoxMesh(
        new THREE.BoxGeometry(length, 1, width),
        ground_material,
        0)
    ground.receiveShadow = true


    borderLeft = new Physijs.BoxMesh(
        new THREE.BoxGeometry(2, 6, width),
        ground_material,
        0)
    borderLeft.position.x = -1 * length / 2 - 1
    borderLeft.position.y = 2
    borderLeft.receiveShadow = true
    ground.add borderLeft

    borderRight = new Physijs.BoxMesh(
        new THREE.BoxGeometry(2, 6, width),
        ground_material,
        0)
    borderRight.position.x = length / 2 + 1
    borderRight.position.y = 2
    borderRight.receiveShadow = true
    ground.add borderRight


    borderBottom = new Physijs.BoxMesh(
        new THREE.BoxGeometry(width - 1, 6, 2),
        ground_material,
        0)
    borderBottom.position.z = width / 2
    borderBottom.position.y = 1.5
    borderBottom.receiveShadow = true
    ground.add borderBottom

    borderTop = new Physijs.BoxMesh(
        new THREE.BoxGeometry(width, 6, 2),
        ground_material,
        0)
    borderTop.position.z = -width / 2
    borderTop.position.y = 2
    borderTop.receiveShadow = true
    ground.position.x = 20
    ground.position.z = -20
    ground.add borderTop
    ground.receiveShadow = true
    
    scene.add ground



createWheel = (position)->
    wheel_material = Physijs.createMaterial(
        new THREE.MeshLambertMaterial({
            color: 0x444444,
            opacity: 0.9,
            transparent: true}),
        1.0,
        .5)
    wheel_geometry = new THREE.CylinderGeometry 4, 4, 2, 10
    wheel = new Physijs.CylinderMesh wheel_geometry,wheel_material,100
    wheel.rotation.x = Math.PI / 2
    wheel.castShadow = true
    wheel.position.copy position
    return wheel

createCar = ()->
    car = {}
    car_material = Physijs.createMaterial(
        new THREE.MeshLambertMaterial({
            color: 0xff4444,
            opacity: 0.9,
            transparent: true}),
        .5,
        .5)
    #车身
    geom = new THREE.BoxGeometry 15, 4, 4
    body = new Physijs.BoxMesh geom, car_material, 500
    body.position.set 5, 5, 5
    body.castShadow = true
    scene.add body
    # 车轮
    fr = createWheel new THREE.Vector3(0, 4, 10)
    fl = createWheel new THREE.Vector3(0, 4, 0)
    rr = createWheel new THREE.Vector3(10, 4, 10)
    rl = createWheel new THREE.Vector3(10, 4, 0)

    # 加入场景
    scene.add fr
    scene.add fl
    scene.add rr
    scene.add rl

    frConstraint = createWheelConstraint fr, body, new THREE.Vector3(0, 4, 8)
    scene.addConstraint frConstraint

    flConstraint = createWheelConstraint fl, body, new THREE.Vector3(0, 4, 2)
    scene.addConstraint flConstraint

    rrConstraint = createWheelConstraint rr, body, new THREE.Vector3(10, 4, 8)
    scene.addConstraint rrConstraint

    rlConstraint = createWheelConstraint rl, body, new THREE.Vector3(10, 4, 2)
    scene.addConstraint rlConstraint


    
    rrConstraint.setAngularLowerLimit {x: 0, y: 0.5, z: 0.1}
    rrConstraint.setAngularUpperLimit {x: 0, y: 0.5, z: 0}
    rlConstraint.setAngularLowerLimit {x: 0, y: 0.5, z: 0.1}
    rlConstraint.setAngularUpperLimit {x: 0, y: 0.5, z: 0}


    
    frConstraint.setAngularLowerLimit {x: 0, y: 0, z: 0}
    frConstraint.setAngularUpperLimit {x: 0, y: 0, z: 0}
    flConstraint.setAngularLowerLimit {x: 0, y: 0, z: 0}
    flConstraint.setAngularUpperLimit {x: 0, y: 0, z: 0}

    
    flConstraint.configureAngularMotor 2, 0.1, 0, -2, 1500
    frConstraint.configureAngularMotor 2, 0.1, 0, -2, 1500

    flConstraint.enableAngularMotor 2
    frConstraint.enableAngularMotor 2

    car.flConstraint = flConstraint
    car.frConstraint = frConstraint
    car.rlConstraint = rlConstraint
    car.rrConstraint = rrConstraint

    return car

createWheelConstraint = (wheel, body, position)->
    constraint = new Physijs.DOFConstraint(wheel, body, position)
    return constraint


initScene = ()->
    projector = new THREE.Projector

    # 场景
    scene = new Physijs.Scene {reportSize: 10, fixedTimeStep: 1 / 60}
    scene.setGravity new THREE.Vector3(0, -10, 0)
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 35, window.innerWidth/window.innerHeight, 1, 1000
    camera.position.set 85, 65, 65
    camera.lookAt new THREE.Vector3(0, 0, 0)
    scene.add camera
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.antialias = true
    webGLRenderer.setClearColor new THREE.Color(0x000000)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer
    $("#viewport").append renderer.domElement

    #灯光
    light = new THREE.SpotLight 0xFFFFFF 
    light.position.set 20, 50, 50 
    light.castShadow = true
    light.shadowMapDebug = true
    light.shadowCameraNear = 10
    light.shadowCameraFar = 100
    scene.add light
    
    meshes = []
    createGround()
    car = createCar()
    
    # 控制条
    controls = new ()->
        this.velocity = -2
        this.wheelAngle = 0.5
        this.loosenXRight = 0.0001
        this.loosenXLeft = 0.0001
        this.changeVelocity = ()->
            car.flConstraint.configureAngularMotor 2, 0.1, 0, controls.velocity, 15000
            car.frConstraint.configureAngularMotor 2, 0.1, 0, controls.velocity, 15000
            car.flConstraint.enableAngularMotor 2
            car.frConstraint.enableAngularMotor 2
    
        this.changeOrientation = ()->
            car.rrConstraint.setAngularLowerLimit {x: 0, y: controls.wheelAngle, z: 0.1}
            car.rrConstraint.setAngularUpperLimit {x: controls.loosenXRight, y: controls.wheelAngle, z: 0}
            car.rlConstraint.setAngularLowerLimit {x: controls.loosenXLeft, y: controls.wheelAngle, z: 0.1}
            car.rlConstraint.setAngularUpperLimit {x: 0, y: controls.wheelAngle, z: 0}
        return this
    

    # UI
    gui = new dat.GUI()
    gui.add(controls, "velocity", -10, 10).onChange controls.changeVelocity
    gui.add(controls, "wheelAngle", -1, 1).onChange controls.changeOrientation
    gui.add(controls, "loosenXRight", 0, 0.5).step(0.01).onChange controls.changeOrientation
    gui.add(controls, "loosenXLeft", 0, 0.6).step(-0.01).onChange controls.changeOrientation
    controls.loosenXLeft = 0
    controls.loosenXRight = 0

    requestAnimationFrame render
    scene.simulate()

    
# 状态条
    # render_stats = new Stats()
    # render_stats.setMode 0
    # render_stats.domElement.style.position = "absolute"
    # render_stats.domElement.style.top = "1px"
    # render_stats.domElement.style.zIndex = 100
    # $("#viewport").append render_stats.domElement


#屏幕适配
onResize =()->
    console.log "onResize"
    camera.aspect = window.innerWidth/window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight


window.onload = initScene
window.addEventListener "resize", onResize, false