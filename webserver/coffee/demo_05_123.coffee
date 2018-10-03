console.log "demo_5.23  geometries - Cylinder"
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

        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial, wireFrameMat]
        return mesh

    # 创建二维几何体 圆柱
    cylinder = createMesh new THREE.CylinderGeometry(20, 20, 20)
    scene.add cylinder
    

    # 光源
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    scene.add spotLight
    
    # 控制条
    controls = new ()->
        this.radiusTop = 20
        this.radiusBottom = 20
        this.height = 20

        this.radialSegments = 8
        this.heightSegments = 8

        this.openEnded = false

        this.redraw = ()->
            scene.remove cylinder
            cylinder = createMesh new THREE.CylinderGeometry(controls.radiusTop, controls.radiusBottom, controls.height, controls.radialSegments, controls.heightSegments, controls.openEnded)
            scene.add cylinder
        return this
    gui = new dat.GUI()
    gui.add(controls, "radiusTop", -40, 40).onChange controls.redraw
    gui.add(controls, "radiusBottom", -40, 40).onChange controls.redraw
    gui.add(controls, "height", 0, 40).onChange controls.redraw
    gui.add(controls, "radialSegments", 1, 20).step(1).onChange controls.redraw
    gui.add(controls, "heightSegments", 1, 20).step(1).onChange controls.redraw
    gui.add(controls, "openEnded").onChange controls.redraw


    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    
        cylinder.rotation.y = step += 0.01

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
