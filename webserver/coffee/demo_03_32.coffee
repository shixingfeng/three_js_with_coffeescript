console.log "启用coffee demo_3.32"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 20
    camera.position.y = 30
    camera.position.z = 21
    camera.lookAt new THREE.Vector3(0, 0, -30)
    scene.add camera
    
    # GLDeferred渲染器
    renderer = new THREE.WebGLDeferredRenderer {
        width: window.innerWidth,
        height: window.innerHeight,
        scale: 1,
        antialias: true,
        tonemapping: THREE.FilmicOperator,
        brightness: 2.5
     }

    # 创建地面方块
    planeGeometry = new THREE.PlaneGeometry 70, 70, 1, 1
    planeMaterial = new THREE.MeshPhongMaterial {color: 0xffffff, specular: 0xffffff, shininess: 200}
    plane = new THREE.Mesh planeGeometry,planeMaterial

    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 0
    plane.position.y = 0
    plane.position.z = 0
    plane.receiveShadow = true
    scene.add plane

    # 光源0
    spotLight0 = new THREE.SpotLight 0xcccccc
    spotLight0.position.set -40, 60, -10
    spotLight0.intensity = 0.1
    spotLight0.lookAt plane
    scene.add spotLight0

    # 光源1
    areaLight1 = new THREE.AreaLight 0xff0000, 3
    areaLight1.position.set -10, 10, -35
    areaLight1.rotation.set -Math.PI / 2, 0, 0
    areaLight1.width = 4
    areaLight1.height = 9.9
    scene.add areaLight1
    # 光源2
    areaLight2 = new THREE.AreaLight 0x00ff00, 3
    areaLight2.position.set 0, 10, -35
    areaLight2.rotation.set -Math.PI / 2, 0, 0
    areaLight2.width = 4
    areaLight2.height = 9.9
    scene.add areaLight2
    # 光源3
    areaLight3 = new THREE.AreaLight 0x0000ff, 3
    areaLight3.position.set 10, 10, -35
    areaLight3.rotation.set -Math.PI / 2, 0, 0
    areaLight3.width = 4
    areaLight3.height = 9.9
    scene.add areaLight3




    # 创建方块
    planeGeometry1 = new THREE.BoxGeometry 4, 10, 0
    planeGeometry1Mat = new THREE.MeshBasicMaterial {color: 0xff0000}
    plane1 = new THREE.Mesh planeGeometry1, planeGeometry1Mat
    plane1.position.copy areaLight1.position
    scene.add plane1


    planeGeometry2 = new THREE.BoxGeometry 4, 10, 0
    planeGeometry2Mat = new THREE.MeshBasicMaterial {color: 0x00ff00}
    plane2 = new THREE.Mesh planeGeometry2, planeGeometry2Mat
    plane2.position.copy areaLight2.position
    scene.add plane2

    planeGeometry3 = new THREE.BoxGeometry 4, 10, 0
    planeGeometry3Mat = new THREE.MeshBasicMaterial {color: 0x0000ff}
    plane3 = new THREE.Mesh planeGeometry3, planeGeometry3Mat
    plane3.position.copy areaLight3.position
    scene.add plane3

    
    
    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.02
        this.color1 = 0xff0000
       
        this.intensity1 = 2
        this.color2 = 0x00ff00
       
        this.intensity2 = 2
        this.color3 = 0x0000ff
       
        this.intensity3 = 2
    
    #控制条UI
    gui = new dat.GUI()
    gui.addColor(controls, "color1").onChange (e)->
        areaLight1.color = new THREE.Color e
        planeGeometry1Mat.color = new THREE.Color e
        scene.remove plane1
        plane1 = new THREE.Mesh planeGeometry1, planeGeometry1Mat
        plane1.position.copy areaLight1.position
        scene.add plane1
    
    gui.add(controls, 'intensity1', 0, 5).onChange (e)->
        areaLight1.intensity = e
    
    gui.addColor(controls, 'color2').onChange (e)->
        areaLight2.color = new THREE.Color e
        planeGeometry2Mat.color = new THREE.Color e
        scene.remove plane2
        plane2 = new THREE.Mesh planeGeometry2, planeGeometry2Mat
        plane2.position.copy areaLight2.position
        scene.add plane2
    
    gui.add(controls, 'intensity2', 0, 5).onChange (e)->
        areaLight2.intensity = e
    
    gui.addColor(controls, 'color3').onChange (e)->
        areaLight3.color = new THREE.Color e
        planeGeometry3Mat.color = new THREE.Color e
        scene.remove plane3
        plane3 = new THREE.Mesh planeGeometry1, planeGeometry3Mat
        plane3.position.copy areaLight3.position
        scene.add plane3
    
    gui.add(controls, 'intensity3', 0, 5).onChange (e)->
        areaLight3.intensity = e

    # 实时渲染
    step = 0
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

# 屏幕适配
onResize = ()->
    console.log "onResize"
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

window.onload = init()
window.addEventListener "resize", onResize, false