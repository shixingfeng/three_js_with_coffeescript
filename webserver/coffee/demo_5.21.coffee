console.log "demo_5.21  geometries - Cube"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -20
    camera.position.y = 30
    camera.position.z = 40
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

        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial, wireFrameMat]
        return mesh

    # 创建二维几何体 圆
    cube = createMesh new THREE.BoxGeometry(10, 10, 10, 1, 1, 1)
    scene.add cube
    

    # 光源
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    scene.add spotLight
    
    # 控制条
    controls = new ()->
        this.width = cube.children[0].geometry.parameters.width
        this.height = cube.children[0].geometry.parameters.height
        this.depth = cube.children[0].geometry.parameters.depth

        this.widthSegments = cube.children[0].geometry.parameters.widthSegments
        this.heightSegments = cube.children[0].geometry.parameters.heightSegments
        this.depthSegments = cube.children[0].geometry.parameters.depthSegments
        
        this.redraw = ()->
            scene.remove cube
            cube = createMesh new THREE.BoxGeometry(controls.width, controls.height, controls.depth, Math.round(controls.widthSegments), Math.round(controls.heightSegments), Math.round(controls.depthSegments))
            scene.add cube
        return this
    gui = new dat.GUI()
    gui.add(controls, "width", 0, 40).onChange controls.redraw
    gui.add(controls, "height", 0, 40).onChange controls.redraw
    gui.add(controls, "depth", 0, 40).onChange controls.redraw
    gui.add(controls, "widthSegments", 0, 10).onChange controls.redraw
    gui.add(controls, "heightSegments", 0, 10).onChange controls.redraw
    gui.add(controls, "depthSegments", 0, 10).onChange controls.redraw    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    
        cube.rotation.y = step += 0.01

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
