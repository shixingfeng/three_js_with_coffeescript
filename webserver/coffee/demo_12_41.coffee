console.log "demo_12.41 Physijs Constraints"
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
    ground.__dirtyRotation = true

    scene.simulate undefined, 2


createConeTwist = ()->
    baseMesh = new THREE.SphereGeometry 1
    armMesh = new THREE.BoxGeometry 2, 12, 3

    objectOne = new Physijs.BoxMesh(
        baseMesh, Physijs.createMaterial(
            new THREE.MeshPhongMaterial({
                color: 0x4444ff,
                transparent: true,
                opacity: 0.7}),
            0, 0),0)
    objectOne.position.z = 0
    objectOne.position.x = 20
    objectOne.position.y = 15.5
    objectOne.castShadow = true
    scene.add objectOne


    objectTwo = new Physijs.SphereMesh(
        armMesh, Physijs.createMaterial(
            new THREE.MeshPhongMaterial({
                color: 0x4444ff,
                transparent: true,
                opacity: 0.7}),
            0, 0), 10)
    objectTwo.position.z = 0
    objectTwo.position.x = 20
    objectTwo.position.y = 7.5
    scene.add objectTwo

    objectTwo.castShadow = true

    constraint = new Physijs.ConeTwistConstraint(
        objectOne,
        objectTwo,
        objectOne.position)

    scene.addConstraint constraint
    constraint.setLimit 0.5 * Math.PI, 0.5 * Math.PI, 0.5 * Math.PI
    constraint.setMaxMotorImpulse(1);
    constraint.setMotorTarget new THREE.Vector3(0, 0, 0)
    return constraint

createPointToPoint= ()->
    obj1 = new THREE.SphereGeometry 2
    obj2 = new THREE.SphereGeometry 2

    objectOne = new Physijs.SphereMesh(
        obj1, Physijs.createMaterial(
            new THREE.MeshPhongMaterial({
                color: 0xff4444,
                transparent: true,
                opacity: 0.7}),
            0, 0))
    objectOne.position.z = -18
    objectOne.position.x = -10
    objectOne.position.y = 2
    objectOne.castShadow = true
    scene.add objectOne

    objectTwo = new Physijs.SphereMesh(
        obj2, Physijs.createMaterial(
            new THREE.MeshPhongMaterial({
                color: 0xff4444,
                transparent: true,
                opacity: 0.7}),
            0, 0))
    objectTwo.position.z = -5
    objectTwo.position.x = -20
    objectTwo.position.y = 2
    objectTwo.castShadow = true
    scene.add objectTwo

    constraint = new Physijs.PointConstraint objectOne, objectTwo, objectTwo.position
    scene.addConstraint constraint

 createSliderBottom = ()->
    sliderCube = new THREE.BoxGeometry 12, 2, 2
    sliderMesh = new Physijs.BoxMesh(
        sliderCube, Physijs.createMaterial(
            new THREE.MeshPhongMaterial({
                color: 0x44ff44,
                opacity: 0.6,
                transparent: true}),
            0, 0), 0.01)
    sliderMesh.position.z = 20
    sliderMesh.position.x = 6
    sliderMesh.position.y = 1.5
    sliderMesh.castShadow = true


    scene.add sliderMesh
    constraint = new Physijs.SliderConstraint(
        sliderMesh,
        new THREE.Vector3(0, 0, 0),
        new THREE.Vector3(0, 1, 0))
    scene.addConstraint constraint
    constraint.setLimits -10, 10, 0, 0
    constraint.setRestitution 0.1, 0.1
    return constraint

createSliderTop = ()->
    sliderSphere = new THREE.BoxGeometry 7, 2, 7


    sliderMesh = new Physijs.BoxMesh(
        sliderSphere, Physijs.createMaterial(
            new THREE.MeshPhongMaterial({
                color: 0x44ff44,
                transparent: true,
                opacity: 0.5}),
            0, 0), 10)
    sliderMesh.position.z = -15
    sliderMesh.position.x = -20
    sliderMesh.position.y = 1.5
    scene.add sliderMesh
    sliderMesh.castShadow = true

    constraint = new Physijs.SliderConstraint(
        sliderMesh,
        new THREE.Vector3(-10, 0, 20),
        new THREE.Vector3(Math.PI / 2, 0, 0))

    scene.addConstraint constraint
    constraint.setLimits -20, 10, 0.5, -0, 5
    constraint.setRestitution 0.2, 0.1
    return constraint

