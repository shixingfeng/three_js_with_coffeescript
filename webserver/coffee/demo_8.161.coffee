console.log "demo_8.161  Load OBJ model"
camera = null
scene = null
renderer = null
mesh = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 130
    camera.position.y = 40
    camera.position.z = 50
    camera.lookAt scene.position
    scene.add camera
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xaaaaff, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    #灯光
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 30, 40, 50
    spotLight.intensity = 1
    scene.add spotLight


    # 控制条
    controls = new ()->

        
    # UI呈现
    gui = new dat.GUI()
    loader = new THREE.OBJLoader()
    add_chair = "/static/pictures/assets/models/"
    loader.load(add_chair+"pinecone.obj",(loadedMesh)->
        material = new THREE.MeshLambertMaterial {color: 0x5C3A21}
        loadedMesh.children.forEach (child)->
            child.material = material
            child.geometry.computeFaceNormals()
            child.geometry.computeVertexNormals()

        mesh = loadedMesh
        loadedMesh.scale.set 100, 100, 100
        loadedMesh.rotation.x = -0.3
        scene.add loadedMesh
    )
        
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        if mesh
            mesh.rotation.y += 0.006
            mesh.rotation.x += 0.006
        
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
