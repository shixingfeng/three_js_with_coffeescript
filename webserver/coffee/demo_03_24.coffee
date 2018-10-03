console.log "启用coffee demo_3.24"
camera = null
scene = null
renderer = null
controls = null
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -25
    camera.position.y = 30
    camera.position.z = 25
    camera.lookAt new THREE.Vector3 10, 0, 0
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0xEEEEEE, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    
    # 创建地面方块
    planeGeometry = new THREE.PlaneGeometry 600, 200, 20, 20
    planeMaterial = new THREE.MeshLambertMaterial {color:0xffffff}
    plane = new THREE.Mesh planeGeometry,planeMaterial
    

    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 15
    plane.position.y = -5
    plane.position.z = 0
    plane.receiveShadow = true
    scene.add plane
    
    # 基本光源
    ambiColor = "#1c1c1c"
    ambientLight = new THREE.AmbientLight ambiColor
    scene.add ambientLight

    target = new THREE.Object3D()
    target.position = new THREE.Vector3 5, 0, 0
    # 聚光源
    # spotLight0 = new THREE.SpotLight 0xcccccc
    # spotLight0.position.set -40, 30, -10
    # spotLight0.lookAt plane
    # scene.add spotLight0

    # target = new THREE.Object3D()
    # target.position = new THREE.Vector3 5, 0, 0

    # pointColor = "#ffffff"
    # spotLight = new THREE.SpotLight pointColor
    # spotLight.position.set -40, 60, -10
    # spotLight.castShadow = true
    # spotLight.shadowCameraNear = 2
    # spotLight.shadowCameraFar = 200
    # spotLight.shadowCameraFov = 30
    # spotLight.target = target
    # spotLight.distance = 0
    # spotLight.angle = 0.4
    
    # scene.add spotLight
    #点光源
    # pointColor = "#ccffcc";
    # pointLight = new THREE.PointLight pointColor
    # pointLight.distance = 100
    # scene.add pointLight

    # 无限光
    pointColor = "#ff5808"
    directionalLight = new THREE.DirectionalLight pointColor
    directionalLight.position.set -40, 60, -10
    directionalLight.castShadow = true
    directionalLight.shadowCameraNear = 2
    directionalLight.shadowCameraFar = 200
    directionalLight.shadowCameraLeft = -50
    directionalLight.shadowCameraRight = 50
    directionalLight.shadowCameraTop = 50
    directionalLight.shadowCameraBottom = -50

    directionalLight.distance = 0
    directionalLight.intensity = 0.5
    directionalLight.shadowMapHeight = 1024
    directionalLight.shadowMapWidth = 1024
    scene.add directionalLight

    #创建方块，设置大小，位置
    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    cubeMaterial = new THREE.MeshLambertMaterial {color: 0xff3333}
    cube = new THREE.Mesh cubeGeometry, cubeMaterial
    cube.castShadow = true
    cube.position.x = -4
    cube.position.y = 3
    cube.position.z = 0

    scene.add cube
    # 创建球体
    sphereGeometry = new THREE.SphereGeometry 4, 20, 20
    sphereMaterial = new THREE.MeshLambertMaterial {color: 0x7777ff}
    sphere = new THREE.Mesh sphereGeometry, sphereMaterial
    sphere.position.x = 20
    sphere.position.y = 0
    sphere.position.z = 2
    sphere.castShadow = true

    scene.add sphere


    # 创建一个移动的发光球体
    sphereLight = new THREE.SphereGeometry 0.2
    sphereLightMaterial = new THREE.MeshBasicMaterial {color: 0xac6c25}
    sphereLightMesh = new THREE.Mesh sphereLight, sphereLightMaterial
    sphereLightMesh.castShadow = true

    sphereLightMesh.position = new THREE.Vector3 3, 20, 3
    scene.add sphereLightMesh

    # 控制台
    controls = new ()->
        this.perspective = "Perspective"
        this.switchCamera = ()->
        # 透视投影
            if camera instanceof THREE.PerspectiveCamera
                camera = new THREE.OrthographicCamera window.innerWidth / -16, window.innerWidth / 16, window.innerHeight / 16, window.innerHeight / -16, -200, 500
                camera.position.x = 120
                camera.position.y = 60
                camera.position.z = 180
                camera.lookAt scene.position
                this.perspective = "Orthographic"
        # 正交投影
            else
                camera = new THREE.PerspectiveCamera 45, window.innerWidth / window.innerHeight, 0.1, 1000
                camera.position.x = 120
                camera.position.y = 60
                camera.position.z = 180
                camera.lookAt scene.position
                this.perspective = "Perspective"
        this.rotationSpeed = 0.03
        this.bouncingSpeed = 0.03
        this.ambientColor = ambiColor
        this.pointColor = pointColor
        this.intensity = 0.5
        this.distance = 0
        this.exponent = 30
        this.angle = 0.1
        this.debug = false
        this.castShadow = true
        this.onlyShadow = false
        this.target = "Plane"  
    
    #控制条UI
    gui = new dat.GUI()
    gui.add controls, "switchCamera"
    gui.add(controls, "perspective").listen()
    
    gui.addColor(controls,"ambientColor").onChange (e)->
        ambientLight.color = new THREE.Color(e)
    
    gui.addColor(controls, "pointColor").onChange (e)->
        directionalLight.color = new THREE.Color(e)
        
    gui.add(controls, "intensity", 0, 5).onChange (e)->
        directionalLight.intensity = e
    
    gui.add(controls, "distance", 0, 200).onChange (e)->
        directionalLight.distance = e
    
    gui.add(controls, "debug").onChange (e)->
        directionalLight.shadowCameraVisible = e

    gui.add(controls, "castShadow").onChange (e)->
        directionalLight.castShadow = e

    gui.add(controls, "onlyShadow").onChange (e)->
        directionalLight.onlyShadow = e

    gui.add(controls, "target", ["Plane", "Sphere", "Cube"]).onChange (e)->
        console.log(e)
        switch (e)
            when "Plane"  then directionalLight.target = plane
            when "Sphere" then directionalLight.target = sphere
            when "Cube"   then directionalLight.target = cube
    # 实时渲染
    step = 0
    #灯光点动画变量 invert:倒置  phase:逐步执行
    invert = 1
    phase = 0
    renderScene = ()->
        stats.update()
        
        # 方块转动的速度
        cube.rotation.x += controls.rotationSpeed
        cube.rotation.y += controls.rotationSpeed
        cube.rotation.z += controls.rotationSpeed

        # 圆的跳跃速度
        step += controls.bouncingSpeed
        sphere.position.x = 20 + ( 10 * (Math.cos(step)))
        sphere.position.y = 2 + ( 10 * Math.abs(Math.sin(step)))
        
        sphereLightMesh.position.z = -8
        sphereLightMesh.position.y = +(27 * (Math.sin(step / 3)))
        sphereLightMesh.position.x = 10 + (26 * (Math.cos(step / 3)))

           
        directionalLight.position.copy sphereLightMesh.position
        
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