createLeftFlipper = ()->
    flipperLeft = new Physijs.BoxMesh(
        new THREE.BoxGeometry(12, 2, 2),
        Physijs.createMaterial(
            new THREE.MeshPhongMaterial({
                opacity: 0.6,
                transparent: true})),
        0.3)
    flipperLeft.position.x = -6
    flipperLeft.position.y = 2
    flipperLeft.position.z = 0
    flipperLeft.castShadow = true
    scene.add flipperLeft
    flipperLeftPivot = new Physijs.SphereMesh(
        new THREE.BoxGeometry(1, 1, 1),
        ground_material, 0)

    flipperLeftPivot.position.y = 1
    flipperLeftPivot.position.x = -15
    flipperLeftPivot.position.z = 0
    flipperLeftPivot.rotation.y = 1.4
    flipperLeftPivot.castShadow = true
    scene.add flipperLeftPivot
    
    constraint = new Physijs.HingeConstraint(
        flipperLeft,
        flipperLeftPivot,
        flipperLeftPivot.position,
        new THREE.Vector3(0, 1, 0))
    scene.addConstraint constraint
    constraint.setLimits -2.2, -0.6, 0.1, 0
    return constraint

createRightFlipper = ()->
    flipperright = new Physijs.BoxMesh(
        new THREE.BoxGeometry(12, 2, 2),
        Physijs.createMaterial(
            new THREE.MeshPhongMaterial({
                opacity: 0.6,
                transparent: true})),
        0.3)
    flipperright.position.x = 8
    flipperright.position.y = 2
    flipperright.position.z = 0
    flipperright.castShadow = true
    scene.add flipperright 
    
    flipperLeftPivot = new Physijs.SphereMesh(
        new THREE.BoxGeometry(1, 1, 1),
        ground_material, 0)

    flipperLeftPivot.position.y = 2
    flipperLeftPivot.position.x = 15
    flipperLeftPivot.position.z = 0
    flipperLeftPivot.rotation.y = 1.4
    flipperLeftPivot.castShadow = true

    scene.add flipperLeftPivot       
    constraint = new Physijs.HingeConstraint(
        flipperright,
        flipperLeftPivot, 
        flipperLeftPivot.position,
        new THREE.Vector3(0, 1, 0))
    scene.addConstraint constraint
    constraint.setLimits -2.2, -0.6, 0.1, 0
    return constraint



