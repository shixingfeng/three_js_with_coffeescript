console.log "demo_4.24 MeshNormalmaterial"
camera = null
scene = null
renderer = null
a = null
b = null
c = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 10, 130
    camera.position.x = -20
    camera.position.y = 30
    camera.position.z = 40
    camera.lookAt new THREE.Vector3(10, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    
    canvasRenderer = new THREE.CanvasRenderer()
    canvasRenderer.setSize window.innerWidth, window.innerHeight

    renderer = webGLRenderer

    # 地面
    groundGeom = new THREE.PlaneGeometry 100, 100, 4, 4
    groundMesh = new THREE.Mesh(groundGeom, new THREE.MeshBasicMaterial {color: 0x777777})
    groundMesh.rotation.x = -Math.PI / 2
    groundMesh.position.y = -20
    scene.add groundMesh
    

    # 圆 方块 平面
    sphereGeometry = new THREE.SphereGeometry 14, 20, 20
    cubeGeometry = new THREE.BoxGeometry 15, 15, 15
    planeGeometry = new THREE.PlaneGeometry 14, 14, 4, 4
    
    # 材质
    meshMaterial = new THREE.MeshNormalMaterial {color: 0x7777ff}
    sphere = new THREE.Mesh sphereGeometry, meshMaterial
    cube = new THREE.Mesh cubeGeometry, meshMaterial
    plane = new THREE.Mesh planeGeometry, meshMaterial
    

    # 圆的位置
    sphere.position.x = 0
    sphere.position.y = 3
    sphere.position.z = 2
    
    f = 0
    fl = sphere.geometry.faces.length
    list = [f..fl-1]
    (face = sphere.geometry.faces[f]
    centroid = new THREE.Vector3 0, 0, 0
    centroid.add sphere.geometry.vertices[face.a]
    centroid.add sphere.geometry.vertices[face.b]
    centroid.add sphere.geometry.vertices[face.c]
    centroid.divideScalar 3
    arrow = new THREE.ArrowHelper face.normal,
            centroid,
            2,
            0x3333FF,
            0.5,
            0.5
        sphere.add arrow
    )for f in list


    # 方块和平面的位置
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

        this.visible = meshMaterial.visible
        this.side = "front"

        this.wireframe = meshMaterial.wireframe
        this.wireframeLinewidth = meshMaterial.wireframeLinewidth

        this.selectedMesh = "cube"

        this.shadow = "flat"
    
    #控制条UI
    gui = new dat.GUI()
    spGui = gui.addFolder("Mesh");
    
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
        console.log e
        switch e
            when "front" then meshMaterial.side = THREE.FrontSide
            when "back" then meshMaterial.side = THREE.BackSide
            when "double" then meshMaterial.side = THREE.DoubleSide
        meshMaterial.needsUpdate = true

    spGui.add(controls, "shadow", ["flat", "smooth"]).onChange (e)->
        switch e
            when "flat" then meshMaterial.shading = THREE.FlatShading
            when "smooth" then meshMaterial.shading = THREE.SmoothShading
       
        oldPos = sphere.position.clone()
        scene.remove sphere
        scene.remove plane
        scene.remove cube
        sphere = new THREE.Mesh sphere.geometry.clone(), meshMaterial
        cube = new THREE.Mesh cube.geometry.clone(), meshMaterial
        plane = new THREE.Mesh plane.geometry.clone(), meshMaterial

        sphere.position = oldPos
        cube.position = oldPos
        plane.position = oldPos

        switch controls.selectedMesh
            when "cube" then scene.add cube
            when "sphere" then scene.add sphere
            when "plane" then scene.add plane

        meshMaterial.needsUpdate = true
        console.log meshMaterial


    spGui.add(controls, "selectedMesh", ["cube", "sphere", "plane"]).onChange (e)->
        scene.remove plane
        scene.remove cube
        scene.remove sphere
        switch e
            when "cube" then scene.add cube
            when "sphere" then scene.add sphere
            when "plane" then scene.add plane
        scene.add e

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
