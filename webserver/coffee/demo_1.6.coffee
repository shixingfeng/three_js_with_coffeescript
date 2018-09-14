console.log "启用coffee demo_1.6"
init = ()->
    controls = new ()->
        this.rotationSpeed = 0.02
        this.bouncingSpeed = 0.03
    
    gui = new dat.GUI()
    gui.add controls, "rotationSpeed", 0, 0.5
    gui.add controls, "bouncingSpeed", 0, 0.5

    step = 0
    renderScene = ()->
        stats.update()
        cube.rotation.x += controls.rotationSpeed
        cube.rotation.y += controls.rotationSpeed
        cube.rotation.z += controls.rotationSpeed

        step += controls.bouncingSpeed
        sphere.position.x = 20 + (10 *(Math.cos(step)))
        sphere.position.y = 2 + (10 * Math.abs(Math.sin(step)))

        requestAnimationFrame renderScene
        renderer.render scene,camera

    initStats = ()->
        stats = new Stats()
        stats.setMode 0
        stats.domElement.style.position = "absolute"
        stats.domElement.style.left = "0px"
        stats.domElement.style.top = "0px"
        $("#Stats-output").append stats.domElement
        return stats

    stats = initStats()
    
    scene = new THREE.Scene()
    
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000

    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    


    axes = new THREE.AxisHelper 20
    scene.add axes


    

    planeGeometry = new THREE.PlaneGeometry 60, 20
    planeMaterial = new THREE.MeshLambertMaterial {color:0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial

    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 15
    plane.position.y = 0
    plane.position.z = 0
    plane.receiveShadow = true

    scene.add plane

    cubeGeometry = new THREE.BoxGeometry 4, 4, 4
    cubeMaterial = new THREE.MeshLambertMaterial {color:0xff0000}
    cube = new THREE.Mesh cubeGeometry, cubeMaterial

    cube.position.x = -4
    cube.position.y = 3
    cube.position.z = 0
    cube.castShadow = true

    scene.add cube

    sphereGeometry = new THREE.SphereGeometry 4, 20, 20
    sphereMaterial = new THREE.MeshLambertMaterial {color:0x7777ff}
    sphere = new THREE.Mesh sphereGeometry, sphereMaterial

    sphere.position.x = 20
    sphere.position.y = 4
    sphere.position.z = 2
    sphere.castShadow = true

    scene.add sphere

    camera.position.x = -30
    camera.position.y = 40
    camera.position.z = 30
    camera.lookAt scene.position


    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight
 

    $("#WebGL-output").append renderer.domElement
    renderScene()
    
window.onload = init()
