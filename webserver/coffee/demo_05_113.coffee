console.log "demo_5.13   RingGeometry"
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

    createMesh = (geom)->
        meshMaterial = new THREE.MeshNormalMaterial()
        meshMaterial.side = THREE.DoubleSide
        wireFrameMat = new THREE.MeshBasicMaterial()
        wireFrameMat.wireframe = true

        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial, wireFrameMat]
        return mesh
    # 创建二维几何体 圆
    torus = createMesh new THREE.RingGeometry()
    scene.add torus
    

    # 光源
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    scene.add spotLight
    
    # 控制条
    controls = new ()->
        this.innerRadius = 0
        this.outerRadius = 50
        this.thetaSegments = 8
        this.phiSegments = 8
        this.thetaStart = 0
        this.thetaLength = Math.PI * 2
        
        this.redraw = ()->
            scene.remove torus
            torus = createMesh new THREE.RingGeometry(controls.innerRadius, controls.outerRadius, controls.thetaSegments, controls.phiSegments, controls.thetaStart, controls.thetaLength)
            scene.add torus
        return this
    
    gui = new dat.GUI()
    gui.add(controls, "innerRadius", 0, 40).onChange controls.redraw
    gui.add(controls, "outerRadius", 0, 100).onChange controls.redraw 
    gui.add(controls, "thetaSegments", 1, 40).step(1).onChange controls.redraw
    gui.add(controls, "phiSegments", 1, 20).step(1).onChange controls.redraw
    gui.add(controls, "thetaStart", 0, Math.PI * 2).onChange controls.redraw
    gui.add(controls, "thetaLength", 0, Math.PI * 2).onChange controls.redraw

    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
    
        torus.rotation.y = step += 0.01

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
