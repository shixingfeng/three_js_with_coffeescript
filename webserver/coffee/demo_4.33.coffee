console.log "demo_4.33  ShaderMaterial"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 30
    camera.position.y = 30
    camera.position.z = 30
    camera.lookAt new THREE.Vector3 0, 0, 0
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true



    # 创建材质
    createMaterial = (vertexShader,fragmentShader)->
        vertShader = document.getElementById(vertexShader).innerHTML
        fragShader = document.getElementById(fragmentShader).innerHTML
        attributes = {}

        uniforms = {
            time: {type: 'f', value: 0.2},
            scale: {type: 'f', value: 0.2},
            alpha: {type: 'f', value: 0.6},
            resolution: {type: "v2", value: new THREE.Vector2()}
        }

        uniforms.resolution.value.x = window.innerWidth
        uniforms.resolution.value.y = window.innerHeight

        meshMaterial = new THREE.ShaderMaterial {
            uniforms: uniforms,
            attributes: attributes,
            vertexShader: vertShader,
            fragmentShader: fragShader,
            transparent: true
        }
        return meshMaterial

    # 创建方块 添加材质
    cubeGeometry = new THREE.BoxGeometry 20, 20, 20

    meshMaterial1 = createMaterial "vertex-shader", "fragment-shader-1"
    meshMaterial2 = createMaterial "vertex-shader", "fragment-shader-2"
    meshMaterial3 = createMaterial "vertex-shader", "fragment-shader-3"
    meshMaterial4 = createMaterial "vertex-shader", "fragment-shader-4"
    meshMaterial5 = createMaterial "vertex-shader", "fragment-shader-5"
    meshMaterial6 = createMaterial "vertex-shader", "fragment-shader-6"

    material = new THREE.MeshFaceMaterial([meshMaterial1,
        meshMaterial2,
        meshMaterial3,
        meshMaterial4,
        meshMaterial5,
        meshMaterial6])
    cube = new THREE.Mesh cubeGeometry, material 
    scene.add cube

    # 光源
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, 10
    spotLight.castShadow = true
    scene.add spotLight
    

    step = 0
    # 控制台
    controls = new ()->
        this.rotationSpeed = 0.02
        this.bouncingSpeed = 0.03

        this.opacity = meshMaterial1.opacity
        this.transparent = meshMaterial1.transparent
        this.visible = meshMaterial1.visible
        this.side = "front"

        this.wireframe = meshMaterial1.wireframe
        this.wireframeLinewidth = meshMaterial1.wireframeLinewidth

        this.selectedMesh = "cube"

        this.shadow = "flat"
    
    # 实时渲染
    renderScene = ()->
        stats.update()

        cube.rotation.y = step += 0.01
        cube.rotation.x = step
        cube.rotation.z = step
        
        cube.material.materials.forEach (e)->
            e.uniforms.time.value += 0.01
        
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
