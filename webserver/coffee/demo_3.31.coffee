console.log "启用coffee demo_3.31"
init = ()->
    # 场景
    scene = new THREE.Scene()

    scene.fog = new THREE.Fog 0xaaaaaa, 0.010, 200

    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -20
    camera.position.y = 15
    camera.position.z = 45
    camera.lookAt new THREE.Vector3(10, 0, 0)
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0xaaaaff, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    
    # 创建地面方块
    textureGrass = THREE.ImageUtils.loadTexture "/static/pictures/grasslight-big.jpg"
    textureGrass.wrapS = THREE.RepeatWrapping
    textureGrass.wrapT = THREE.RepeatWrapping
    textureGrass.repeat.set 4, 4 
    planeGeometry = new THREE.PlaneGeometry 1000, 200, 20, 20
    planeMaterial = new THREE.MeshLambertMaterial {map: textureGrass}
    plane = new THREE.Mesh planeGeometry,planeMaterial
    

    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 15
    plane.position.y = -5
    plane.position.z = 0
    plane.receiveShadow = true
    scene.add plane
    
    # 光源
    spotLight0 = new THREE.SpotLight 0xcccccc
    spotLight0.position.set -40, 60, -10
    spotLight0.lookAt plane
    scene.add spotLight0

    target = new THREE.Object3D()
    target.position = new THREE.Vector3 5, 0, 0

    hemiLight = new THREE.HemisphereLight 0x0000ff, 0x00ff00, 0.6
    hemiLight.position.set 0, 500, 0
    scene.add hemiLight

    pointColor = "#ffffff"
    dirLight = new THREE.DirectionalLight pointColor
    dirLight.position.set 30, 10, -50
    dirLight.castShadow = true
    
    dirLight.target = plane
    dirLight.shadowCameraNear = 0.1
    dirLight.shadowCameraFar = 200
    dirLight.shadowCameraLeft = -50
    dirLight.shadowCameraRight = 50
    dirLight.shadowCameraTop = 50
    dirLight.shadowCameraBottom = -50
    dirLight.shadowMapWidth = 2048
    dirLight.shadowMapHeight = 2048
    scene.add dirLight

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
    sphereGeometry = new THREE.SphereGeometry 4, 25, 25
    sphereMaterial = new THREE.MeshLambertMaterial {color: 0x7777ff}
    sphere = new THREE.Mesh sphereGeometry, sphereMaterial
    sphere.position.x = 10
    sphere.position.y = 5
    sphere.position.z = 10
    sphere.castShadow = true
    scene.add sphere



    

    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.03
        this.bouncingSpeed = 0.03
        
        this.hemisphere = true
        this.color = 0x00ff00
        this.skyColor = 0x0000ff
        this.intensity = 0.6
    
    #控制条UI
    gui = new dat.GUI()
    gui.add(controls, "hemisphere").onChange (e)->
        if not e
            hemiLight.intensity = 0
            console.log  "00000"
        else
            hemiLight.intensity = controls.intensity
            console.log  "1111"
    gui.addColor(controls, "color").onChange (e)->
        hemiLight.groundColor = new THREE.Color(e)
        console.log e

    gui.addColor(controls, "skyColor").onChange (e)->
        hemiLight.color = new THREE.Color(e)
        console.log e
    
    gui.add(controls, "intensity", 0, 5).onChange (e)->
        hemiLight.intensity = e
        console.log e
    # 实时渲染
    step = 0
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
window.addEventListener "resize", onResize, false
