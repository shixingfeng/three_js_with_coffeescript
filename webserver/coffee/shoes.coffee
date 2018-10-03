# console.log "启用coffee shoes"
orbitControls = null
orbitControls_rotateLeft = 0
orbitControls_rotateRight = 0
camera = null
scene = null
renderer = null
client_x = parseInt $(".shoes_models_page").css("width")
client_y = parseInt $(".shoes_models_page").css("height")
# console.log  client_x
# console.log  client_y
mousemove_time_save = null
can_move = false
step = 0

if window.navigator.userAgent.indexOf("Mobile")>=0
    renderer_size = window.innerWidth
else
    renderer_size = 500
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
    fov = 10
    camera = new THREE.PerspectiveCamera fov, 1/1, 0.1, 1000    
    camera.position.x = 0
    camera.position.y = 25
    camera.position.z = 15
    camera_fov = camera.fov
    camera.lookAt scene.position
    
    camera_x = camera.position.x
    camera_y =camera.position.y
    camera_z =camera.position.z
    
    scene.add camera
    # console.log camera_x,camera_y,camera_z
    console.log camera_fov
    

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
    renderer.setClearColor new THREE.Color 0xcccccc, 1.0
    # renderer.setSize window.innerWidth, window.innerHeight
    renderer.setSize renderer_size,renderer_size
    renderer.shadowMapEnabled = true
    
    # 自然光和散射光2个方向
    ambiLight = new THREE.AmbientLight 0x111111
    ambiLight.intensity = 1
    scene.add ambiLight
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -20, 30, 40
    spotLight.intensity = 1
    scene.add spotLight
    spotLight2 = new THREE.SpotLight 0xffffff
    spotLight2.position.set 20, -30, -40
    spotLight2.intensity = 1
    scene.add spotLight2
    spotLight3 = new THREE.SpotLight 0xffffff
    spotLight3.position.set -20, -30, -40
    spotLight3.intensity = 1
    scene.add spotLight3


    # controls = new ()->
    #     this.camera_x = 0
    #     this.camera_y = 0
    #     this.camera_z = 0
    #     this.camera_fov = 10
    #     return this

    # gui = new dat.GUI()
    # gui.add controls, "camera_x", 0, 10
    # gui.add controls, "camera_y", 0, 10
    # gui.add controls, "camera_z", 0, 10
    # gui.add controls, "camera_fov",0, 40



    #载入商品
    loader = new THREE.STLLoader()
    group = new THREE.Object3D()
    add_uri = "/static/pictures/assets/models/"
    loader.load add_uri+"naike.stl", (geometry)->
        mat = new THREE.MeshPhongMaterial {color: 0xe03600}
        group = new THREE.Mesh geometry, mat
        group.rotation.x = -0.5 * Math.PI
        # group.rotation.y = -0.1 * Math.PI
        group.rotation.z = 0.2 * Math.PI
        group.scale.set 0.05, 0.05, 0.05
        geometry.center()
        scene.add group

    # 执行画面循环，调用渲染器本身，并将结果渲染到页面中去
    renderScene = ()->
        delta = clock.getDelta()
        orbitControls.rotateLeft(orbitControls_rotateLeft)
        orbitControls.rotateRight(orbitControls_rotateRight)
        orbitControls.update(delta)
            
        # scene.traverse (e)->
        #     if e instanceof THREE.Mesh
        #         e.position.x = controls.camera_x
        #         e.position.y = controls.camera_y
        #         e.position.z = controls.camera_z
        #         camera.fov = controls.camera_fov
        #         e.position.x = controls.camera_x
        #         e.position.y = controls.camera_y
        #         e.position.z = controls.camera_z
        #         e.fov = controls.camera_fov
        #         camera.fov = controls.camera_fov
        #         console.log e
        #         # e.getEffortFOV = controls.camera_fov
        #         # e.fov = e.getEffortFOV            
        #         # console.log "===1===", e.getEffortFOV,"========"
        #         # console.log "===2===",e.fov,"========"
        
        camera.updateProjectionMatrix()
        requestAnimationFrame renderScene
        renderer.render scene, camera

        

    # 执行渲染，监听屏幕变化
    renderScene()
    # window.addEventListener "resize", onResize, false
    $("#WebGL-output").append renderer.domElement

# # 屏幕适配
# onResize = ()->
#     console.log "onResize"
#     camera.aspect= 1/1
#     camera.updateProjectionMatrix()
#     renderer.setSize 500,500


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


$("body").append"""
    <button id="controls_left_90" style="position:absolute;top:70px;display:none">rotateLeft_90</button>
    <button id="controls_right_90" style="position:absolute;top:100px;display:none">rotateRight_90</button>
    <button id="controls_left_180" style="position:absolute;top:130px;display:none">rotateLeft_180</button>
    <button id="controls_right_180" style="position:absolute;top:160px;display:none">rotateRight_180</button>
    <button id="controls_left_360" style="position:absolute;top:190px;display:none">rotateleft_360</button>
    <button id="controls_right_360" style="position:absolute;top:220px;display:none">rotateRight_360</button>
"""
turn_left_90= document.getElementById("controls_left_90")
turn_right_90 = document.getElementById("controls_right_90")
turn_left_180 = document.getElementById("controls_left_180")
turn_right_180 = document.getElementById("controls_right_180")
turn_left_360 = document.getElementById("controls_left_360")
turn_right_360 = document.getElementById("controls_right_360")
zero = document.getElementById("tozero")



# 鼠标移动时
# $("body").on "mousedown",".shoes_models_page",(e)->
#     DEMO_3D_MOVE = true
#     e.stopPropagation()
#     e.preventDefault()
#     can_move = true
#     mousedown_x = e.clientX
#     mousedown_y = e.clientY

# $(window).on "mousemove", (e)->
#     if can_move
#         console.log "可移动"

# $(window).on "mouseup",(e)->
#     can_move = false





        # clearTimeout hotpoor_translate_save
        # hotpoor_translate_save = setTimeout ()->
        # ,500

# 事件触发
turn_left_90.addEventListener "click", (e)->
    orbitControls_rotate(0.025,0)
    console.log  "左移90"
turn_right_90.addEventListener "click", (e)->
    orbitControls_rotate(-0.025,0)
    console.log  "右移90"





# turn_left_180.addEventListener "click", (e)->
#     orbitControls_rotate(Math.PI/180*180/100.0,0)
#     console.log "Click_left_180"

# turn_right_180.addEventListener "click", (e)->
#     orbitControls_rotate(-0.5,0)
#     console.log "Click_right_180"

# turn_left_360.addEventListener "click", (e)->
#     orbitControls_rotate(0.1,0)
#     console.log "Click_left_360"

# turn_right_360.addEventListener "click", (e)->
#     orbitControls_rotate(-0.1,0)
#     console.log "Click_right_360"

