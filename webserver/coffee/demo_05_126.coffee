console.log "demo_5.26  geometries - Polyhedron"
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
    camera.position.z = 50
    camera.lookAt new THREE.Vector3 10, 0, 0
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true

    renderer = webGLRenderer

    #材质
    createMesh = (geom)->
        meshMaterial = new THREE.MeshNormalMaterial()
        meshMaterial.side = THREE.DoubleSide
        wireFrameMat = new THREE.MeshBasicMaterial()
        wireFrameMat.wireframe = true

        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial,wireFrameMat]
        return mesh

    # 创建二维几何体 polyhedron
    polyhedron = createMesh new THREE.IcosahedronGeometry(10, 0)
    scene.add polyhedron
    
    
    # 控制条
    controls = new ()->
        this.radius = 10
        this.detail = 0
        this.type = "Icosahedron"
        vertices = [1, 1, 1, -1, -1, 1, -1, 1, -1, 1, -1, -1]
        indices = [2, 1, 0, 0, 3, 2, 1, 3, 0, 2, 3, 1]

        this.redraw = ()->
            scene.remove polyhedron
            switch controls.type
                when "Icosahedron" then polyhedron = createMesh new THREE.IcosahedronGeometry(controls.radius, controls.detail)
                when "Tetrahedron" then polyhedron = createMesh new THREE.TetrahedronGeometry(controls.radius, controls.detail)
                when "Octahedron" then polyhedron = createMesh new THREE.OctahedronGeometry(controls.radius, controls.detail)
                when "Dodecahedron" then polyhedron = createMesh new THREE.DodecahedronGeometry(controls.radius, controls.detail)
                when "Custom" then polyhedron = createMesh new THREE.PolyhedronGeometry(vertices, indices, controls.radius, controls.detail)
            scene.add polyhedron
        return this
    
    gui = new dat.GUI()
    gui.add(controls, "radius", 0, 40).step(1).onChange controls.redraw
    gui.add(controls, "detail", 0, 3).step(1).onChange controls.redraw
    gui.add(controls, "type", ["Icosahedron", "Tetrahedron", "Octahedron", "Dodecahedron", "Custom"]).onChange controls.redraw


    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    
        polyhedron.rotation.y = step += 0.01

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
