console.log "启用coffee demo_3.31"
orbitControls = null
orbitControls_rotateLeft = 0
orbitControls_rotateRight = 0
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
    orbitControls.maxPolarAngle = Math.PI/4.0

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
        planetTexture = THREE.ImageUtils.loadTexture "/static/pictures/mars_1k_color.jpg"
        normalTexture = THREE.ImageUtils.loadTexture "/static/pictures/mars_1k_normal.jpg"
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
    camera.update ProjectionMatrix()
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
    <button id="controls_left" style="position:absolute;top:73px">rotateLeft</button>
    <button id="controls_right" style="position:absolute;top:100px">rotateRight</button>
"""
turn_left = document.getElementById("controls_left")
turn_right = document.getElementById("controls_right")

turn_left.addEventListener "click", (e)->
    console.log "Click_left"
    orbitControls_rotate(0.03,0)
turn_right.addEventListener "click", (e)->
    orbitControls_rotate(-0.03,0)
    console.log "Click_right"

