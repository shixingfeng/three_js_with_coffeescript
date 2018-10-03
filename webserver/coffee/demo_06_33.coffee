console.log "demo_6.33  Extrude SVG"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -80
    camera.position.y = 80
    camera.position.z = 80
    camera.lookAt new THREE.Vector3(60, -60, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true

    renderer = webGLRenderer

    drawShape = ()->
        svgString = document.querySelector("#batman-path").getAttribute("d")
        shape = transformSVGPathExposed svgString
        return shape

    #材质
    createMesh = (geom)->
        geom.applyMatrix new THREE.Matrix4().makeTranslation(-390, -74, 0)
        meshMaterial = new THREE.MeshPhongMaterial {color: 0x333333, shininess: 100, metal: true}
        mesh = new THREE.Mesh geom, meshMaterial
        mesh.scale.x = 0.1
        mesh.scale.y = 0.1

        mesh.rotation.z = Math.PI
        mesh.rotation.x = -1.1
        return mesh
    
    #创建形状
    shape = createMesh new THREE.ShapeGeometry(drawShape())
    scene.add shape
    
    #灯光 平行光
    spotLight = new THREE.DirectionalLight 0xffffff
    spotLight.position = new THREE.Vector3 70, 170, 70
    spotLight.intensity = 0.7
    spotLight.target = shape
    scene.add spotLight 


    orbit = new THREE.OrbitControls camera, webGLRenderer.domElement

    #控制条
    controls = new ()->
        this.amount = 2
        this.bevelThickness = 2
        this.bevelSize = 0.5
        this.bevelEnabled = true
        this.bevelSegments = 3
        this.bevelEnabled = true
        this.curveSegments = 12
        this.steps = 1
    
        this.asGeom = ()->
            scene.remove shape
            options = 
                amount: controls.amount
                bevelThickness: controls.bevelThickness
                bevelSize: controls.bevelSize
                bevelSegments: controls.bevelSegments
                bevelEnabled: controls.bevelEnabled
                curveSegments: controls.curveSegments
                steps: controls.steps
            shape = createMesh new THREE.ExtrudeGeometry(drawShape(), options)
            scene.add shape
        return this
    
    gui = new dat.GUI()
    gui.add(controls, "amount", 0, 20).onChange controls.asGeom
    gui.add(controls, "bevelThickness", 0, 10).onChange controls.asGeom
    gui.add(controls, "bevelSize", 0, 10).onChange controls.asGeom
    gui.add(controls, "bevelSegments", 0, 30).step(1).onChange controls.asGeom
    gui.add(controls, "bevelEnabled").onChange controls.asGeom
    gui.add(controls, "curveSegments", 1, 30).step(1).onChange controls.asGeom
    gui.add(controls, "steps", 1, 5).step(1).onChange controls.asGeom
    # 执行画图
    controls.asGeom()

    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        shape.rotation.y = step += 0.005


        orbit.update()
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
