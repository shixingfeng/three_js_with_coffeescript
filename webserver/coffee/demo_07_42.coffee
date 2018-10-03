console.log " demo7.42 Particles Snowy scene"
camera = null
scene = null
renderer = null
cloud = null
system1 = null
system2 = null
system3 = null
system4= null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 200
    camera.position.x = 20
    camera.position.y = 40
    camera.position.z = 110
    camera.lookAt new THREE.Vector3(20, 30, 0)

    
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    renderer = webGLRenderer

    createPointCloud = (name, texture, size, transparent, opacity, sizeAttenuation, color)->
        geom = new THREE.Geometry()
        color = new THREE.Color(color)
        color.setHSL(
            color.getHSL().h,
            color.getHSL().s,
            (Math.random()) * color.getHSL().l)

        material = new THREE.PointCloudMaterial {
            size: size,
            transparent: transparent,
            opacity: opacity,
            map: texture,
            blending: THREE.AdditiveBlending,
            depthWrite: false,
            sizeAttenuation: sizeAttenuation,
            color: color}
    
        range = 40
        for i in [0..49]
            particle = new THREE.Vector3(
                Math.random() * range - range / 2,
                Math.random() * range * 1.5,
                Math.random() * range - range / 2)
            # 方向和下落速度
            particle.velocityY = 0.1 + Math.random() / 5
            particle.velocityX = (Math.random() - 0.5) / 3
            particle.velocityZ = (Math.random() - 0.5) / 3
            geom.vertices.push particle

        system = new THREE.PointCloud geom, material
        system.name = name
        system.sortParticles = true
        return system

    createPointClouds = (size, transparent, opacity, sizeAttenuation, color)->
        texture1 = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/particles/snowflake1.png"
        texture2 = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/particles/snowflake2.png"
        texture3 = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/particles/snowflake3.png"
        texture4 = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/particles/snowflake5.png"
        
        scene.add createPointCloud("system1", texture1, size, transparent, opacity, sizeAttenuation, color)
        scene.add createPointCloud("system2", texture2, size, transparent, opacity, sizeAttenuation, color)
        scene.add createPointCloud("system3", texture3, size, transparent, opacity, sizeAttenuation, color)
        scene.add createPointCloud("system4", texture4, size, transparent, opacity, sizeAttenuation, color)
        
    #控制条
    controls = new ()->
        this.size = 10
        this.transparent = true
        this.opacity = 0.6
        this.color = 0xffffff
        this.sizeAttenuation = true
        this.redraw = ()->
            toRemove = []
            scene.children.forEach (child)->
                if child instanceof THREE.PointCloud
                    toRemove.push(child)
            toRemove.forEach (child)->
                scene.remove(child)
            createPointClouds(
                controls.size,
                controls.transparent,
                controls.opacity,
                controls.sizeAttenuation,
                controls.color)
        return this
    
    # UI
    gui = new dat.GUI()
    gui.add(controls, "size", 0, 20).onChange controls.redraw
    gui.add(controls, "transparent").onChange controls.redraw
    gui.add(controls, "opacity", 0, 1).onChange controls.redraw
    gui.addColor(controls, "color").onChange controls.redraw
    gui.add(controls, "sizeAttenuation").onChange controls.redraw

    #执行绘图
    controls.redraw()
    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        scene.children.forEach (child)->
            if child instanceof THREE.PointCloud
                vertices = child.geometry.vertices
                vertices.forEach (v)->
                    v.y = v.y - (v.velocityY)
                    v.x = v.x - (v.velocityX)
                    v.z = v.z - (v.velocityZ)
                    if v.y <= 0
                        v.y = 60
                    if v.x <= -20 || v.x >= 20
                        v.velocityX = v.velocityX * -1
                    if v.z <= -20 || v.z >= 20
                        v.velocityZ = v.velocityZ * -1
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
