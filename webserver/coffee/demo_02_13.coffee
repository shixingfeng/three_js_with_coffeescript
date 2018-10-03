console.log "demo_02_13 材质覆盖"
console.log "overrideMaterial属性,为场景中所有物体指定材质"
camera = null
scene = null
renderer = null
# 屏幕适配
onResize = ()->
    console.log "onResize"
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

init = ()->
    # 给场景中所有物体添加属性指向的材质
    scene = new THREE.Scene()
    scene.overrideMaterial = new THREE.MeshLambertMaterial {color:0xffffff}

    # 摄像机参数
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -30
    camera.position.y = 40
    camera.position.z = 30
    camera.lookAt scene.position
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0xEEEEEE, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    
    # 物体材质和几何
    planeGeometry = new THREE.PlaneGeometry 60, 40, 1, 1
    planeMaterial = new THREE.MeshLambertMaterial {color:0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial
    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 0
    plane.position.y = 0
    plane.position.z = 0
    scene.add plane
    
    # 灯光 类型、位置、阴影并加入场景
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight

    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.02
        this.numberOfObjects = scene.children.length
        this.removeCube = ()->
            allChildren = scene.children
            lastObject = allChildren[allChildren.length - 1]
            if lastObject instanceof THREE.Mesh
                scene.remove(lastObject)
                this.numberOfObjects = scene.children.length
        this.addCube = ()->
            cubeSize = Math.ceil (Math.random()*3)
            cubeGeometry = new THREE.BoxGeometry cubeSize, cubeSize, cubeSize
            cubeMaterial = new THREE.MeshLambertMaterial {color:Math.random()*0xffffff}
            cube = new THREE.Mesh cubeGeometry,cubeMaterial
            cube.castShadow = true
            cube.name = "cube-"+scene.children.length
            cube.position.x = -30 + Math.round(Math.random()*planeGeometry.parameters.width)
            cube.position.y = Math.round(Math.random()*5)
            cube.position.z = -20 + Math.round(Math.random()*planeGeometry.parameters.height)
            scene.add cube
            this.numberOfObjects = scene.children.length
        this.outputObjects = ()->
            console.log scene.children
        return this
    gui = new dat.GUI()
    gui.add controls, "rotationSpeed", 0, 0.5
    gui.add controls, "addCube"
    gui.add controls, "removeCube"
    gui.add controls, "outputObjects"
    gui.add(controls, "numberOfObjects").listen()

    #帧数显示
    initStats = ()->
        stats = new Stats()
        stats.setMode 0
        stats.domElement.style.position = "absolute"
        stats.domElement.style.left = "0px"
        stats.domElement.style.top = "0px"
        $("#Stats-output").append stats.domElement
        return stats

    # 帧数更新、物体控制参数、调用渲染本身,将结果输出到屏幕
    renderScene = ()->
        stats.update()
        
        scene.traverse (e)->
            if e instanceof THREE.Mesh and e != plane
                e.rotation.x += controls.rotationSpeed
                e.rotation.y += controls.rotationSpeed
                e.rotation.z += controls.rotationSpeed

        requestAnimationFrame renderScene
        renderer.render scene,camera
        $("#WebGL-output").append renderer.domElement
    
    # 执行帧数显示(在renderScene中执行更新)、实时渲染、屏幕监听
    stats = initStats()
    renderScene()
    window.addEventListener "resize", onResize, false


# 浏览器加载完成时，执行函数init()
window.onload = init