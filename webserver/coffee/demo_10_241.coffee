console.log "demo_10.241 Video texture"
camera = null
scene = null
renderer = null
mesh = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 0
    camera.position.y = 1
    camera.position.z = 28
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    #灯光
    ambiLight = new THREE.AmbientLight 0x141414
    scene.add ambiLight
    light = new THREE.DirectionalLight()
    light.position.set 0, 30, 20
    scene.add light

    # 视频
    video = document.getElementById "video"
    texture = new THREE.Texture video
    texture.minFilter = THREE.LinearFilter
    texture.magFilter = THREE.LinearFilter
    texture.format = THREE.RGBFormat
    texture.generateMipmaps = false

    # 方法区
    createMesh = (geom)->
        materialArray = []
        materialArray.push new THREE.MeshBasicMaterial({color: 0x0051ba})
        materialArray.push new THREE.MeshBasicMaterial({color: 0x0051ba})
        materialArray.push new THREE.MeshBasicMaterial({color: 0x0051ba})
        materialArray.push new THREE.MeshBasicMaterial({color: 0x0051ba})
        materialArray.push new THREE.MeshBasicMaterial({map: texture})
        materialArray.push new THREE.MeshBasicMaterial({color: 0xff51ba})
        faceMaterial = new THREE.MeshFaceMaterial materialArray
        mesh = new THREE.Mesh geom, faceMaterial
        return mesh

    # 方块
    cube = createMesh new THREE.BoxGeometry(22, 16, 0.2), "floor-wood.jpg"
    cube.position.y = 2
    scene.add cube

    # 控制条
    controls = new ()->
        this.showVideo = false
        this.rotate = false
        this.showCanvas = ()->
            if controls.showVideo
                $('#video').show()
            else
                $('#video').hide()
        return this
    # UI
    gui  = new dat.GUI
    gui.add controls, "rotate"
    gui.add(controls, "showVideo").onChange controls.showCanvas
    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        if  video.readyState == video.HAVE_ENOUGH_DATA
            if texture 
                texture.needsUpdate = true
        if controls.rotate 
            cube.rotation.x += -0.01
            cube.rotation.y += -0.01
            cube.rotation.z += -0.01
        
    
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