createGround = ()->
    ground_material = Physijs.createMaterial(
        new THREE.MeshPhongMaterial({
            map: THREE.ImageUtils.loadTexture(
                "/static/pictures/assets/textures/general/floor-wood.jpg")}),
        .9, .7)

    ground = new Physijs.BoxMesh(
        new THREE.BoxGeometry(60, 1, 65),
        ground_material,0)
    ground.receiveShadow = true


    borderLeft = new Physijs.BoxMesh(
        new THREE.BoxGeometry(2, 6, 65),
        ground_material,0)
    borderLeft.position.x = -31
    borderLeft.position.y = 2
    borderLeft.receiveShadow = true
    ground.add borderLeft

    borderRight = new Physijs.BoxMesh(
        new THREE.BoxGeometry(2, 6, 65),
        ground_material,0)
    borderRight.position.x = 31
    borderRight.position.y = 2
    borderRight.receiveShadow = true
    ground.add borderRight


    borderBottom = new Physijs.BoxMesh(
        new THREE.BoxGeometry(64, 6, 2),
        ground_material,0)

    borderBottom.position.z = 32
    borderBottom.position.y = 1.5
    borderBottom.receiveShadow = true
    ground.add borderBottom

    borderTop = new Physijs.BoxMesh(
        new THREE.BoxGeometry(64, 6, 2),
        ground_material,0)

    borderTop.position.z = -32
    borderTop.position.y = 2
    borderTop.receiveShadow = true
    ground.add borderTop

    ground.receiveShadow = true
    scene.add ground


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
    flipperLeftConstraint = createLeftFlipper()
    flipperRightConstraint = createRightFlipper()
    sliderBottomConstraint = createSliderBottom()
    sliderTopConstraint = createSliderTop()
    coneTwistConstraint = createConeTwist()
    point2point = createPointToPoint true

    # 控制条
    controls = new ()->
        this.enableMotor = false
        this.acceleration = 2
        this.velocity = -10

        this.enableConeTwistMotor = false
        this.motorTargetX = 0
        this.motorTargetY = 0
        this.motorTargetZ = 0

        this.updateCone = ()->
            if controls.enableConeTwistMotor
                coneTwistConstraint.enableMotor()
                coneTwistConstraint.setMotorTarget new THREE.Vector3(controls.motorTargetX, controls.motorTargetY, controls.motorTargetZ)
            else
                coneTwistConstraint.disableMotor()
        this.updateMotor = ()->
            if controls.enableMotor
                flipperLeftConstraint.disableMotor()
                flipperLeftConstraint.enableAngularMotor controls.velocity, controls.acceleration 
                flipperRightConstraint.disableMotor()
                flipperRightConstraint.enableAngularMotor -1 * controls.velocity, controls.acceleration 
            else 
                flipperLeftConstraint.disableMotor()
                flipperRightConstraint.disableMotor()
        this.sliderLeft = ()->
            sliderBottomConstraint.disableLinearMotor()
            sliderBottomConstraint.enableLinearMotor controls.velocity, controls.acceleration 
            sliderTopConstraint.disableLinearMotor()
            sliderTopConstraint.enableLinearMotor controls.velocity, controls.acceleration 

        this.sliderRight = ()->
            sliderBottomConstraint.disableLinearMotor()
            sliderBottomConstraint.enableLinearMotor -1 * controls.velocity, controls.acceleration
            sliderTopConstraint.disableLinearMotor()
            sliderTopConstraint.enableLinearMotor -1 * controls.velocity, controls.acceleration
        
        this.clearMeshes = ()->
            meshes.forEach (e)->
                scene.remove e
            meshes = []

        this.addSpheres = ()->
            colorSphere = scale(Math.random()).hex()
            for i in [0..4]
                box = new Physijs.SphereMesh(
                    new THREE.SphereGeometry(2, 20),
                    Physijs.createMaterial(
                        new THREE.MeshPhongMaterial({
                            color: colorSphere,
                            opacity: 0.8,
                            transparent: true}),
                        controls.sphereFriction,
                        controls.sphereRestitution)
                    , 0.1)
                box.castShadow = true
                box.receiveShadow = true
                box.position.set(
                    Math.random() * 50 - 25,
                    20 + Math.random() * 5,
                    Math.random() * 5)
                meshes.push box
                scene.add box
        return this
    
    controls.updateMotor()

    # UI
    gui = new dat.GUI()
    gui.domElement.style.position = "absolute"
    gui.domElement.style.top = "20px"
    gui.domElement.style.left = "20px"

    generalFolder = gui.addFolder "general"
    generalFolder.add(controls, "acceleration", 0, 15).onChange controls.updateMotor 
    generalFolder.add(controls, "velocity", -10, 10).onChange controls.updateMotor 

    hingeFolder = gui.addFolder "hinge"
    hingeFolder.add(controls, "enableMotor").onChange controls.updateMotor 

    sliderFolder = gui.addFolder "sliders"
    sliderFolder.add(controls, "sliderLeft").onChange controls.sliderLeft 
    sliderFolder.add(controls, "sliderRight").onChange controls.sliderRight 

    coneTwistFolder = gui.addFolder "coneTwist"
    coneTwistFolder.add(controls, "enableConeTwistMotor").onChange controls.updateCone 
    coneTwistFolder.add(controls, "motorTargetX", -Math.PI / 2, Math.PI / 2).onChange controls.updateCone 
    coneTwistFolder.add(controls, "motorTargetY", -Math.PI / 2, Math.PI / 2).onChange controls.updateCone 
    coneTwistFolder.add(controls, "motorTargetZ", -Math.PI / 2, Math.PI / 2).onChange controls.updateCone 

    spheresFolder = gui.addFolder "spheres"
    spheresFolder.add(controls, "clearMeshes").onChange controls.updateMotor 
    spheresFolder.add(controls, "addSpheres").onChange controls.updateMotor 

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