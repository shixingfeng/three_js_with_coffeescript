console.log "demo9.21 Trackball controls"
camera = null
scene = null
renderer = null
mesh = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    clock = new THREE.Clock()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000    
    camera.position.x = 100
    camera.position.y = 100
    camera.position.z = 300
    camera.lookAt new THREE.Vector3(0, 0, 0)


    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight    
    webGLRenderer.shadowMapEnabled = true
    
    renderer = webGLRenderer


    # 轨球控制器
    trackballControls = new THREE.TrackballControls camera
    trackballControls.rotateSpeed = 1.0
    trackballControls.zoomSpeed = 1.0
    trackballControls.panSpeed = 1.0
    trackballControls.staticMoving = true

    # 灯光
    ambientLight = new THREE.AmbientLight 0x383838
    scene.add ambientLight

    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 300, 300, 300
    spotLight.intensity = 1
    scene.add spotLight

    setCamControls = ()->


    setRandomColors = (object, scale)->
        children = object.children
        if children and children.length > 0
            children.forEach (e)->
                setRandomColors e, scale
        else 
            if object instanceof THREE.Mesh
                object.material.color = new THREE.Color scale(Math.random()).hex()
                if object.material.name.indexOf("building") is 0
                    object.material.emissive = new THREE.Color 0x444444
                    object.material.transparent = true
                    object.material.opacity = 0.8
    # 控制台
    controls = new ()->

    # UI
    gui = new dat.GUI()
    loader = new THREE.OBJMTLLoader()
    load = (object)->
        scale = chroma.scale ["red", "green", "blue"]
        setRandomColors object, scale
        mesh = object
        scene.add mesh
    texture = THREE.ImageUtils.loadTexture('/static/pictures/assets/textures/Metro01.JPG');
    loader.load('/static/pictures/assets/models/city.obj', '/static/pictures/assets/models/city.mtl', load);

    # 执行

    step = 0
    scalingStep = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    
        delta = clock.getDelta()

        trackballControls.update delta
        
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
