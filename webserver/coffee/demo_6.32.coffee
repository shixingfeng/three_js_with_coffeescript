console.log "demo_6.32  Extrude TubeGeometry"
camera = null
scene = null
renderer = null
spGroup = null
tubeMesh = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -30
    camera.position.y = 40
    camera.position.z = 50
    camera.lookAt new THREE.Vector3 10, 10, 0
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true

    renderer = webGLRenderer

    #材质
    createMesh = (geom)->
        meshMaterial = new THREE.MeshBasicMaterial {color: 0x00ff00, transparent: true, opacity: 0.2}
        wireFrameMat = new THREE.MeshBasicMaterial()
        wireFrameMat.wireframe = true

        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial, wireFrameMat]
        return mesh
    
    # 生成点
    generatePoints = (points, segments, radius, radiusSegments, closed) ->
        spGroup = new THREE.Object3D()
        material = new THREE.MeshBasicMaterial {color: 0xff0000, transparent: false}
        points.forEach (point)->
            spGeom = new THREE.SphereGeometry 0.2
            spMesh = new THREE.Mesh spGeom, material
            spMesh.position.copy point
            spGroup.add spMesh
        scene.add spGroup

        tubeGeometry = new THREE.TubeGeometry new THREE.SplineCurve3(points), segments, radius, radiusSegments, closed
        tubeMesh = createMesh tubeGeometry
        scene.add tubeMesh

    # 控制条
    controls = new ()->
        this.numberOfPoints = 5
        this.segments = 64
        this.radius = 1
        this.radiusSegments = 8
        this.closed = false
        this.points = []
       
        this.newPoints = ()->
            points = []
            for i in [0 .. controls.numberOfPoints]
                randomX = -20 + Math.round(Math.random() * 50)
                randomY = -15 + Math.round(Math.random() * 40)
                randomZ = -20 + Math.round(Math.random() * 40)
                points.push new THREE.Vector3(randomX, randomY, randomZ)
            controls.points = points
            controls.redraw()

        this.redraw = ()->
            scene.remove spGroup
            scene.remove tubeMesh
            generatePoints controls.points, controls.segments, controls.radius, controls.radiusSegments, controls.closed
        return this
    
    gui = new dat.GUI()
    gui.add(controls, "newPoints")
    gui.add(controls, "numberOfPoints", 2, 15).step(1).onChange controls.newPoints
    gui.add(controls, "segments", 0, 200).step(1).onChange controls.redraw
    gui.add(controls, "radius", 0, 10).onChange controls.redraw
    gui.add(controls, "radiusSegments", 0, 100).step(1).onChange controls.redraw
    gui.add(controls, "closed").onChange controls.redraw 


    # 执行画图
    controls.newPoints()

    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        spGroup.rotation.y = step
        tubeMesh.rotation.y = step += 0.01

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
