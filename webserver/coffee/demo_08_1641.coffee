console.log "demo_8.4  Load pdb model"
camera = null
scene = null
renderer = null
mesh = null
model = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = 6
    camera.position.y = 6
    camera.position.z = 6
    camera.lookAt new THREE.Vector3 0, 0, 0
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0x000, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true
    renderer = webGLRenderer

    #灯光
    dir1 = new THREE.DirectionalLight 0.4
    dir1.position.set -30, 30, -30
    scene.add dir1

    dir2 = new THREE.DirectionalLight 0.4
    dir2.position.set -30, 30, 30
    scene.add dir2

    dir3 = new THREE.DirectionalLight 0.4
    dir3.position.set 30, 30, -30
    scene.add dir3

    # 阴影
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 30, 30, 30
    scene.add spotLight


    # 控制条
    controls = new ()->
        
    # UI呈现
    gui = new dat.GUI()
    loader = new THREE.PDBLoader()
    group = new THREE.Object3D()
    add_uri = "/static/pictures/assets/models/"
    loader.load add_uri+"aspirin.pdb", (geometry, geometryBonds)->
        i = 0
        geometry.vertices.forEach (position)->
            sphere = new THREE.SphereGeometry 0.2
            material = new THREE.MeshPhongMaterial {color: geometry.colors[i++]}
            mesh = new THREE.Mesh sphere, material
            mesh.position.copy position
            group.add mesh
        for j in [0..geometryBonds.vertices.length-1] by 2
            path = new THREE.SplineCurve3 [geometryBonds.vertices[j], geometryBonds.vertices[j + 1]]
            tube = new THREE.TubeGeometry path, 1, 0.04
            material = new THREE.MeshPhongMaterial {color: 0xcccccc}
            mesh = new THREE.Mesh tube, material
            group.add mesh
        scene.add group
    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        if group
            group.rotation.y +=0.006
            group.rotation.x +=0.006            

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
