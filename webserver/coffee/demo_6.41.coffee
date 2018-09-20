console.log "demo_6.41  Text geometry"
camera = null
scene = null
renderer = null
text1 = null
text2 = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 100
    camera.position.y = 300
    camera.position.z = 600
    camera.lookAt new THREE.Vector3(400, 0, -300)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true

    renderer = webGLRenderer



    # 灯光
    dirLight = new THREE.DirectionalLight()
    dirLight.position.set 25, 23, 15
    scene.add dirLight
    dirLight2 = new THREE.DirectionalLight()
    dirLight2.position.set -25, 23, 15
    scene.add dirLight2
   

    createMesh = (geom)->
        meshMaterial = new THREE.MeshPhongMaterial {specular: 0xfffff, color: 0xeefff, shininess: 10, metal: true}
        plane = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial]
        return plane
   
    # 控制条
    controls = new ()->
        this.size = 90
        this.height = 90
        this.bevelThickness = 2
        this.bevelSize = 0.5
        this.bevelEnabled = true
        this.bevelSegments = 3
        this.bevelEnabled = true
        this.curveSegments = 12
        this.steps = 1
        this.font = "helvetiker"
        this.weight = "normal"
    
        this.asGeom = ()->
            scene.remove text1
            scene.remove text2

            options = 
                size: controls.size
                height: controls.height
                weight: controls.weight
                font: controls.font
                bevelThickness: controls.bevelThickness
                bevelSize: controls.bevelSize
                bevelSegments: controls.bevelSegments
                bevelEnabled: controls.bevelEnabled
                curveSegments: controls.curveSegments
                steps: controls.steps
            console.log THREE.FontUtils.faces

            text1 = createMesh new THREE.TextGeometry("Hello", options)
            text1.position.z = -100
            text1.position.y = 100
            scene.add text1

            text2 = createMesh new THREE.TextGeometry("HotPoor", options)
            scene.add text2
        return this
    


    gui = new dat.GUI()
    gui.add(controls, "size", 0, 200).onChange controls.asGeom
    gui.add(controls, "height", 0, 200).onChange controls.asGeom
    gui.add(controls, "font", ["bitstream vera sans mono", "helvetiker"]).onChange controls.asGeom
    gui.add(controls, "bevelThickness", 0, 10).onChange controls.asGeom
    gui.add(controls, "bevelSize", 0, 10).onChange controls.asGeom
    gui.add(controls, "bevelSegments", 0, 30).step(1).onChange controls.asGeom
    gui.add(controls, "bevelEnabled").onChange controls.asGeom
    gui.add(controls, "curveSegments", 1, 30).step(1).onChange controls.asGeom
    gui.add(controls, "steps", 1, 5).step(1).onChange controls.asGeom  

    controls.asGeom()
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        text1.rotation.y = step += 0.01
        text2.rotation.y = -step
        
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
