console.log "demo_10.11Basic textures"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 0
    camera.position.y = 12
    camera.position.z = 28
    camera.lookAt new THREE.Vector3 0, 0, 0
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    createMesh = (geom, imageFile)->
        loader = new THREE.DDSLoader()
        texture = loader.load("/static/pictures/assets/textures/ash_uvgrid01.jpg")
        mat = new THREE.MeshPhongMaterial()
        mat.map = texture

        mesh = new THREE.Mesh geom, mat
        return mesh

    polyhedron = createMesh new THREE.IcosahedronGeometry(5, 0)
    polyhedron.position.x = 12
    scene.add polyhedron

    sphere = createMesh new THREE.SphereGeometry(5, 20, 20)
    scene.add sphere

    cube = createMesh new THREE.BoxGeometry(5, 5, 5)
    cube.position.x = -12
    scene.add cube
    
    console.log cube.geometry.faceVertexUvs

    #灯光
    ambiLight = new THREE.AmbientLight 0x141414
    scene.add ambiLight

    light = new THREE.DirectionalLight()
    light.position.set 0, 30, 20
    scene.add light


    # 控制条
    controls = new ()->
        
    # UI呈现
    gui = new dat.GUI()

    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        polyhedron.rotation.y = step += 0.01
        polyhedron.rotation.x = step
        cube.rotation.y = step
        cube.rotation.x = step
        sphere.rotation.y = step
        sphere.rotation.x = step
        

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
