console.log "demo_12.61 misc - sound"
camera = null
scene = null
renderer = null
mesh = null
stepX = null
direction = 1
container = null
controls = null
light = null
pointLight = null
material_sphere1 = null
material_sphere2 = null
clock = new THREE.Clock()

# 渲染
render = ()->
    delta = clock.getDelta()
    time = clock.getElapsedTime() * 5
    controls.update delta
    renderer.render scene, camera
#屏幕适配
onResize =()->
    console.log "onResize"
    camera.aspect = window.innerWidth/window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight
    controls.handleResize()
# 动画
animate = ()->
    requestAnimationFrame animate
    render()
# 主题
init = ()->
    container = $("container")

    # 场景
    scene = new THREE.Scene()
    scene.fog = new THREE.FogExp2 0x000000, 0.0035 
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 50, window.innerWidth/window.innerHeight, 1, 10000
    camera.position.set -200, 25, 0
    
    listener1 = new THREE.AudioListener()
    listener2 = new THREE.AudioListener()
    listener3 = new THREE.AudioListener()
    camera.add listener1
    camera.add listener2
    camera.add listener3

    #第一人称视角 
    controls = new THREE.FirstPersonControls camera
    controls.movementSpeed = 70
    controls.lookSpeed = 0.15
    controls.noFly = true
    controls.lookVertical = false


    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.antialias = true
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    renderer = webGLRenderer
    


    #灯光
    light = new THREE.DirectionalLight 0xffffff
    light.position.set(0, 0.5, 1).normalize()
    scene.add light
    

    # 物体
    cube = new THREE.BoxGeometry 40, 40, 40
    material_1 = new THREE.MeshBasicMaterial {
        color: 0xffffff,
        map: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/animals/cow.png")}

    material_2 = new THREE.MeshBasicMaterial {
        color: 0xffffff,
        map: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/animals/dog.jpg")}

    material_3 = new THREE.MeshBasicMaterial {
        color: 0xffffff,
        map: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/animals/cat.jpg")}


    mesh1 = new THREE.Mesh cube, material_1
    mesh2 = new THREE.Mesh cube, material_2
    mesh3 = new THREE.Mesh cube, material_3
    mesh1.position.set 0, 20, 100
    mesh2.position.set 0, 20, 0
    mesh3.position.set 0, 20, -100

    scene.add mesh1
    scene.add mesh2
    scene.add mesh3

    sound1 = new THREE.Audio listener1
    sound1.load "/static/pictures/assets/audio/cow.ogg"
    sound1.setRefDistance 20
    sound1.setLoop true
    sound1.setRolloffFactor 2
    mesh1.add sound1

    sound2 = new THREE.Audio listener2
    sound2.load "/static/pictures/assets/audio/dog.ogg"
    sound2.setRefDistance 20
    sound2.setLoop true
    sound2.setRolloffFactor 2
    mesh2.add sound2

    sound3 = new THREE.Audio listener3
    sound3.load "/static/pictures/assets/audio/cat.ogg"
    sound3.setRefDistance 20
    sound3.setLoop true
    sound3.setRolloffFactor 2
    mesh3.add sound3

    helper = new THREE.GridHelper 500, 10
    helper.color1.setHex 0x444444
    helper.color2.setHex 0x444444
    helper.position.y = 0.1
    scene.add helper

    # container.innerHTML = ""
    container.append renderer.domElement
    window.addEventListener "resize", onResize, false
    animate()


window.onload = init()