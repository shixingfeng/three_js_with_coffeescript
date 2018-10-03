console.log "demo_10.21 UV mapping"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -30
    camera.position.y = 40
    camera.position.z = 50
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xffffff, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    # 纹理,几何
    texture = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/ash_uvgrid01.jpg"
    mat = new THREE.MeshBasicMaterial {map: texture}
    geom = new THREE.BoxGeometry 24, 24, 24
    mesh = new THREE.Mesh geom, mat
    mesh.rotation.z = 0.5 * Math.PI
    mesh.rotation.y = 0.2 * Math.PI
    mesh.rotation.x = 0.2 * Math.PI
    scene.add mesh
    
    console.log geom.faceVertexUvs[0][0]

    # 控制条
    controls = new ()->
        this.uv1 = geom.faceVertexUvs[0][0][0].x
        this.uv2 = geom.faceVertexUvs[0][0][0].y
        this.uv3 = geom.faceVertexUvs[0][0][1].x
        this.uv4 = geom.faceVertexUvs[0][0][1].y
        this.uv5 = geom.faceVertexUvs[0][0][2].x
        this.uv6 = geom.faceVertexUvs[0][0][2].y
        return this
    # UI
    gui  = new dat.GUI
    gui.add(controls, "uv1", 0, 1).onChange (e)->
        geom.faceVertexUvs[0][0][0].x = e
        geom.uvsNeedUpdate = true
    
    gui.add(controls, "uv2", 0, 1).onChange (e)->
        geom.faceVertexUvs[0][0][0].y = e
        geom.uvsNeedUpdate = true

    gui.add(controls, "uv3", 0, 1).onChange (e)->
        geom.faceVertexUvs[0][0][1].x = e
        geom.uvsNeedUpdate = true

    gui.add(controls, "uv4", 0, 1).onChange (e)->
        geom.faceVertexUvs[0][0][1].y = e
        geom.uvsNeedUpdate = true

    gui.add(controls, "uv5", 0, 1).onChange (e)->
        geom.faceVertexUvs[0][0][2].x = e
        geom.uvsNeedUpdate = true

    gui.add(controls, "uv6", 0, 1).onChange (e)->
        geom.faceVertexUvs[0][0][2].y = e
        geom.uvsNeedUpdate = true

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
