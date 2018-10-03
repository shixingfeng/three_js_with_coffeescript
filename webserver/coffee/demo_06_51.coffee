console.log "demo_6.51  Binary operations"
camera = null
scene = null
renderer = null
spinner = null
result = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 0
    camera.position.y = 20
    camera.position.z = 20
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x999999, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true

    renderer = webGLRenderer
 

    createMesh = (geom)->
        meshMaterial = new THREE.MeshNormalMaterial()
        meshMaterial.side = THREE.DoubleSide
        wireFrameMat = new THREE.MeshBasicMaterial {transparency: true, opacity: 0.5, wireframeLinewidth: 0.5}
        wireFrameMat.wireframe = true

        mesh = new THREE.Mesh geom, wireFrameMat
        return mesh
   

    showSpinner = ()->
        opts =
            lines: 13 
            length: 20
            width: 10
            radius: 30
            corners: 1
            rotate: 0
            direction: 1
            color: "#000"
            speed: 1
            trail: 60
            shadow: false
            hwaccel: false
            className: "spinner"
            zIndex: 2e9
            top: "auto"
            left: "auto" 
        target = document.getElementById('WebGL-output')
        spinner = new Spinner(opts).spin target
        return spinner

    hideSpinner = (spinner) ->
        spinner.stop()


    redrawResult = ()->
        showSpinner()
        setTimeout = ()->
            scene.remove result
            sphere1BSP = new ThreeBSP sphere1
            sphere2BSP = new ThreeBSP sphere2
            cube2BSP = new ThreeBSP cube
            
            resultBSP = null
            switch controls.actionSphere
                when "subtract" then resultBSP = sphere1BSP.subtract sphere2BSP
                when "intersect" then resultBSP = sphere1BSP.intersect sphere2BSP
                when "union" then resultBSP = sphere1BSP.union sphere2BSP
                when "none" then 

            if not resultBSP
                resultBSP = sphere1BSP
            
            switch controls.actionCube
                when "subtract" then resultBSP = sphere1BSP.subtract cube2BSP
                when "intersect" then resultBSP = sphere1BSP.intersect cube2BSP
                when "union" then resultBSP = sphere1BSP.union cube2BSP
                when "none" then

            if controls.actionCube is "none" and controls.actionSphere is "none"

            else
                result = resultBSP.toMesh()
                result.geometry.computeFaceNormals()
                result.geometry.computeVertexNormals()
                scene.add result

            hideSpinner spinner
            ,200

    # 球体和方块
    sphere1 = createMesh new THREE.SphereGeometry 5, 20, 30
    sphere1.position.x = -2


    sphere2 = createMesh new THREE.SphereGeometry 5, 20, 30
    sphere2.position.set 3, 0, 0

    cube = createMesh new THREE.BoxGeometry 5, 5, 5
    cube.position.x = -7

    scene.add sphere1
    scene.add sphere2
    scene.add cube
    
    # 控制条
    controls = new ()->
        this.sphere1PosX = sphere1.position.x
        this.sphere1PosY = sphere1.position.y
        this.sphere1PosZ = sphere1.position.z
        this.sphere1Scale = 1

        this.sphere2PosX = sphere2.position.x
        this.sphere2PosY = sphere2.position.y
        this.sphere2PosZ = sphere2.position.z
        this.sphere2Scale = 1

        this.cubePosX = cube.position.x
        this.cubePosY = cube.position.y
        this.cubePosZ = cube.position.z
        
        this.scaleX = 1
        this.scaleY = 1
        this.scaleZ = 1

        this.actionCube = "subtract"
        this.actionSphere = "subtract"

        this.showResult = ()->
            redrawResult()
            console.log "showResult"
            return this
        
        this.hideWireframes = false
        this.rotateResult = false
        return this


    gui = new dat.GUI()
    guiSphere1 = gui.addFolder "Sphere1"
    
    guiSphere1.add(controls, "sphere1PosX", -15, 15).onChange ()->
        sphere1.position.set controls.sphere1PosX, controls.sphere1PosY, controls.sphere1PosZ

    guiSphere1.add(controls, "sphere1PosY", -15, 15).onChange ()->
        sphere1.position.set controls.sphere1PosX, controls.sphere1PosY, controls.sphere1PosZ
    
    guiSphere1.add(controls, "sphere1PosZ", -15, 15).onChange ()->
        sphere1.position.set controls.sphere1PosX, controls.sphere1PosY, controls.sphere1PosZ
    
    guiSphere1.add(controls, "sphere1Scale", 0, 10).onChange (e)->
        sphere1.scale.set e, e, e
    

    guiSphere2 = gui.addFolder "Sphere2"
    
    guiSphere2.add(controls, "sphere2PosX", -15, 15).onChange ()->
        sphere2.position.set controls.sphere2PosX, controls.sphere2PosY, controls.sphere2PosZ
    
    guiSphere2.add(controls, "sphere2PosY", -15, 15).onChange ()->
        sphere2.position.set controls.sphere2PosX, controls.sphere2PosY, controls.sphere2PosZ
    
    guiSphere2.add(controls, "sphere2PosZ", -15, 15).onChange ()->
        sphere2.position.set controls.sphere2PosX, controls.sphere2PosY, controls.sphere2PosZ
    
    guiSphere2.add(controls, "sphere2Scale", 0, 10).onChange (e)->
        sphere2.scale.set e, e, e
    
    guiSphere2.add controls, "actionSphere", ["subtract", "intersect", "union", "none"]

    
    guiCube = gui.addFolder "cube"
    
    guiCube.add(controls, "cubePosX", -15, 15).onChange ()->
        cube.position.set controls.cubePosX, controls.cubePosY, controls.cubePosZ
    
    guiCube.add(controls, "cubePosY", -15, 15).onChange ()->
        cube.position.set controls.cubePosX, controls.cubePosY, controls.cubePosZ
    
    guiCube.add(controls, "cubePosZ", -15, 15).onChange ()->
        cube.position.set controls.cubePosX, controls.cubePosY, controls.cubePosZ
    
    guiCube.add(controls, "scaleX", 0, 10).onChange (e)->
        cube.scale.x = e
    
    guiCube.add(controls, "scaleY", 0, 10).onChange (e)->
        cube.scale.y = e
    
    guiCube.add(controls, "scaleZ", 0, 10).onChange (e)->
        cube.scale.z = e
    
    guiCube.add controls, "actionCube", ["subtract", "intersect", "union", "none"]

    gui.add controls, "showResult"
    gui.add controls, "rotateResult"
    gui.add(controls, "hideWireframes").onChange ()->
        if controls.hideWireframes
            sphere1.material.visible = false
            sphere2.material.visible = false
            cube.material.visible = false
        else
            sphere1.material.visible = true
            sphere2.material.visible = true
            cube.material.visible = true
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        if controls.rotateResult and result
            result.rotation.y += 0.04
            result.rotation.z -= 0.005

        
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
