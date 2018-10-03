console.log "demo_01_51 材质、光线、阴影"
console.log "在渲染器中加入阴影选项，对性能有很大影响"
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像头参数
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -30
    camera.position.y = 40
    camera.position.z = 30
    camera.lookAt scene.position
    
    # 渲染器、设置颜色、大小、阴影
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0xEEEEEE, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    
    # 轴线
    axes = new THREE.AxisHelper 20
    scene.add axes

    # 地面大小、材质、旋转方向、位置、阴影并加入场景中
    planeGeometry = new THREE.PlaneGeometry 60, 20
    planeMaterial = new THREE.MeshLambertMaterial {color:0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial
    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 15
    plane.position.y = 0
    plane.position.z = 0
    plane.receiveShadow = true
    scene.add plane

    # 方块、圆的材质、大小、位置、阴影并加入场景
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
    sphere.position.y = 4
    sphere.position.z = 2
    sphere.castShadow = true
    scene.add sphere

    # 灯光 类型、位置、阴影并加入场景
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight

    # 渲染场景(场景内容)和摄像头
    renderer.render scene, camera
    # 找到HTML页面中的id为WebGL-output的层，加入渲染后的结果
    $("#WebGL-output").append renderer.domElement

# 浏览器加载完成时，执行函数init()
window.onload = init