console.log "demo7.6 3D Torusknot"
camera = null
scene = null
renderer = null
group = null
knot = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000    
    camera.position.x = -30
    camera.position.y = 40
    camera.position.z = 50
    camera.lookAt new THREE.Vector3(10, 0, 0)


    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    
    renderer = webGLRenderer


    createMesh = (geom)->
        meshMaterial = new THREE.MeshNormalMaterial {}
        meshMaterial.side = THREE.DoubleSide
        mesh = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial]
        return mesh
    
    generateSprite = ()->
        canvas = document.createElement "canvas"
        canvas.width = 16
        canvas.height = 16

        context = canvas.getContext "2d"
        gradient = context.createRadialGradient(
            canvas.width / 2, 
            canvas.height / 2,
            0,
            canvas.width / 2,
            canvas.height / 2,
            canvas.width / 2)
        gradient.addColorStop 0, "rgba(255,255,255,1)"
        gradient.addColorStop 0.2, "rgba(0,255,255,1)"
        gradient.addColorStop 0.4, "rgba(0,0,64,1)"
        gradient.addColorStop 1, "rgba(0,0,0,1)"

        context.fillStyle = gradient
        context.fillRect 0, 0, canvas.width, canvas.height

        texture = new THREE.Texture canvas
        texture.needsUpdate = true
        return texture

    createPointCloud = (geom)->
        material = new THREE.PointCloudMaterial {
            color: 0xffffff,
            size: 3,
            transparent: true,
            blending: THREE.AdditiveBlending,
            map: generateSprite()}

        cloud = new THREE.PointCloud geom, material
        cloud.sortParticles = true
        return cloud

    # 控制台
    controls = new ()->
        this.radius = 13
        this.tube = 1.7
        this.radialSegments = 156
        this.tubularSegments = 12
        this.p = 5
        this.q = 4
        this.heightScale = 3.5
        this.asParticles = false
        this.rotate = false

        this.redraw = ()->
            if knot
                scene.remove knot
            geom = new THREE.TorusKnotGeometry(
                controls.radius,
                controls.tube,
                Math.round(controls.radialSegments),
                Math.round(controls.tubularSegments),
                Math.round(controls.p),
                Math.round(controls.q),
                controls.heightScale)

            if controls.asParticles
                knot = createPointCloud geom
            else
                knot = createMesh geom
            scene.add knot
        return this

    # UI
    gui = new dat.GUI()
    gui.add(controls, "radius", 0, 40).onChange controls.redraw
    gui.add(controls, "tube", 0, 40).onChange controls.redraw
    gui.add(controls, "radialSegments", 0, 400).step(1).onChange controls.redraw
    gui.add(controls, "tubularSegments", 1, 20).step(1).onChange controls.redraw
    gui.add(controls, "p", 1, 10).step(1).onChange controls.redraw
    gui.add(controls, "q", 1, 15).step(1).onChange controls.redraw
    gui.add(controls, "heightScale", 0, 5).onChange controls.redraw
    gui.add(controls, "asParticles").onChange controls.redraw
    gui.add(controls, "rotate").onChange controls.redraw


    # 执行
    controls.redraw()

    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        if controls.rotate
            knot.rotation.y = step += 0.01
        
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