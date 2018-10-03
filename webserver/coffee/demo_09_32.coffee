console.log "demo9.32 Manual morph targets"
camera = null
scene = null
renderer = null
mesh = null
meshAnim = null
currentMesh = null
step = 0

init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000    
    camera.position.x = -15
    camera.position.y = 15
    camera.position.z = 15
    camera.lookAt scene.position


    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight    
    webGLRenderer.shadowMapEnabled = true
    
    renderer = webGLRenderer


    # 地面 方块
    planeGeometry = new THREE.PlaneGeometry 20, 20, 1, 1
    planeMaterial = new THREE.MeshLambertMaterial {color: 0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial
    plane.rotation.x = -0.5 * Math.PI
    plane.position.x =
    plane.position.y = 0
    plane.position.z = 0
    scene.add plane

    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    cubeMaterial = new THREE.MeshLambertMaterial {morphTargets: true, color: 0xff0000}
    cubeTarget1 = new THREE.BoxGeometry 2, 10, 2
    cubeTarget2 = new THREE.BoxGeometry 8, 2, 8
    cubeGeometry.morphTargets[0] = {name: 't1', vertices: cubeTarget2.vertices}
    cubeGeometry.morphTargets[1] = {name: 't2', vertices: cubeTarget1.vertices}
    cubeGeometry.computeMorphNormals()
    cube = new THREE.Mesh cubeGeometry, cubeMaterial
    cube.position.x = 0
    cube.position.y = 3
    cube.position.z = 0
    scene.add cube

    # 灯光
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight 

    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -25, 25, 15
    scene.add spotLight


    # 控制台
    controls = new ()->
        this.influence1 = 0.01
        this.influence2 = 0.01
        this.update = ()->
            cube.morphTargetInfluences[0] = controls.influence1
            cube.morphTargetInfluences[1] = controls.influence2
        return this

    # UI
    gui = new dat.GUI()
    gui.add(controls, "influence1", 0, 1).onChange controls.update
    gui.add(controls, "influence2", 0, 1).onChange controls.update


    # 执行

    # 实时渲染
    renderScene = ()->
        stats.update()
        
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
