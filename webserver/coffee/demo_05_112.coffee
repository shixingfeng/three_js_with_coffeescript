console.log "demo_5.12   circleGeometry"
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

    createMesh = (geom)->
        meshMaterial = new THREE.MeshNormalMaterial()
        meshMaterial.side = THREE.DoubleSide
        wireFrameMat = new THREE.MeshBasicMaterial()
        wireFrameMat.wireframe = true

        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial, wireFrameMat]
        return mesh
    # 创建二维几何体 圆
    circle = createMesh new THREE.CircleGeometry(4, 10, 0.3 * Math.PI * 2, 0.3 * Math.PI * 2)
    scene.add circle
    

    # 光源
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    scene.add spotLight
    
    # 控制条
    controls = new ()->
        console.log circle.children[0].geometry
        this.radius = 4

        this.thetaStart = 0.3 * Math.PI * 2
        this.thetaLength = 0.3 * Math.PI * 2
        this.segments = 10
        
        this.redraw = ()->
            scene.remove circle
            circle = createMesh new THREE.CircleGeometry(controls.radius, controls.segments, controls.thetaStart, controls.thetaLength)
            scene.add circle
        return this
    
    gui = new dat.GUI()
    gui.add(controls, "radius", 0, 40).onChange controls.redraw
    gui.add(controls, "segments", 0, 40).onChange controls.redraw 
    gui.add(controls, "thetaStart", 0, 2 * Math.PI).onChange controls.redraw
    gui.add(controls, "thetaLength", 0, 2 * Math.PI).onChange controls.redraw

    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    
        circle.rotation.y = step += 0.01

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
