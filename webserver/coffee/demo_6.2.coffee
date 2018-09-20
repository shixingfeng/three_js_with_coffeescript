console.log "demo_6.2  geometries - Lathe"
camera = null
scene = null
renderer = null
spGroup = null
latheMesh = null
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
    


    # 生成点
    generatePoints = (segments, phiStart, phiLength)->
        # 随机三个数值的点
        points = []
        height = 5
        count = 30
        for i in [0..29]
            points.push new THREE.Vector3((Math.sin(i * 0.2) + Math.cos(i * 0.3)) * height + 12, 0, ( i - count ) + count / 2)

        
        spGroup = new THREE.Object3D()
        material = new THREE.MeshBasicMaterial {color: 0xff0000, transparent: false}
        
        # 为每个点指定材质大小以及位置
        points.forEach (point)->
            spGeom = new THREE.SphereGeometry 0.2
            spMesh = new THREE.Mesh spGeom, material 
            spMesh.position.copy point
            spGroup.add spMesh
        scene.add spGroup

        # 将点连接
        latheGeometry = new THREE.LatheGeometry points, segments, phiStart, phiLength
        latheMesh = createMesh latheGeometry
        scene.add latheMesh

    # 执行生成点函数
    generatePoints 12, 2, 2 * Math.PI
    
    # 控制条
    controls = new ()->
        this.segments = 12
        this.phiStart = 0
        this.phiLength = 2 * Math.PI
        this.redraw = ()->
            scene.remove spGroup
            scene.remove latheMesh
            generatePoints controls.segments, controls.phiStart, controls.phiLength
        return this
    
    gui = new dat.GUI()
    gui.add(controls, "segments", 0, 50).step(1).onChange controls.redraw
    gui.add(controls, "phiStart", 0, 2 * Math.PI).onChange controls.redraw
    gui.add(controls, "phiLength", 0, 2 * Math.PI).onChange controls.redraw


    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    
        spGroup.rotation.x = step 
        latheMesh.rotation.x = step += 0.01

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
