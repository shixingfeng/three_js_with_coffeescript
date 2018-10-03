console.log " demo_2.32 跟随物体移动摄像头"
console.log "这是假的物体移动，只是控制摄像头跟随点在移动"
camera = null
renderer = null
step = 0

# 屏幕适配
onResize = ()->
    console.log "onResize"
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机参数
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 120
    camera.position.y = 60
    camera.position.z = 180
    lookAtGeom = new THREE.SphereGeometry 2
    lookAtMesh = new THREE.Mesh lookAtGeom, new THREE.MeshLambertMaterial({color: 0xff0000})
    scene.add lookAtMesh
    
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

    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    cubeMaterial = new THREE.MeshLambertMaterial {color: 0x00ee22}
    for j in [0..planeGeometry.parameters.height / 5]
        for i in[0..planeGeometry.parameters.width / 5]    
            cube = new THREE.Mesh(cubeGeometry, cubeMaterial)
            cube.position.z = -((planeGeometry.parameters.height) / 2) + 2 + (j * 5)
            cube.position.x = -((planeGeometry.parameters.width) / 2) + 2 + (i * 5)
            cube.position.y = 2
            scene.add cube
    
    # 灯光
    ambientLight = new THREE.AmbientLight 0x292929
    scene.add ambientLight
    directionalLight = new THREE.DirectionalLight 0xffffff, 0.7
    directionalLight.position.set -20, 40, 60
    scene.add directionalLight



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


    # 状态条
    initStats = ()->
        stats = new Stats()
        stats.setMode 0
        stats.domElement.style.position = "absolute"
        stats.domElement.style.left = "0px"
        stats.domElement.style.top = "0px"
        $("#Stats-output").append stats.domElement
        return stats
    
    # 帧数更新、物体控制参数、调用渲染本身,将结果输出到屏幕
    renderScene = ()->
        stats.update()
        
        step += 0.02
        if camera instanceof THREE.Camera
            x = 10 + ( 100 * (Math.sin(step)))
            camera.lookAt new THREE.Vector3(x, 10, 0)
            lookAtMesh.position.copy new THREE.Vector3(x, 10, 0)

        requestAnimationFrame renderScene
        renderer.render scene,camera
        $("#WebGL-output").append renderer.domElement

    # 执行帧数显示(在renderScene中执行更新)、实时渲染、屏幕监听
    stats = initStats()
    renderScene()
    window.addEventListener "resize", onResize, false

# 浏览器加载完成时，执行函数init()
window.onload = init