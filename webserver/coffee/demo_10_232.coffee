console.log "demo_10.232 Canvas texture bumpmap"
camera = null
scene = null
renderer = null
mesh = null

fillWithPerlin = (perlin, ctx)->
    for x in [0..511]
        for y in [0..511]
            base = new THREE.Color 0xffffff
            value = perlin.noise x / 10, y / 10, 0
            base.multiplyScalar value
            ctx.fillStyle = "#" + base.getHexString()
            ctx.fillRect x, y, 1, 1

canvas = document.createElement "canvas"
canvas.setAttribute "width", 256
canvas.setAttribute "height", 256
canvas.setAttribute "style", "position: absolute; x:0; y:0; bottom: 0px"

document.getElementById("canvas-output").appendChild canvas
ctx = canvas.getContext("2d");
date = new Date()
pn = new Perlin "rnd" + date.getTime()

fillWithPerlin pn, ctx


init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 0
    camera.position.y = 12
    camera.position.z = 28
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    #灯光
    ambiLight = new THREE.AmbientLight 0x141414
    scene.add ambiLight
    light = new THREE.DirectionalLight()
    light.position.set 0, 30, 20
    scene.add light

    # 方法区
    createMesh = (geom, texture)->
        texture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/" + texture
        bumpMap = new THREE.Texture canvas

        geom.computeVertexNormals()
        mat = new THREE.MeshPhongMaterial()
        mat.color = new THREE.Color 0x77ff77
        mat.bumpMap = bumpMap
        bumpMap.needsUpdate = true

        mesh = new THREE.Mesh geom, mat
        return mesh

    # 方块
    cube = createMesh new THREE.BoxGeometry(12, 12, 12), "floor-wood.jpg"
    cube.position.x = 3
    scene.add cube


    # 控制条
    controls = new ()->
        this.bumpScale = cube.material.bumpScale
        this.regenerateMap = ()->
            date = new Date()
            pn = new Perlin "rnd" + date.getTime()
            fillWithPerlin pn, ctx
            cube.material.bumpMap.needsUpdate = true
        this.updateScale = ()->
            cube.material.bumpScale = controls.bumpScale
        return this
    # UI
    gui  = new dat.GUI
    gui.add(controls, "regenerateMap");
    gui.add(controls, "bumpScale", -2, 2).onChange controls.updateScale
    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        cube.rotation.y += 0.01
        cube.rotation.x += 0.01
    
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
