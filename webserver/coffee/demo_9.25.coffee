console.log "启用coffee demo_9.25"
orbitControls = null
orbitControls_rotateLeft = 0
orbitControls_rotateRight = 0
camera = null
scene = null
renderer = null
offset = 0
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -20
    camera.position.y = 30
    camera.position.z = 80
    camera.lookAt new THREE.Vector3(0, 0, 0)

    # 摄像机控件
    orbitControls = new THREE.OrbitControls camera   
    orbitControls.autoRotate = false
    orbitControls.userZoom = false

    orbitControls.minPolarAngle = Math.PI/4.0
    orbitControls.maxPolarAngle = Math.PI/2.0

    orbitControls.userRotate = true
    # 键盘监听
    orbitControls.userPan = false


    clock = new THREE.Clock()

    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0x000, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    
    # 创建地面方块
    createMesh = (geom) ->
        planeGeometry = new THREE.PlaneGeometry 60, 20, 1, 1
        planetTexture = THREE.ImageUtils.loadTexture "/static/pictures/starry-deep-outer-space-galaxy.jpg"
        normalTexture = THREE.ImageUtils.loadTexture "/static/pictures/starry-deep-outer-space-galaxy.jpg"
        planetMaterial = new THREE.MeshPhongMaterial {map: planetTexture, bumpMap: normalTexture}
        
        wireFrameMat = new THREE.MeshBasicMaterial()
        wireFrameMat.wireframe = true
        
        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [planetMaterial]
        return mesh
    
    # 创建网格上的物体
    sphere = createMesh new THREE.SphereGeometry(20, 40, 40)
    scene.add sphere
    

    #灯光
    ambiLight = new THREE.AmbientLight 0x111111
    scene.add ambiLight
        
    spotLight = new THREE.DirectionalLight 0xffffff
    spotLight.position.set -20, 30, 40
    spotLight.intensity = 1.5
    scene.add spotLight


    # 控制台
    # controls = new ()->
        
    #控制条UI
    # gui = new dat.GUI()
    
    # 实时渲染
    step = 0
    renderScene = ()->
        stats.update()
        
        delta = clock.getDelta()
        orbitControls.rotateLeft(orbitControls_rotateLeft)
        orbitControls.rotateRight(orbitControls_rotateRight)
        orbitControls.update(delta)


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

# 屏幕适配
onResize = ()->
    console.log "onResize"
    camera.aspect= window.innerWidth/window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight


orbitControls_rotate_timeout =null
window.orbitControls_rotate = (angleX,angleY)->
    orbitControls_rotateLeft = angleX
    orbitControls_rotateRight = angleY
    
    clearTimeout orbitControls_rotate_timeout
    orbitControls_rotate_timeout = setTimeout ()->
            orbitControls_rotateLeft = 0
            orbitControls_rotateRight = 0
        ,1000

window.onload = init()
window.addEventListener "resize", onResize, false

$("body").append"""
    <button id="controls_left_90" style="position:absolute;top:70px">rotateLeft_90</button>
    <button id="controls_right_90" style="position:absolute;top:100px">rotateRight_90</button>
    <button id="controls_left_180" style="position:absolute;top:130px">rotateLeft_180</button>
    <button id="controls_right_180" style="position:absolute;top:160px">rotateRight_180</button>
    <button id="controls_left_360" style="position:absolute;top:190px">rotateleft_360</button>
    <button id="controls_right_360" style="position:absolute;top:220px">rotateRight_360</button>
    <button id="tozero" style="position:absolute;top:250px">zero</button>

"""
turn_left_90= document.getElementById("controls_left_90")
turn_right_90 = document.getElementById("controls_right_90")
turn_left_180 = document.getElementById("controls_left_180")
turn_right_180 = document.getElementById("controls_right_180")
turn_left_360 = document.getElementById("controls_left_360")
turn_right_360 = document.getElementById("controls_right_360")
zero = document.getElementById("tozero")

zero.addEventListener "click", (e)->
    console.log "归位"
    offset_now  = offset-0 
    orbitControls_rotate(offset_now,0)
    offset = offset-offset_now 
    console.log offset

turn_left_90.addEventListener "click", (e)->
    console.log "左转90°"
    offset_now = offset - 0.025
    # 
    if offset_now < -0.2
        offset_now = offset-(-0.2)
        orbitControls_rotate(offset_now,0)
        offset = -0.2
        return
    # 继续转，直至超出0.2
    else
        orbitControls_rotate(0.025,0)
        offset = offset-0.025
    console.log "向左转了"+offset+"量"


# turn_right_90.addEventListener "click", (e)->
#     orbitControls_rotate(-0.025,0)
#     console.log "Click_right_90"
#     delta_0 = delta_0-(-0.025)
#     console.log delta_0
# turn_left_180.addEventListener "click", (e)->
#     console.log "Click_left_180"
#     orbitControls_rotate(Math.PI/180*180/100.0,0)
#     delta_0 = delta_0-(Math.PI/180*180/100.0)
#     console.log delta_0
# turn_right_180.addEventListener "click", (e)->
#     orbitControls_rotate(-0.5,0)
#     console.log "Click_right_180"
#     delta_0 = delta_0-(-0.5)    
#     console.log delta_0
# turn_left_360.addEventListener "click", (e)->
#     console.log "Click_left_360"
#     orbitControls_rotate(0.1,0)
#     delta_0 = delta_0-0.1
#     console.log delta_0
# turn_right_360.addEventListener "click", (e)->
#     orbitControls_rotate(-0.1,0)
#     console.log "Click_right_360"
#     delta_0 = delta_0-(-0.1)
#     console.log delta_0