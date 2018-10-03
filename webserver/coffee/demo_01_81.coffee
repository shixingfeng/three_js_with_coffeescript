console.log "demo_01_81 屏幕自适应"
console.log "onResize 方法，window.addeventListener方法监听"
step = 0
camera = null
renderer = null

onResize = ()->
    console.log "onResize"
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

init = ()->    
    # 场景
    scene = new THREE.Scene()
    
    # 摄像头参数
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -30
    camera.position.y = 40
    camera.position.z = 30
    camera.lookAt scene.position
    
    # 渲染器、设置颜色、大小
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0xEEEEEE, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    

    # 地面大小、材质、旋转方向、位置，并加入场景中
    planeGeometry = new THREE.PlaneGeometry 60, 20, 1, 1
    planeMaterial = new THREE.MeshLambertMaterial {color:0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial
    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 15
    plane.position.y = 0
    plane.position.z = 0
    scene.add plane

    # 方块、圆的材质、大小、位置、并加入场景
    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    cubeMaterial = new THREE.MeshLambertMaterial {color:0xff0000}
    cube = new THREE.Mesh cubeGeometry, cubeMaterial
    cube.position.x = -4
    cube.position.y = 3
    cube.position.z = 0
    cube.castShadow = true
    scene.add cube

    sphereGeometry = new THREE.SphereGeometry 4, 20, 20
    sphereMaterial = new THREE.MeshLambertMaterial {color:0x7777ff}
    sphere = new THREE.Mesh sphereGeometry, sphereMaterial
    sphere.position.x = 20
    sphere.position.y = 0
    sphere.position.z = 2
    sphere.castShadow = true
    scene.add sphere

    # 灯光 类型、位置、阴影并加入场景
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight
    
    # 控制条
    controls = new ()->
        this.rotationSpeed = 0.02
        this.bouncingSpeed = 0.03
        return this
    
    gui = new dat.GUI()
    gui.add controls, "rotationSpeed", 0, 0.5
    gui.add controls, "bouncingSpeed", 0, 0.5

    #帧数显示
    initStats = ()->
        stats = new Stats()
        stats.setMode 0
        stats.domElement.style.position = "absolute"
        stats.domElement.style.left = "0px"
        stats.domElement.style.top = "0px"
        $("#Stats-output").append stats.domElement
        return stats

    # 实时渲染，帧数更新、物体控制参数、调用渲染本身,将结果输出到屏幕
    renderScene = ()->
        stats.update()
        
        cube.rotation.x += controls.rotationSpeed
        cube.rotation.y += controls.rotationSpeed
        cube.rotation.z += controls.rotationSpeed
        step += controls.bouncingSpeed
        sphere.position.x = 20 + ( 10 * (Math.cos(step)))
        sphere.position.y = 2 + ( 10 * Math.abs(Math.sin(step)))
        
        requestAnimationFrame renderScene
        renderer.render scene,camera
        $("#WebGL-output").append renderer.domElement
      
    # 执行帧数显示(在renderScene中执行更新)、实时渲染、屏幕监听
    stats = initStats()
    renderScene()
    window.addEventListener "resize", onResize, false

# 浏览器加载完成时，执行函数init()
window.onload = init