console.log "启用coffee demo_2.22"
camera = null
scene = null
renderer = null
controls = null
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 50
    camera.position.y = 60
    camera.position.z = 80
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
    
    # 环境光
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight

    # 点光源
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight

    # 雾化
    # 线性增长
    # scene.fog = new THREE.Fog 0xffffff, 0.015, 100
    # 非线性增长
    # scene.fog = new THREE.FogExp2 0xffffff, 0.01

    # 材质覆盖
    # scene.overrideMaterial = new THREE.MeshLambertMaterial {color:0xffffff}


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
    
    # 创建网格对象加入场景
    material = new THREE.MeshLambertMaterial {color: 0x44ff44}
    geom = new THREE.BoxGeometry 5, 8, 3
    cube = new THREE.Mesh geom, material
    cube.position.y = 4
    cube.castShadow = true
    scene.add(cube)

    # gui控制条
    gui = new dat.GUI()
    # 缩放
    guiScale = gui.addFolder "scale"
    guiScale.add controls, "scaleX", 0, 5
    guiScale.add controls, "scaleY", 0, 5
    guiScale.add controls, "scaleZ", 0, 5

    #位置 相对于父对象
    guiPosition = gui.addFolder 'position'
    contX = guiPosition.add controls, "positionX", -10, 10
    contY = guiPosition.add controls, "positionY", -4,  20
    contZ = guiPosition.add controls, "positionZ", -10, 10

    # 监听位置变化
    contX.listen()
    contX.onChange (value) ->
            cube.position.x = controls.positionX
    contY.listen()
    contY.onChange (value) ->
            cube.position.y = controls.positionY
    contZ.listen()
    contZ.onChange (value) ->
            cube.position.z = controls.positionZ
    
    #翻转
    guiRotation = gui.addFolder "rotation"
    guiRotation.add controls, "rotationX", -4, 4
    guiRotation.add controls, "rotationY", -4, 4
    guiRotation.add controls, "rotationZ", -4, 4

    # 沿轴移动
    guiTranslate = gui.addFolder "translate" 
    guiTranslate.add controls, "translateX", -10, 10
    guiTranslate.add controls, "translateY", -10, 10
    guiTranslate.add controls, "translateZ", -10, 10
    guiTranslate.add controls, "translate"
    
    #是否渲染
    gui.add controls, "visible"
    # 实时渲染
    renderScene = ()->
        stats.update()
        # 是否允许被渲染
        cube.visible = controls.visible

        #渲染翻转 
        cube.rotation.x = controls.rotationX
        cube.rotation.y = controls.rotationY
        cube.rotation.z = controls.rotationZ

        # 渲染缩放
        cube.scale.set controls.scaleX, controls.scaleY, controls.scaleZ
        
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
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

window.onload = init()
# 监听方法一
window.addEventListener 'resize', onResize, false