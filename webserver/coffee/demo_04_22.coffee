console.log "demo_4.2 MeshDepthMaterial"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    scene.overrideMaterial = new THREE.MeshDepthMaterial()


    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 10, 130
    camera.position.x = -50
    camera.position.y = 40
    camera.position.z = 50
    camera.lookAt scene.position
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color(0x00000, 1.0)
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true


    step = 0
    # 控制台
    controls = new ()->
        this.cameraNear = camera.near
        this.cameraFar = camera.far
        this.rotationSpeed = 0.02
        this.numberOfObjects = scene.children.length

        this.removeCube = ()->
            allChildren = scene.children
            lastObject = allChildren[allChildren.length - 1]

            if lastObject instanceof THREE.Mesh
                scene.remove lastObject
                this.numberOfObjects = scene.children.length
        
        
        this.addCube = ()->
            cubeSize = Math.ceil(3 + (Math.random() * 3))
            cubeGeometry = new THREE.BoxGeometry cubeSize, cubeSize, cubeSize
            cubeMaterial = new THREE.MeshLambertMaterial({color: Math.random() * 0xffffff})
            cube = new THREE.Mesh cubeGeometry, cubeMaterial
            cube.castShadow = true

            cube.position.x = -60 + Math.round((Math.random() * 100))
            cube.position.y = Math.round((Math.random() * 10))
            cube.position.z = -100 + Math.round((Math.random() * 150))

            scene.add cube
            this.numberOfObjects = scene.children.length
        
        this.outputObjects = ()->
            console.log scene.children
        return this
    
    #控制条UI
    gui = new dat.GUI()
    gui.add controls,"rotationSpeed", 0, 0.5
    
    gui.add controls,"addCube"
    
    gui.add controls,"removeCube"
    
    gui.add(controls, "cameraNear", 0, 50).onChange (e)->
        camera.near = e
    
    gui.add(controls, "cameraFar", 50, 200).onChange (e)->
        camera.far = e

    i = 10
    controls.addCube() while i -= 1

    # 实时渲染
    renderScene = ()->
        stats.update()
        
        scene.traverse (e)->
            if e instanceof THREE.Mesh
                e.rotation.x += controls.rotationSpeed
                e.rotation.y += controls.rotationSpeed
                e.rotation.z += controls.rotationSpeed

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
