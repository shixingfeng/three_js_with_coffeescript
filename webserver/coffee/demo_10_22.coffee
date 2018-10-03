console.log "demo_10.22 Repeat mapping"
camera = null
scene = null
renderer = null
mesh = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 0
    camera.position.y = 12
    camera.position.z = 20
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
        texture.wrapS = THREE.RepeatWrapping
        texture.wrapT = THREE.RepeatWrapping

        geom.computeVertexNormals()
        mat = new THREE.MeshPhongMaterial()
        mat.map = texture
        mesh = new THREE.Mesh geom, mat
        return mesh



    # 圆和方块
    sphere = createMesh new THREE.SphereGeometry(5, 20, 20), "floor-wood.jpg"
    sphere.position.x = 7
    scene.add sphere

    cube = createMesh new THREE.BoxGeometry(6, 6, 6), "brick-wall.jpg"
    cube.position.x = -7
    scene.add cube
    console.log cube.geometry.faceVertexUvs


    # 控制条
    controls = new ()->
        this.repeatX = 1
        this.repeatY = 1
        this.repeatWrapping = true

        this.updateRepeat = (e)->
            cube.material.map.repeat.set controls.repeatX, controls.repeatY
            sphere.material.map.repeat.set controls.repeatX, controls.repeatY
            if controls.repeatWrapping
                cube.material.map.wrapS = THREE.RepeatWrapping
                cube.material.map.wrapT = THREE.RepeatWrapping
                sphere.material.map.wrapS = THREE.RepeatWrapping
                sphere.material.map.wrapT = THREE.RepeatWrapping
            else 
                cube.material.map.wrapS = THREE.ClampToEdgeWrapping
                cube.material.map.wrapT = THREE.ClampToEdgeWrapping
                sphere.material.map.wrapS = THREE.ClampToEdgeWrapping
                sphere.material.map.wrapT = THREE.ClampToEdgeWrapping
            cube.material.map.needsUpdate = true
            sphere.material.map.needsUpdate = true
        return this
    # UI
    gui  = new dat.GUI
    gui.add(controls, "repeatX", -4, 4).onChange controls.updateRepeat
    gui.add(controls, "repeatY", -4, 4).onChange controls.updateRepeat
    gui.add(controls, "repeatWrapping").onChange controls.updateRepeat
    
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        step += 0.01
        cube.rotation.y = step
        cube.rotation.x = step
        sphere.rotation.y = step
        sphere.rotation.x = step
    
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