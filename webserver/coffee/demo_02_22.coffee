console.log "demo_02_22 物体属性"
console.log "属性：缩放、移动、旋转、相对位置、是否可见"
camera = null
renderer = null

# 屏幕适配
onResize = ()->
    console.log "onResize"
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
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
    plane.receiveShadow = true
    scene.add plane    
    material = new THREE.MeshLambertMaterial {color: 0x44ff44}
    geom = new THREE.BoxGeometry 5, 8, 3
    cube = new THREE.Mesh geom, material
    cube.position.y = 4
    cube.castShadow = true
    scene.add(cube)

    # 灯光
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight

    # 控制台
    controls = new ()->
        this.scaleX = 1
        this.scaleY = 1
        this.scaleZ = 1
        this.positionX = 0
        this.positionY = 4
        this.positionZ = 0
        this.rotationX = 0
        this.rotationY = 0
        this.rotationZ = 0
        this.scale = 1
        this.translateX = 0
        this.translateY = 0
        this.translateZ = 0
        this.visible = true
        this.translate = ()->
            cube.translateX controls.translateX
            cube.translateY controls.translateY
            cube.translateZ controls.translateZ
            controls.positionX = cube.position.x
            controls.positionY = cube.position.y
            controls.positionZ = cube.position.z 
        return this
    
    gui = new dat.GUI()
    guiScale = gui.addFolder "scale"
    guiScale.add controls, "scaleX", 0, 5
    guiScale.add controls, "scaleY", 0, 5
    guiScale.add controls, "scaleZ", 0, 5
    guiPosition = gui.addFolder 'position'
    contX = guiPosition.add controls, "positionX", -10, 10
    contY = guiPosition.add controls, "positionY", -4,  20
    contZ = guiPosition.add controls, "positionZ", -10, 10
    #位置变化
    contX.listen()
    contY.listen()
    contZ.listen()
    contX.onChange (value) ->
        cube.position.x = controls.positionX
    contY.onChange (value) ->
        cube.position.y = controls.positionY
    contZ.onChange (value) ->
        cube.position.z = controls.positionZ
    
    guiRotation = gui.addFolder "rotation"
    guiRotation.add controls, "rotationX", -4, 4
    guiRotation.add controls, "rotationY", -4, 4
    guiRotation.add controls, "rotationZ", -4, 4
    guiTranslate = gui.addFolder "translate" 
    guiTranslate.add controls, "translateX", -10, 10
    guiTranslate.add controls, "translateY", -10, 10
    guiTranslate.add controls, "translateZ", -10, 10
    guiTranslate.add controls, "translate"
    gui.add controls, "visible"
    
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
        
        cube.visible = controls.visible
        cube.rotation.x = controls.rotationX
        cube.rotation.y = controls.rotationY
        cube.rotation.z = controls.rotationZ
        cube.scale.set controls.scaleX, controls.scaleY, controls.scaleZ
        
        requestAnimationFrame renderScene
        renderer.render scene,camera
        $("#WebGL-output").append renderer.domElement

    # 执行帧数显示(在renderScene中执行更新)、实时渲染、屏幕监听
    stats = initStats()
    renderScene()
    window.addEventListener "resize", onResize, false

    # 浏览器加载完成时，执行函数init()
window.onload = init