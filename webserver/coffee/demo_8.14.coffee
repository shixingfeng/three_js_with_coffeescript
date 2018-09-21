console.log "demo_8.14  Load and save scene"
camera = null
scene = null
renderer = null
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
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    # 地面
    planeGeometry = new THREE.PlaneGeometry 60, 20, 1, 1
    planeMaterial = new THREE.MeshLambertMaterial {color: 0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial
    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 15
    plane.position.y = 0
    plane.position.z = 0
    scene.add plane

    # 球和方块
    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    cubeMaterial = new THREE.MeshLambertMaterial {color: 0xff0000}
    cube = new THREE.Mesh cubeGeometry, cubeMaterial 
    cube.position.x = -4
    cube.position.y = 3
    cube.position.z = 0
    scene.add cube

    sphereGeometry = new THREE.SphereGeometry 4, 20, 20
    sphereMaterial = new THREE.MeshLambertMaterial {color: 0x7777ff}
    sphere = new THREE.Mesh sphereGeometry, sphereMaterial
    sphere.position.x = 20
    sphere.position.y = 0
    sphere.position.z = 2
    scene.add sphere


    #灯光
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight

    spotLight = new THREE.PointLight 0xffffff
    spotLight.position.set -40, 60, -10
    scene.add spotLight


    # 控制条
    controls = new ()->
        this.exportScene = ()->
            exporter = new THREE.SceneExporter()
            sceneJson = JSON.stringify(exporter.parse(scene))
            localStorage.setItem "scene", sceneJson
            console.log "导出场景"
        
        this.clearScene = ()->
            scene = new THREE.Scene()
            console.log "新建场景"

        this.importScene = ()->
            json = localStorage.getItem("scene")
            sceneLoader = new THREE.SceneLoader()
            sceneLoader.parse(JSON.parse(json), (e)->
                scene = e.scene 
            ,".")
            console.log "导入场景"
        return this
        
    # UI呈现
    gui = new dat.GUI()
    gui.add controls, "exportScene"
    gui.add controls, "clearScene"
    gui.add controls, "importScene"
    

    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        # knot.rotation.y = step += 0.01
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
