console.log "demo9.13 Animation tween"
camera = null
scene = null
renderer = null
tube = null
loadedGeometry = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000    
    camera.position.x = 10
    camera.position.y = 10
    camera.position.z = 10
    camera.lookAt new THREE.Vector3(0, -2, 0)


    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight    
    renderer = webGLRenderer

    # 灯光
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 20, 20, 20
    scene.add spotLight

    pointCloud = new THREE.Object3D()

    posSrc = {pos: 1}
    tween = new TWEEN.Tween(posSrc).to {pos: 0}, 5000
    tween.easing TWEEN.Easing.Sinusoidal.InOut
    tweenBack = new TWEEN.Tween(posSrc).to {pos: 1}, 5000
    tweenBack.easing TWEEN.Easing.Sinusoidal.InOut

    tween.chain tweenBack
    tweenBack.chain tween


    loader = new THREE.PLYLoader()

    loader.load "/static/pictures/assets/models/test.ply",(geometry)->
        loadedGeometry = geometry.clone()

        material = new THREE.PointCloudMaterial {
            color: 0xffffff,
            size: 0.4,
            opacity: 0.6,
            transparent: true,
            blending: THREE.AdditiveBlending,
            map: generateSprite()}

        pointCloud = new THREE.PointCloud geometry, material
        pointCloud.sortParticles = true

        tween.start()
        scene.add pointCloud

    onUpdate = ()->
        count = 0
        pos = this.pos

        loadedGeometry.vertices.forEach (e)->
            newY = ((e.y + 3.22544) * pos) - 3.22544
            pointCloud.geometry.vertices[count++].set(e.x, newY, e.z)
        pointCloud.sortParticles = true
    
    tween.onUpdate onUpdate
    tweenBack.onUpdate onUpdate

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

    # 控制台
    controls = new ()->

    # UI
    gui = new dat.GUI()
    


    # 执行

    step = 0
    scalingStep = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        TWEEN.update()
        
        
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
