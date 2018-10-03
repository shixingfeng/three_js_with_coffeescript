console.log "demo_8.36  Load VRML model"
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
    camera.position.x = 30
    camera.position.y = 30
    camera.position.z = 30
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    #灯光
    orbit = new THREE.OrbitControls camera

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
    spotLight.position.set 30, 30, 30
    scene.add spotLight


    # 控制条
    controls = new ()->
        
    # UI呈现
    gui = new dat.GUI()
    loader = new THREE.VRMLLoader()
    group = new THREE.Object3D()
    add_uri = "/static/pictures/assets/models/vrml/"
    loader.load add_uri+"tree.wrl", (model)->
        console.log model
        model.traverse (child)->
            if child instanceof THREE.Mesh
                child.material = new THREE.MeshLambertMaterial {color: 0x8bc34a}
        model.scale.set 10, 10, 10
        scene.add model
    

    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        orbit.update()
        
        scene.rotation.y = step += 0.005
        
        
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
