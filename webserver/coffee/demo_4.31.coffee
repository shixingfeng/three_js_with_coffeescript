console.log "demo_4.31  MeshLambertMaterial"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -20
    camera.position.y = 30
    camera.position.z = 40
    camera.lookAt new THREE.Vector3 10, 0, 0
    
    # 渲染器
    webGLRrenderer = new THREE.WebGLRenderer()
    webGLRrenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRrenderer.setSize window.innerWidth, window.innerHeight
    webGLRrenderer.shadowMapEnabled = false

    canvasRenderer = new THREE.CanvasRenderer()
    canvasRenderer.setSize window.innerWidth, window.innerHeight
   
    renderer = webGLRrenderer
    # 地面材质 和 角度
    groundGeom = new THREE.PlaneGeometry 100, 100, 4, 4
    groundMesh = new THREE.Mesh groundGeom, new THREE.MeshBasicMaterial({color: 0x555555})
    groundMesh.rotation.x = -Math.PI / 2
    groundMesh.position.y = -20
    scene.add groundMesh


    # 球体 方块 平面 
    sphereGeometry = new THREE.SphereGeometry 14, 20, 20
    cubeGeometry = new THREE.BoxGeometry 15, 15, 15
    planeGeometry = new THREE.PlaneGeometry 14, 14, 4, 4

    meshMaterial = new THREE.MeshLambertMaterial {color: 0x7777ff}
    # 加入网格
    sphere = new THREE.Mesh sphereGeometry, meshMaterial
    cube = new THREE.Mesh cubeGeometry, meshMaterial
    plane = new THREE.Mesh planeGeometry, meshMaterial
    
    # 位置
    sphere.position.x = 0
    sphere.position.y = 3
    sphere.position.z = 2

    cube.position = sphere.position
    plane.position = sphere.position

    scene.add cube

    # 光源
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight

    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -30, 60, 60
    spotLight.castShadow = true
    scene.add spotLight
    

    step = 0
    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.02
        this.bouncingSpeed = 0.03

        this.opacity = meshMaterial.opacity
        this.transparent = meshMaterial.transparent
        this.overdraw = meshMaterial.overdraw
        this.visible = meshMaterial.visible
        this.emissive = meshMaterial.emissive.getHex()
        this.ambient = meshMaterial.ambient.getHex()
        this.side = "front"

        this.color = meshMaterial.color.getStyle()
        this.wrapAround = false
        this.wrapR = 1
        this.wrapG = 1
        this.wrapB = 1

        this.selectedMesh = "cube"
    
    #控制条UI
    gui = new dat.GUI()
    spGui = gui.addFolder "Mesh"
    spGui.add(controls, "opacity", 0, 1).onChange (e)->
        meshMaterial.opacity = e

    spGui.add(controls, 'transparent').onChange (e)->
        meshMaterial.transparent = e

    spGui.add(controls, "visible").onChange (e)->
        meshMaterial.visible = e

    spGui.addColor(controls, "ambient").onChange (e)->
        meshMaterial.ambient = new THREE.Color e

    spGui.addColor(controls, "emissive").onChange (e)->
        meshMaterial.emissive = new THREE.Color e

    spGui.add(controls, "side", ["front", "back", "double"]).onChange (e)->
        switch e
            when "front" then  meshMaterial.side = THREE.FrontSide
            when "back" then meshMaterial.side = THREE.BackSide
            when "double" then meshMaterial.side = THREE.DoubleSide
        meshMaterial.needsUpdate = true

    spGui.addColor(controls, "color").onChange (e)->
        meshMaterial.color.setStyle e
    

    spGui.add(controls, "selectedMesh", ["cube", "sphere", "plane"]).onChange (e)->
        scene.remove plane
        scene.remove cube
        scene.remove sphere
        switch e
            when "cube" then scene.add cube
            when "sphere" then scene.add sphere
            when "plane" then scene.add plane
        scene.add e


    spGui.add(controls, "wrapAround").onChange (e)->
        meshMaterial.wrapAround = e
        meshMaterial.needsUpdate = true

    spGui.add(controls, "wrapR", 0, 1).step(0.01).onChange (e)->
        meshMaterial.wrapRGB.x = e

    spGui.add(controls, "wrapG", 0, 1).step(0.01).onChange (e)->
        meshMaterial.wrapRGB.y = e

    spGui.add(controls, "wrapB", 0, 1).step(0.01).onChange (e)->
        meshMaterial.wrapRGB.z = e
    

    # 实时渲染
    renderScene = ()->
        stats.update()

        cube.rotation.y = step += 0.01
        plane.rotation.y = step
        sphere.rotation.y = step

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
