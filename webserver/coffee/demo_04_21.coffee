console.log "demo_4.1 MeshBasicMaterial"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -20
    camera.position.y = 50
    camera.position.z = 40
    camera.lookAt new THREE.Vector3 10, 0, 0
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true

    canvasRenderer = new THREE.CanvasRenderer()
    canvasRenderer.setSize window.innerWidth, window.innerHeight
    
    renderer = webGLRenderer
    
    # 地面
    groundGeom = new THREE.PlaneGeometry(100, 100, 4, 4);
    groundMesh = new THREE.Mesh groundGeom, new THREE.MeshBasicMaterial({color: 0x777777})
    groundMesh.rotation.x = -Math.PI / 2
    groundMesh.position.y = -20
    scene.add groundMesh

    # 圆 方块 平面
    sphereGeometry = new THREE.SphereGeometry 14, 20, 20
    cubeGeometry = new THREE.BoxGeometry 15, 15, 15
    planeGeometry = new THREE.PlaneGeometry 14, 14, 4, 4

    # 材质
    meshMaterial = new THREE.MeshBasicMaterial {color: 0x7777ff}
    
    # 加入网格的物体由以上两个属性决定
    sphere = new THREE.Mesh sphereGeometry, meshMaterial 
    cube = new THREE.Mesh cubeGeometry, meshMaterial 
    plane = new THREE.Mesh planeGeometry, meshMaterial 

    # 加入的位置
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
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight

    step = 0
    oldContext = null
    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.02
        this.bouncingSpeed = 0.03

        this.opacity = meshMaterial.opacity
        this.transparent = meshMaterial.transparent
        this.overdraw = meshMaterial.overdraw
        this.visible = meshMaterial.visible
        this.side = "front"

        this.color = meshMaterial.color.getStyle()
        this.wireframe = meshMaterial.wireframe
        this.wireframeLinewidth = meshMaterial.wireframeLinewidth
        this.wireFrameLineJoin = meshMaterial.wireframeLinejoin

        this.selectedMesh = "cube"

        this.switchRenderer = ()->
            if renderer instanceof THREE.WebGLRenderer
                renderer = canvasRenderer
                $("#WebGL-output").empty()
                $("#WebGL-output").append renderer.domElement
            else
                renderer = webGLRenderer
                $("#WebGL-output").empty()
                $("#WebGL-output").append renderer.domElement
        return this

    
    #控制条UI
    gui = new dat.GUI()
    spGui = gui.addFolder "Mesh"
    
    spGui.add(controls, "opacity", 0, 1).onChange (e)->
        meshMaterial.opacity = e
    
    spGui.add(controls, "transparent").onChange (e)->
        meshMaterial.transparent = e
    
    spGui.add(controls, "wireframe").onChange (e)->
        meshMaterial.wireframe = e
    
    spGui.add(controls, "wireframeLinewidth", 0, 20).onChange (e)->
        meshMaterial.wireframeLinewidth = e
    
    spGui.add(controls, "visible").onChange (e)->
        meshMaterial.visible = e

    spGui.add(controls, "side", ["front", "back", "double"]).onChange (e)->
        switch e
            when "front" then meshMaterial.side = THREE.FrontSide
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

    gui.add controls, "switchRenderer"
        
    cvGui = gui.addFolder "Canvas renderer"
   
    cvGui.add(controls, "overdraw").onChange (e)->
        meshMaterial.overdraw = e
    
    cvGui.add(controls, "wireFrameLineJoin", ["round", "bevel", "miter"]).onChange (e)->
        meshMaterial.wireframeLinejoin = e

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

# 屏幕适配
onResize = ()->
    console.log "onResize"
    camera.aspect = window.innerWidth/window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

window.onload = init()
window.addEventListener "resize", onResize, false
