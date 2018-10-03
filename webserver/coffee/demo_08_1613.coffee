console.log "demo_8.2  Load collada model"
camera = null
scene = null
renderer = null
mesh = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 150
    camera.position.y = 150
    camera.position.z = 150
    camera.lookAt new THREE.Vector3(0, 20, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xcccccc, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    #灯光
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 150, 150, 150
    spotLight.intensity = 1
    scene.add spotLight

    # 控制条
    controls = new ()->
        
    # UI呈现
    loader = new THREE.ColladaLoader()
    add_uri = "/static/pictures/assets/models/dae/"
    loader.load add_uri+"Truck_dae.dae", (result)->
        mesh = result.scene.children[0].children[0].clone()
        mesh.scale.set 4, 4, 4
        mesh.rotation.y = 0
        scene.add mesh
        
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        # mesh.rotation.y = step += 0.01
        if mesh
            mesh.castShadow = false
            mesh.rotation.y = step += 0.01
        
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
