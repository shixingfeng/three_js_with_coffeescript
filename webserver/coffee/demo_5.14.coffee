console.log "demo_5.14  Shapegeometries"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -30
    camera.position.y = 70
    camera.position.z = 70
    camera.lookAt new THREE.Vector3 10, 0, 0
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true

    renderer = webGLRenderer

    # 描述形状
    drawShape = ()->
        shape = new THREE.Shape()
        # 起点
        shape.moveTo 10, 10 
        # 向上的直线
        shape.lineTo 10, 40
        # 顶点数值 向右弯曲
        shape.bezierCurveTo 15, 25, 25, 25, 30, 40

        # 后退
        shape.splineThru [new THREE.Vector2(32, 30), new THREE.Vector2(28, 20), new THREE.Vector2(30, 10)]

        #向下弯曲
        shape.quadraticCurveTo 20, 15, 10, 10

        # 眼洞1
        hole1 = new THREE.Path()
        hole1.absellipse 16, 24, 2, 3, 0, Math.PI * 2, true
        shape.holes.push hole1
        
        # 眼洞2
        hole2 = new THREE.Path()
        hole2.absellipse 23, 24, 2, 3, 0, Math.PI * 2, true
        shape.holes.push hole2
        
        #嘴巴
        hole3 = new THREE.Path()
        hole3.absarc 20, 16, 2, 0, Math.PI, true
        shape.holes.push hole3
        return shape


    # 材质
    createMesh = (geom)->
        meshMaterial = new THREE.MeshNormalMaterial()
        meshMaterial.side = THREE.DoubleSide
        wireFrameMat = new THREE.MeshBasicMaterial()
        wireFrameMat.wireframe = true

        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial, wireFrameMat]
        return mesh

    # 画线
    createLine = (shape, spaced)->
        console.log shape
        if !spaced
            mesh = new THREE.Line shape.createPointsGeometry(10), new THREE.LineBasicMaterial({color: 0xff3333, linewidth: 2})
            return mesh
        else
            mesh = new THREE.Line shape.createSpacedPointsGeometry(3), new THREE.LineBasicMaterial({color: 0xff3333, linewidth: 2})
            return mesh

    # 创建二维几何体 圆
    shape = createMesh new THREE.ShapeGeometry(drawShape())
    scene.add shape
    

    # 光源
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    scene.add spotLight
    
    # 控制条
    controls = new ()->
        this.asGeom =()->
            scene.remove shape
            shape = createMesh new THREE.ShapeGeometry(drawShape())
            scene.add shape
        this.asPoints =()->
            scene.remove shape
            shape = createLine drawShape(), false
            scene.add shape
        this.asSpacedPoints =()->
            scene.remove shape
            shape = createLine drawShape(), true
            scene.add shape
        return this
        
    gui = new dat.GUI()
    gui.add controls, "asGeom"
    gui.add controls, "asPoints"
    gui.add controls, "asSpacedPoints"
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    
        shape.rotation.y = step += 0.01

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
