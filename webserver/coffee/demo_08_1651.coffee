console.log "demo_8.51  Load ply model"
camera = null
scene = null
renderer = null
mesh = null
model = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 10
    camera.position.y = 10
    camera.position.z = 10
    camera.lookAt new THREE.Vector3 0, -2, 0
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    #灯光
    dir1 = new THREE.DirectionalLight 0.4
    dir1.position.set -30, 30, -30
    scene.add dir1

    dir2 = new THREE.DirectionalLight 0.4
    dir2.position.set -30, 30, 30
    scene.add dir2

    dir3 = new THREE.DirectionalLight 0.4
    dir3.position.set 30, 30, -30
    scene.add dir3

    # 阴影
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 20, 20, 20
    scene.add spotLight

    generateSprite = ()->
        canvas = document.createElement "canvas"
        canvas.width = 16;
        canvas.height = 16;

        context = canvas.getContext('2d');
        gradient = context.createRadialGradient canvas.width / 2, canvas.height / 2, 0, canvas.width / 2, canvas.height / 2, canvas.width / 2
        gradient.addColorStop(0, "rgba(255,255,255,1)")
        gradient.addColorStop(0.2, "rgba(0,255,255,1)")
        gradient.addColorStop(0.4, "rgba(0,0,64,1)")
        gradient.addColorStop(1, "rgba(0,0,0,1)")

        context.fillStyle = gradient
        context.fillRect 0, 0, canvas.width, canvas.height

        texture = new THREE.Texture canvas
        texture.needsUpdate = true
        return texture 
    
    # 控制条
    controls = new ()->
        
    # UI呈现
    gui = new dat.GUI()
    loader = new THREE.PLYLoader()
    group = new THREE.Object3D()
    add_uri = "/static/pictures/assets/models/"
    loader.load add_uri+"test.ply", (geometry)->
        material = new THREE.PointCloudMaterial {color:0xffffff, size:0.4, opacity:0.6, transparent:true, blending:THREE.AdditiveBlending, map:generateSprite()}
        group = new THREE.PointCloud geometry, material
        group.sortParticles = true

        scene.add group
    
    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        if group
            group.rotation.y +=0.006          

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