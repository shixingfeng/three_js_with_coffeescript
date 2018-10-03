console.log "demo_7.2  Particle Basic Material"
camera = null
scene = null
renderer = null
size = null
cloud = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 20
    camera.position.y = 0
    camera.position.z = 150
    
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    renderer = webGLRenderer

    #创建粒子
    createParticles = (size,transparent, opacity, vertexColors, sizeAttenuation, color)->
        geom = new THREE.Geometry()
        material = new THREE.PointCloudMaterial {
            size:size,
            transparent:transparent,
            opacity:opacity,
            vertexColors:vertexColors,
            sizeAttenuation:sizeAttenuation,
            color: color}
        range = 500
        for i in [0..14999]
            particle = new THREE.Vector3(
                Math.random() * range - range / 2,
                Math.random() * range - range / 2,
                Math.random() * range - range / 2)
            geom.vertices.push particle
            
            color = new THREE.Color 0x00ff00
            color.setHSL(
                color.getHSL().h,
                color.getHSL().s,
                Math.random() * color.getHSL().l)
            geom.colors.push color
        
        cloud = new THREE.PointCloud geom, material
        cloud.name = "particles"
        scene.add cloud
    

    # 控制条
    controls = new ()->
        this.size =1
        this.transparent =true
        this.opacity = 0.6
        this.vertexColors = true
        this.color = 0xffffff
        this.sizeAttenuation = true
        this.rotateSystem = true

        this.redraw = ()->
            if scene.getObjectByName("particles")
                scene.remove scene.getObjectByName("particles")
            createParticles(
                 controls.size,
                 controls.transparent,
                 controls.opacity,
                 controls.vertexColors,
                 controls.sizeAttenuation,
                 controls.color)
        return this


    # UI
    gui = new dat.GUI()
    gui.add(controls, "size", 0, 10).onChange controls.redraw
    gui.add(controls, "transparent").onChange controls.redraw
    gui.add(controls, "opacity", 0, 1).onChange controls.redraw
    gui.add(controls, "vertexColors").onChange controls.redraw
    gui.addColor(controls, "color").onChange controls.redraw
    gui.add(controls, "sizeAttenuation").onChange controls.redraw
    gui.add controls, "rotateSystem"

    # 执行绘图
    controls.redraw()

    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        if controls.rotateSystem
            step += 0.01
            cloud.rotation.y = step
            # cloud.rotation.z = step

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
