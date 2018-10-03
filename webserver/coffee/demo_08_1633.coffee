console.log "demo_8.33  Load vtk model"
camera = null
scene = null
renderer = null
mesh = null
group = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 10
    camera.position.y = 10
    camera.position.z = 10
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    #灯光
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 20, 20, 20
    scene.add spotLight

    # 控制条
    controls = new ()->
        
    # UI呈现
    loader = new THREE.VTKLoader()
    group = new THREE.Object3D()
    add_uri = "/static/pictures/assets/models/"
    loader.load add_uri+"moai_fixed.vtk", (geometry)->
        console.log geometry
        mat = new THREE.MeshLambertMaterial {color: 0x7f8479}
        group = new THREE.Mesh geometry, mat
        group.scale.set 9, 9, 9
        scene.add group
        
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        if group
            group.rotation.y += 0.06 
        
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
