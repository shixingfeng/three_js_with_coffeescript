console.log "demo_10.14 LightMap"
camera = null
scene = null
renderer = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -20
    camera.position.y = 20
    camera.position.z = 30
    camera.lookAt new THREE.Vector3(0, 0, 0)
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer
    

  
    # 地面及材质
    groundGeom = new THREE.PlaneGeometry 95, 95, 1, 1
    lm = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/lightmap/lm-1.png"
    wood = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/floor-wood.jpg"
    groundMaterial = new THREE.MeshBasicMaterial {color: 0x777777,lightMap: lm,map: wood}
    groundGeom.faceVertexUvs[1] = groundGeom.faceVertexUvs[0]
    groundMesh = new THREE.Mesh groundGeom, groundMaterial
    groundMesh.rotation.x = -Math.PI / 2
    groundMesh.position.y = 0
    scene.add groundMesh

    # 方块
    cubeGeometry = new THREE.BoxGeometry 12, 12, 12
    cubeGeometry2 = new THREE.BoxGeometry 6, 6, 6

    meshMaterial = new THREE.MeshBasicMaterial()
    meshMaterial.map = THREE.ImageUtils.loadTexture "/static/pictures/assets/textures/general/stone.jpg"

    cube = new THREE.Mesh cubeGeometry, meshMaterial
    cube2 = new THREE.Mesh cubeGeometry2, meshMaterial
    cube.position.set 0.9, 6, -12
    cube2.position.set -13.2, 3, -6

    scene.add cube
    scene.add cube2
    
    #灯光
    ambiLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambiLight

    # 控制条
    controls = new ()->
        
   
    # UI呈现
    gui = new dat.GUI()
    
    step = 0
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
