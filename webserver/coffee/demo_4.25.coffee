console.log "demo_4.25  Mesh face material"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -40
    camera.position.y = 40
    camera.position.z = 40
    camera.lookAt scene.position
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = false

    
    # 地面材质
    planeGeometry = new THREE.PlaneGeometry 60, 40, 1, 1
    planeMaterial = new THREE.MeshLambertMaterial {color: 0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial
    plane.receiveShadow = true
    # 地面旋转
    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 0
    plane.position.y = -2
    plane.position.z = 0
    scene.add plane

    # 光源
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight

    # 指定每个面的颜色 threejs是以三角形作为基本单位的，所以有12个面
    group = new THREE.Mesh()
    mats = []
    mats.push new THREE.MeshBasicMaterial({color: 0x009e60})
    mats.push new THREE.MeshBasicMaterial({color: 0x009e60})
    mats.push new THREE.MeshBasicMaterial({color: 0x0051ba})
    mats.push new THREE.MeshBasicMaterial({color: 0x0051ba})
    mats.push new THREE.MeshBasicMaterial({color: 0xffd500})
    mats.push new THREE.MeshBasicMaterial({color: 0xffd500})
    mats.push new THREE.MeshBasicMaterial({color: 0xff5800})
    mats.push new THREE.MeshBasicMaterial({color: 0xff5800})
    mats.push new THREE.MeshBasicMaterial({color: 0xC41E3A})
    mats.push new THREE.MeshBasicMaterial({color: 0xC41E3A})
    mats.push new THREE.MeshBasicMaterial({color: 0xffffff})
    mats.push new THREE.MeshBasicMaterial({color: 0xffffff})

    faceMaterial = new THREE.MeshFaceMaterial mats

    # 创建27个方块 计算偏移量 
    for x in [0..2]
        for y in [0..2]
            for z in  [0..2]
                cubeGeom = new THREE.BoxGeometry 2.9, 2.9, 2.9
                cube = new THREE.Mesh cubeGeom, faceMaterial
                cube.position.set x * 3 - 3, y * 3, z * 3 - 3
                group.add cube
    scene.add group
    step = 0
    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.02
        this.numberOfObjects = scene.children.length
    
    #控制条UI
    gui = new dat.GUI()
    gui.add controls, 'rotationSpeed', 0, 0.5


    # 实时渲染
    renderScene = ()->
        stats.update()

        group.rotation.y = step += controls.rotationSpeed

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


#屏幕适配
onResize =()->
    console.log "onResize"
    camera.aspect = window.innerWidth/window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight


window.onload = init()
window.addEventListener "resize", onResize, false
