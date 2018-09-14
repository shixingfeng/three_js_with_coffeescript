console.log "启用coffee demo_3.22"
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
    camera.lookAt new THREE.Vector3(10, 0, 0)
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0xEEEEEE, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    # renderer.shadowMapEnabled = true
    
    # 创建地面方块
    planeGeometry = new THREE.PlaneGeometry 60, 20, 20, 20
    planeMaterial = new THREE.MeshLambertMaterial {color:0xffffff}
    plane = new THREE.Mesh planeGeometry,planeMaterial
    

    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 15
    plane.position.y = 0
    plane.position.z = 0
    plane.receiveShadow = true
    scene.add plane
    
    # 基本光源
    ambiColor = "#0c0c0c"
    ambientLight = new THREE.AmbientLight ambiColor
    scene.add ambientLight

    # 聚光源
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    # scene.add spotLight

    #点光源
    pointColor = "#ccffcc";
    pointLight = new THREE.PointLight pointColor
    pointLight.distance = 100
    scene.add pointLight

    # 无限光
    # directionalLight = new THREE.DirectionalLight 0xffffff, 0.7
    # directionalLight.position.set -20, 40, 60
    # scene.add directionalLight

    #创建方块，设置大小，位置
    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    cubeMaterial = new THREE.MeshLambertMaterial {color: 0xff7777}
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

    sphereLightMesh.position = new THREE.Vector3 3, 0, 3
    scene.add sphereLightMesh

    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.03
        this.bouncingSpeed = 0.03
        this.ambientColor = ambiColor
        this.pointColor = pointColor
        this.intensity = 1
        this.distance = 100     
    
    #控制条UI
    gui = new dat.GUI()
    gui.addColor(controls,"ambientColor").onChange (e)->
        ambientLight.color = new THREE.Color(e)
    gui.addColor(controls, "pointColor").onChange (e)->
        pointLight.color = new THREE.Color(e)
    gui.add(controls, "intensity", 0, 3).onChange (e)->
        pointLight.intensity = e
    gui.add(controls, "distance", 0, 100).onChange (e)->
        pointLight.distance = e
    
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

        #移动模拟小光点
        if phase > 2 * Math.PI
            invert = invert * -1
            phase -= 2 * Math.PI
        else
            phase += controls.rotationSpeed
        sphereLightMesh.position.z = +(7 * (Math.sin(phase)))
        sphereLightMesh.position.x = +(14 * (Math.cos(phase)))
        sphereLightMesh.position.y = 5

        if invert < 0
            pivot = 14
            sphereLightMesh.position.x = (invert * (sphereLightMesh.position.x - pivot)) + pivot
        pointLight.position.copy sphereLightMesh.position
        
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