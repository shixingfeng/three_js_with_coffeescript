console.log "demo7.51 Particles Sprites"
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
    sceneOrtho = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 250
    cameraOrtho = new THREE.OrthographicCamera 0, window.innerWidth, window.innerHeight, 0, -10, 10
    
    camera.position.x = 0
    camera.position.y = 0
    camera.position.z = 50
    camera.lookAt new THREE.Vector3(20, 30, 0)

    material = new THREE.MeshNormalMaterial()
    geom = new THREE.SphereGeometry 15, 20, 20
    mesh = new THREE.Mesh geom, material
    scene.add mesh
    
    
    getTexture = ()->
        texture = new THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/particles/sprite-sheet.png"
        return texture
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    renderer = webGLRenderer

    createSprite = (size, transparent, opacity, color, spriteNumber)->
        spriteMaterial = new THREE.SpriteMaterial {
                    opacity: opacity,
                    color: color,
                    transparent: transparent,
                    map: getTexture()}

        spriteMaterial.map.offset = new THREE.Vector2 0.2 * spriteNumber, 0
        spriteMaterial.map.repeat = new THREE.Vector2 1 / 5, 1
        spriteMaterial.depthTest = false
        spriteMaterial.blending = THREE.AdditiveBlending

        sprite = new THREE.Sprite spriteMaterial
        sprite.scale.set size, size, size
        sprite.position.set 100, 50, -10
        sprite.velocityX = 5

        sceneOrtho.add sprite
        
    #控制条
    controls = new ()->
        this.size = 150
        this.sprite = 0
        this.transparent = true
        this.opacity = 0.6
        this.color = 0xffffff
        this.rotateSystem = true

        this.redraw = ()->
            sceneOrtho.children.forEach (child)->
                if child instanceof THREE.Sprite
                    sceneOrtho.remove(child)

            createSprite(
                controls.size,
                controls.transparent,
                controls.opacity,
                controls.color,
                controls.sprite)
        return this
    # UI
    gui = new dat.GUI()
    gui.add(controls, "sprite", 0, 4).step(1).onChange controls.redraw
    gui.add(controls, "size", 0, 120).onChange controls.redraw
    gui.add(controls, "transparent").onChange controls.redraw
    gui.add(controls, "opacity", 0, 1).onChange controls.redraw
    gui.addColor(controls, "color").onChange controls.redraw


    #执行绘图
    controls.redraw()
    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        camera.position.y = Math.sin(step += 0.01) * 20

        sceneOrtho.children.forEach (e)->
            if e instanceof THREE.Sprite
                e.position.x = e.position.x + e.velocityX
                if e.position.x > window.innerWidth
                    e.velocityX = -5
                    e.material.map.offset.set 1 / 5 * (controls.sprite % 4), 0
                if e.position.x < 0
                    e.velocityX = 5
        requestAnimationFrame renderScene
        renderer.render scene,camera
        webGLRenderer.autoClear = false
        webGLRenderer.render sceneOrtho, cameraOrtho
        
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
