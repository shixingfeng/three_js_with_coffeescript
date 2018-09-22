console.log "demo_7.1  Particles"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 0
    camera.position.y = 0
    camera.position.z = 150
    
    
    # 渲染器
    canvasRenderer = new THREE.WebGLRenderer()
    canvasRenderer.setClearColor new THREE.Color(0x000000, 1.0)
    canvasRenderer.setSize window.innerWidth, window.innerHeight
    renderer = canvasRenderer

    #创建粒子
    createSprites = ()->
        material = new THREE.SpriteMaterial()
        for x in [-5..4]
            for y in [-5..4]
                sprite = new THREE.Sprite material
                sprite.position.set x*10, y*10, 0
                scene.add sprite

    # 控制条
    # controls = new ()->
       
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
