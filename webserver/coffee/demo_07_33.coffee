console.log "demo_7.33  Canvas based texture WebGL2"
camera = null
scene = null
renderer = null
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


    #纹理
    getTexture = ()->
        canvas = document.createElement "canvas"
        canvas.width = 32
        canvas.height = 32
        ctx = canvas.getContext "2d"
        
        # 身体
        ctx.translate(-81, -84)
        ctx.fillStyle = "orange"
        ctx.beginPath()
        ctx.moveTo 83, 116
        ctx.lineTo 83, 102
        ctx.bezierCurveTo 83, 94, 89, 88, 97, 88
        ctx.bezierCurveTo 105, 88, 111, 94, 111, 102
        ctx.lineTo 111, 116
        ctx.lineTo 106.333, 111.333
        ctx.lineTo 101.666, 116
        ctx.lineTo 97, 111.333
        ctx.lineTo 92.333, 116
        ctx.lineTo 87.666, 111.333
        ctx.lineTo 83, 116
        ctx.fill()

        # 眼睛
        ctx.fillStyle = "white"
        ctx.beginPath()
        ctx.moveTo(91, 96)
        ctx.bezierCurveTo 88, 96, 87, 99, 87, 101 
        ctx.bezierCurveTo 87, 103, 88, 106, 91, 106 
        ctx.bezierCurveTo 94, 106, 95, 103, 95, 101 
        ctx.bezierCurveTo 95, 99, 94, 96, 91, 96 
        ctx.moveTo 103, 96
        ctx.bezierCurveTo 100, 96, 99, 99, 99, 101 
        ctx.bezierCurveTo 99, 103, 100, 106, 103, 106 
        ctx.bezierCurveTo 106, 106, 107, 103, 107, 101 
        ctx.bezierCurveTo 107, 99, 106, 96, 103, 96 
        ctx.fill()

        # 瞳孔
        ctx.fillStyle = "blue"
        ctx.beginPath()
        ctx.arc 101, 102, 2, 0, Math.PI * 2, true
        ctx.fill()
        ctx.beginPath()
        ctx.arc 89, 102, 2, 0, Math.PI * 2, true
        ctx.fill()

        texture = new THREE.Texture canvas
        texture.needsUpdate = true
        return texture
    
    #创建粒子
    createSprites = ()->
        material = new THREE.SpriteMaterial {map: getTexture(), color: 0xffffff}

        range = 500
        for i in [0..1499]
            sprite = new THREE.Sprite material  
            sprite.position.set(
                Math.random() * range - range / 2, 
                Math.random() * range - range / 2, 
                Math.random() * range - range / 2)
            
            sprite.scale.set 4, 4, 4
            scene.add sprite
            
    # 控制条

   #执行绘图
    createSprites()
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()

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
