console.log "demo_6.34  Parametric geometries"
camera = null
scene = null
renderer = null
v = null
init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000
    camera.position.x = -30
    camera.position.y = 50
    camera.position.z = 50
    camera.lookAt new THREE.Vector3 10, -20, 0
    
    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight
    webGLRenderer.shadowMapEnabled = true

    renderer = webGLRenderer

    #材质
    createMesh = (geom)->
        geom.applyMatrix new THREE.Matrix4().makeTranslation(-25, 0, -25)
        meshMaterial = new THREE.MeshPhongMaterial {specular: 0xaaaafff, color: 0x3399ff, shininess: 40, metal: true}
        meshMaterial.side = THREE.DoubleSide
        plane = THREE.SceneUtils.createMultiMaterialObject geom, [meshMaterial]
        return plane
   

    klein = (u, v)->
        u *= Math.PI
        v *= 2 * Math.PI
        u = u * 2
        if u < Math.PI
            x = 3 * Math.cos(u) * (1 + Math.sin(u)) + (2 * (1 - Math.cos(u) / 2)) * Math.cos(u) * Math.cos(v)
            z = -8 * Math.sin(u) - 2 * (1 - Math.cos(u) / 2) * Math.sin(u) * Math.cos(v)
        else
            x = 3 * Math.cos(u) * (1 + Math.sin(u)) + (2 * (1 - Math.cos(u) / 2)) * Math.cos(v + Math.PI)
            z = -8 * Math.sin(u)
        y = -2 * (1 - Math.cos(u) / 2) * Math.sin(v)
        return new THREE.Vector3 x, y, z

    radialWave = (u, v)->
        r = 50
        x = Math.sin(u) * r
        z = Math.sin(v / 2) * 2 * r
        y = (Math.sin(u * 4 * Math.PI) + Math.cos(v * 2 * Math.PI)) * 2.8
        return new THREE.Vector3 x, y, z

    mesh = createMesh new THREE.ParametricGeometry(radialWave, 120, 120, false)
    scene.add mesh


    # 灯光
    spotLight = new THREE.DirectionalLight()
    spotLight.position = new THREE.Vector3 -20, 250, -50
    spotLight.target.position.x = 30
    spotLight.target.position.y = -40
    spotLight.target.position.z = -20
    spotLight.intensity = 0.3
    scene.add spotLight
    # 控制条
    controls = new ()->
    
    gui = new dat.GUI()



    step = 0
    # 实时渲染
    renderScene = ()->
        stats.update()
        
        mesh.rotation.x = step
        mesh.rotation.y = step += 0.01

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
