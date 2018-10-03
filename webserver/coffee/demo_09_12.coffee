console.log "demo9.12 Selecting objects"
camera = null
scene = null
renderer = null
tube = null
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
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight    
    renderer = webGLRenderer




    # 地面
    planeGeometry = new THREE.PlaneGeometry 60, 20, 1, 1
    planeMaterial = new THREE.MeshLambertMaterial {color: 0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial

    # 角度
    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 15
    plane.position.y = 0
    plane.position.z = 0
    scene.add plane

    # 方块，圆，圆柱
    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    cubeMaterial = new THREE.MeshLambertMaterial {color: 0xff0000}
    cube = new THREE.Mesh cubeGeometry, cubeMaterial
    cube.position.x = -9
    cube.position.y = 3
    cube.position.z = 0
    scene.add cube

    sphereGeometry = new THREE.SphereGeometry 4, 20, 20
    sphereMaterial = new THREE.MeshLambertMaterial {color: 0x7777ff}
    sphere = new THREE.Mesh sphereGeometry, sphereMaterial
    sphere.position.x = 20
    sphere.position.y = 0
    sphere.position.z = 2
    scene.add sphere

    cylinderGeometry = new THREE.CylinderGeometry 2, 2, 20
    cylinderMaterial = new THREE.MeshLambertMaterial {color: 0x77ff77}
    cylinder = new THREE.Mesh cylinderGeometry, cylinderMaterial
    cylinder.position.set 0, 0, 1
    scene.add cylinder



    # 灯光
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight

    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    scene.add spotLight

    # 事件触发
    onDocumentMouseDown = (event)->
        vector = new THREE.Vector3(
            ( event.clientX / window.innerWidth ) * 2 - 1,
            -( event.clientY / window.innerHeight ) * 2 + 1,
            0.5)
        vector = vector.unproject camera

        raycaster = new THREE.Raycaster camera.position, vector.sub(camera.position).normalize()

        intersects = raycaster.intersectObjects [sphere, cylinder, cube]

        if intersects.length > 0
            console.log intersects[0]
            intersects[0].object.material.transparent = true
            intersects[0].object.material.opacity = 0.1

    onDocumentMouseMove = (event)->
        if controls.showRay
            vector = new THREE.Vector3(
                ( event.clientX / window.innerWidth ) * 2 - 1,
                -( event.clientY / window.innerHeight ) * 2 + 1,
                0.5)
            vector = vector.unproject camera

            raycaster = new THREE.Raycaster camera.position, vector.sub(camera.position).normalize()
            intersects = raycaster.intersectObjects [sphere, cylinder, cube]

            if intersects.length > 0
                points = []
                points.push new THREE.Vector3 -30, 39.8, 30
                points.push intersects[0].point

                mat = new THREE.MeshBasicMaterial(
                    {color: 0xff0000,
                    transparent: true,
                    opacity: 0.6})
                tubeGeometry = new THREE.TubeGeometry new THREE.SplineCurve3(points), 60, 0.001
                if tube
                    scene.remove tube
                if controls.showRay
                    tube = new THREE.Mesh tubeGeometry, mat
                    scene.add tube


    projector = new THREE.Projector()
    document.addEventListener "mousedown", onDocumentMouseDown, false
    document.addEventListener "mousemove", onDocumentMouseMove, false
    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.02
        this.bouncingSpeed = 0.03
        this.scalingSpeed = 0.03
        this.showRay = false
        return this

    # UI
    gui = new dat.GUI()
    gui.add controls, "rotationSpeed", 0, 0.5
    gui.add controls, "bouncingSpeed", 0, 0.5
    gui.add controls, "scalingSpeed", 0, 0.5
    gui.add(controls, "showRay").onChange (e)->
        if tube
            scene.remove tube


    # 执行

    step = 0
    scalingStep = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        cube.rotation.x += controls.rotationSpeed
        cube.rotation.y += controls.rotationSpeed
        cube.rotation.z += controls.rotationSpeed

        step += controls.bouncingSpeed
        sphere.position.x = 20 + ( 10 * (Math.cos(step)))
        sphere.position.y = 2 + ( 10 * Math.abs(Math.sin(step)))


        scalingStep += controls.scalingSpeed
        scaleX = Math.abs(Math.sin(scalingStep / 4))
        scaleY = Math.abs(Math.cos(scalingStep / 5))
        scaleZ = Math.abs(Math.sin(scalingStep / 7))
        cylinder.scale.set scaleX, scaleY, scaleZ
        
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
