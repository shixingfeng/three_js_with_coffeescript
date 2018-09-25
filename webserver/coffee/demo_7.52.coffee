console.log "demo7.52 Sprites in 3D"
camera = null
scene = null
renderer = null
group = null
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


    getTexture = ()->
        texture = new THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/particles/sprite-sheet.png"
        return texture
    
    createSprite = (size, transparent, opacity, color, spriteNumber, range)->
        spriteMaterial = new THREE.SpriteMaterial {
                opacity: opacity,
                color: color,
                transparent: transparent,
                map: getTexture()}
        
        spriteMaterial.map.offset = new THREE.Vector2(0.2 * spriteNumber, 0)
        spriteMaterial.map.repeat = new THREE.Vector2(1 / 5, 1)
        spriteMaterial.depthTest = false
        spriteMaterial.blending = THREE.AdditiveBlending

        sprite = new THREE.Sprite spriteMaterial
        sprite.scale.set size, size, size
        sprite.position.set(
            Math.random() * range - range / 2,
            Math.random() * range - range / 2,
            Math.random() * range - range / 2)
        sprite.velocityX = 5
        return sprite

    createSprites = ()->
        group = new THREE.Object3D()
        range = 200
        for i in [0..399]
            group.add createSprite(10, false, 0.6, 0xffffff, i % 5, range)
        scene.add group


    
    # 执行绘图
    createSprites()
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        step += 0.01
        group.rotation.x = step
        
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
