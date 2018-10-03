console.log "demo_10.15 dynamic envmap"
camera = null
cubeCamera = null
scene = null
renderer = null
sphere = null
orbit = null
control = null


# 方法区
addControls = (controlObject)->
    gui  = new dat.GUI()
    gui.add controlObject, "rotationSpeed", -0.1, 0.1

createCubeMap = ()->
    path = "/static/pictures/assets/textures/cubemap/parliament/"
    format = '.jpg'
    urls = [
        path + 'posx' + format, path + 'negx' + format,
        path + 'posy' + format, path + 'negy' + format,
        path + 'posz' + format, path + 'negz' + format]

    textureCube = THREE.ImageUtils.loadTextureCube urls, new THREE.CubeReflectionMapping()
    return textureCube

init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 10000
    orbit = new THREE.OrbitControls camera
    
    camera.position.x = 0
    camera.position.y = 5
    camera.position.z = 33
    camera.lookAt scene.position
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    renderer = webGLRenderer
    
    
    textureCube = createCubeMap()
    textureCube.format = THREE.RGBFormat

    shader = THREE.ShaderLib["cube"]
    shader.uniforms["tCube"].value = textureCube

    material = new THREE.ShaderMaterial {
        fragmentShader: shader.fragmentShader,
        vertexShader: shader.vertexShader,
        uniforms: shader.uniforms,
        depthWrite: false,
        side: THREE.DoubleSide}

    skybox = new THREE.Mesh new THREE.BoxGeometry(10000, 10000, 10000), material
    scene.add skybox

    cubeCamera = new THREE.CubeCamera 0.1, 20000, 256
    scene.add cubeCamera

    sphereGeometry = new THREE.SphereGeometry 4, 15, 15
    boxGeometry = new THREE.BoxGeometry 5, 5, 5
    cylinderGeometry = new THREE.CylinderGeometry 2, 4, 10, 20, 20, false

    dynamicEnvMaterial = new THREE.MeshBasicMaterial {envMap: cubeCamera.renderTarget, side: THREE.DoubleSide}
    envMaterial = new THREE.MeshBasicMaterial {envMap: textureCube, side: THREE.DoubleSide}

    sphere = new THREE.Mesh sphereGeometry, dynamicEnvMaterial
    sphere.name = "sphere"
    scene.add sphere

    cylinder = new THREE.Mesh cylinderGeometry, envMaterial
    cylinder.name = "cylinder"
    scene.add cylinder
    cylinder.position.set 10, 0, 0

    cube = new THREE.Mesh boxGeometry, envMaterial
    cube.name = "cube"
    scene.add cube
    cube.position.set -10, 0, 0

    # 控制条
    control = new ()->
        this.rotationSpeed = 0.005
        this.scale = 1
        return this
    
    #执行方法 
    addControls control
    

    step = 0
    # 实时渲染
    renderScene = ()->
        orbit.update()
        stats.update()
        
        sphere.visible = false
        cubeCamera.updateCubeMap renderer, scene
        sphere.visible = true

        renderer.render scene, camera
        scene.getObjectByName("cube").rotation.x += control.rotationSpeed
        scene.getObjectByName("cube").rotation.y += control.rotationSpeed
        scene.getObjectByName("cylinder").rotation.x += control.rotationSpeed
        

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
