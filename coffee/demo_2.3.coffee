console.log "启用coffee demo_2.3"
camera = null
scene = null
renderer = null
controls = null
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 120
    camera.position.y = 60
    camera.position.z = 180
    camera.lookAt scene.position
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0xEEEEEE, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    
    # 物体材质和几何
    planeGeometry = new THREE.PlaneGeometry 180, 180
    planeMaterial = new THREE.MeshLambertMaterial {color:0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial

    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 0
    plane.position.y = 0
    plane.position.z = 0
    plane.receiveShadow = true
    scene.add plane
    
    # 环境光
    ambientLight = new THREE.AmbientLight 0x292929
    scene.add ambientLight

    # 点光源
    # spotLight = new THREE.SpotLight 0xffffff
    # spotLight.position.set -40, 60, -10
    # spotLight.castShadow = true
    # scene.add spotLight

    # 方向灯
    directionalLight = new THREE.DirectionalLight 0xffffff, 0.7
    directionalLight.position.set -20, 40, 60
    scene.add directionalLight

    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    for j in [0..planeGeometry.parameters.height / 5]
        for i in[0..planeGeometry.parameters.width / 5]
            rnd = Math.random() * 0.75 + 0.25
            cubeMaterial = new THREE.MeshLambertMaterial()
            cubeMaterial.color = new THREE.Color rnd, 0, 0
            
            cube = new THREE.Mesh(cubeGeometry, cubeMaterial)
            cube.position.z = -((planeGeometry.parameters.height) / 2) + 2 + (j * 5)
            cube.position.x = -((planeGeometry.parameters.width) / 2) + 2 + (i * 5)
            cube.position.y = 2

            scene.add(cube);

    # 控制台
    controls = new ()->
       this.perspective = "Perspective"
       this.switchCamera = ()->
            if camera instanceof THREE.PerspectiveCamera
                camera = new THREE.OrthographicCamera window.innerWidth / -16, window.innerWidth / 16, window.innerHeight / 16, window.innerHeight / -16, -200, 500
                camera.position.x = 120
                camera.position.y = 60
                camera.position.z = 180
                camera.lookAt scene.position
                this.perspective = "Orthographic"
            else
                camera = new THREE.PerspectiveCamera 45, window.innerWidth / window.innerHeight, 0.1, 1000
                camera.position.x = 120
                camera.position.y = 60
                camera.position.z = 180
                camera.lookAt scene.position
                this.perspective = "Perspective"
        return this
    gui = new dat.GUI()
    gui.add controls, "switchCamera"
    gui.add(controls, "perspective").listen()
    
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        
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
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

window.onload = init()
# 监听方法一
window.addEventListener 'resize', onResize, false
# 监听方法二
# $(window).on "resize",()->
#     onResize()