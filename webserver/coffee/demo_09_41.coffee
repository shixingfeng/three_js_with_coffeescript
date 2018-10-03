console.log "demo9.41 Animation from blender"
camera = null
scene = null
renderer = null
mesh = null
step = 0
helper = null

init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000    
    camera.position.x = 0
    camera.position.y = 0
    camera.position.z = 4
    camera.lookAt new THREE.Vector3(0,0,0)


    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight    
    webGLRenderer.shadowMapEnabled = true    
    renderer = webGLRenderer

    # 灯光
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 0, 50, 30
    spotLight.intensity = 2
    scene.add spotLight


    # 载入纹理
    clock = new THREE.Clock()
    loader = new THREE.JSONLoader()
    loader.load("/static/pictures/assets/models/hand-2.js", (model, mat)->
        mat = new THREE.MeshLambertMaterial {color: 0xF0C8C9, skinning: true}
        mesh = new THREE.SkinnedMesh model, mat
        animation = new THREE.Animation mesh, model.animation
        
        mesh.rotation.x = 0.5 * Math.PI
        mesh.rotation.z = 0.7 * Math.PI
        scene.add mesh
        
        helper = new THREE.SkeletonHelper mesh
        helper.material.linewidth = 2
        helper.visible = false
        scene.add helper

        animation.play()
    ,"/static/pictures/assets/models")

    # 控制台
    controls = new ()->
        this.showHelper = false
        

    # UI
    gui = new dat.GUI()
    gui.add(controls, "showHelper", 0, 0.5).onChange (state)->
        helper.visible = state

    # 实时渲染
    renderScene = ()->
        stats.update()        
        delta = clock.getDelta()
        if mesh
            helper.update()
            THREE.AnimationHandler.update delta
        
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
