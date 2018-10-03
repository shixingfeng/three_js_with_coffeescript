console.log "demo_08.12 Merge objects"
camera = null
renderer = null
step = 0


#屏幕适配
onResize =()->
    console.log "onResize"
    camera.aspect = window.innerWidth/window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 500
    camera.position.x = 0
    camera.position.y = 40
    camera.position.z = 50
    camera.lookAt scene.position
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x00000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    

    # 材质
    createMesh = (geom)->
        meshMaterial = new THREE.MeshBasicMaterial {vertexColors: THREE.VertexColors, wireframe: true, wireframeLinewidth: 2, color: 0xaaaaaa}
        meshMaterial.side = THREE.DoubleSide

        mesh = new THREE.Mesh geom, meshMaterial
        return mesh
    cubeMaterial = new THREE.MeshNormalMaterial {color: 0x00ff00, transparent: true, opacity: 0.5}
    addcube = ()->
        cubeSize = 1.0;
        cubeGeometry = new THREE.BoxGeometry cubeSize, cubeSize, cubeSize
        cube = new THREE.Mesh cubeGeometry, cubeMaterial
        cube.castShadow = true
        cube.position.x = -60 + Math.round((Math.random() * 100))
        cube.position.y = Math.round((Math.random() * 10))
        cube.position.z = -150 + Math.round((Math.random() * 175))
        return cube


    #网格物体
    knot = createMesh new THREE.TorusKnotGeometry(10, 1, 64, 8, 2, 3, 1)
    scene.add knot

    # 控制条
    controls = new ()->
        this.cameraNear = camera.near
        this.cameraFar = camera.far
        this.rotationSpeed = 0.02
        this.combined = false
        this.numberOfObjects = 500
        this.redraw = ()->
            toRemove = []
            scene.traverse (e)->
                if e instanceof THREE.Mesh
                    toRemove.push e
            toRemove.forEach (e)->
                scene.remove e

            if controls.combined
                geometry = new THREE.Geometry()
                for i in [0..controls.numberOfObjects-1]
                    cubeMesh = addcube()
                    cubeMesh.updateMatrix()
                    geometry.merge cubeMesh.geometry, cubeMesh.matrix
                scene.add new THREE.Mesh(geometry, cubeMaterial)
            else 
                for i in [0..controls.numberOfObjects-1]
                    scene.add controls.addCube()
        this.addCube = addcube

        this.outputObjects = ()->
            console.log scene.children
        return this
    # UI呈现
    gui = new dat.GUI()
    gui.add controls, "numberOfObjects", 0, 20000
    gui.add(controls, "combined").onChange controls.redraw
    gui.add controls, "redraw"

    # 执行
    controls.redraw()
    
    # 状态条
    initStats = ()->
        stats = new Stats()
        stats.setMode 0
        stats.domElement.style.position = "absolute"
        stats.domElement.style.left = "0px"
        stats.domElement.style.top = "0px"
        $("#Stats-output").append stats.domElement
        return stats


    # 实时渲染
    renderScene = ()->
        stats.update()
        
        knot.rotation.y = step += 0.01
        requestAnimationFrame renderScene
        
        renderer.render scene,camera
        $("#WebGL-output").append renderer.domElement
        

    stats = initStats()
    renderScene()
    window.addEventListener "resize", onResize, false

    
window.onload = init
