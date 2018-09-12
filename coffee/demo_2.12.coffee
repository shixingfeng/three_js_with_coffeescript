console.log "启用coffee demo_2.1"
camera = null
scene = null
renderer = null
controls = null
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -30
    camera.position.y = 40
    camera.position.z = 30
    camera.lookAt scene.position
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0xEEEEEE, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    
    # 物体材质和几何
    planeGeometry = new THREE.PlaneGeometry 60, 40, 1, 1
    planeMaterial = new THREE.MeshLambertMaterial {color:0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial

    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 0
    plane.position.y = 0
    plane.position.z = 0
    plane.receiveShadow = true
    scene.add plane
    
    # 环境光
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight

    # 点光源
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight

    # 雾化
    # 线性增长
    scene.fog = new THREE.Fog 0xffffff, 0.015, 100
    # 非线性增长
    # scene.fog = new THREE.FogExp2 0xffffff, 0.01

    # 材质覆盖
    scene.overrideMaterial = new THREE.MeshLambertMaterial {color:0xffffff}

    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.02
        # this.bouncingSpeed = 0.03
        this.numberOfObjects = scene.children.length


        this.removeCube = ()->
            allChildren = scene.children
            lastObject = allChildren[allChildren.length - 1]
            if lastObject instanceof THREE.Mesh
                scene.remove(lastObject)
                this.numberOfObjects = scene.children.length
        this.addCube = ()->
            cubeSize = Math.ceil (Math.random()*3)
            cubeGeometry = new THREE.BoxGeometry cubeSize, cubeSize, cubeSize
            cubeMaterial = new THREE.MeshLambertMaterial {color:Math.random()*0xffffff}
            cube = new THREE.Mesh cubeGeometry,cubeMaterial
            cube.castShadow = true
            cube.name = "cube-"+scene.children.length
            cube.position.x = -30 + Math.round(Math.random()*planeGeometry.parameters.width)
            cube.position.y = Math.round(Math.random()*5)
            cube.position.z = -20 + Math.round(Math.random()*planeGeometry.parameters.height)
            scene.add cube
            this.numberOfObjects = scene.children.length
        this.outputObjects = ()->
            console.log(scene.children)
        return
    gui = new dat.GUI()
    gui.add controls, 'rotationSpeed', 0, 0.5
    gui.add controls, "addCube"
    gui.add controls, 'removeCube'
    gui.add controls, 'outputObjects'
    gui.add(controls, 'numberOfObjects').listen()

    renderScene = ()->
        stats.update()
        scene.traverse (e)->
            if e instanceof THREE.Mesh && e != plane
                e.rotation.x += controls.rotationSpeed
                e.rotation.y += controls.rotationSpeed
                e.rotation.z += controls.rotationSpeed

        requestAnimationFrame renderScene
        renderer.render scene,camera
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