console.log "demo_01_41 第一个场景"
console.log "本例中，渲染器中setClearColorHex()已经被移除，用setClearColor()代替"
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
    renderer.setClearColor 0xEEEEEE
    renderer.setSize window.innerWidth, window.innerHeight
    
    # 轴线
    axes = new THREE.AxisHelper 20
    scene.add axes

    # 地面大小、材质、旋转方向、位置，并加入场景中
    planeGeometry = new THREE.PlaneGeometry 60, 20, 1, 1
    planeMaterial = new THREE.MeshBasicMaterial {color:0xcccccc}
    plane = new THREE.Mesh planeGeometry, planeMaterial
    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 15
    plane.position.y = 0
    plane.position.z = 0
    scene.add plane

    # 方块、圆的材质、大小、位置、并加入场景
    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    cubeMaterial = new THREE.MeshBasicMaterial {color:0xff0000, wireframe:true}
    cube = new THREE.Mesh cubeGeometry, cubeMaterial
    cube.position.x = -4
    cube.position.y = 3
    cube.position.z = 0
    scene.add cube

    sphereGeometry = new THREE.SphereGeometry 4, 20, 20
    sphereMaterial = new THREE.MeshBasicMaterial {color:0x7777ff, wireframe:true}
    sphere = new THREE.Mesh sphereGeometry, sphereMaterial
    sphere.position.x = 20
    sphere.position.y = 4
    sphere.position.z = 2
    scene.add sphere

    # 渲染场景(场景内容)和摄像头
    renderer.render scene, camera
    # 找到HTML页面中的id为WebGL-output的层，加入渲染后的结果
    $("#WebGL-output").append renderer.domElement

# 浏览器加载完成时，执行函数init()
window.onload = init