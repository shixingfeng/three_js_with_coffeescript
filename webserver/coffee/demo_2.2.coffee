console.log "启用coffee demo_2.2"
camera = null
scene = null
renderer = null
controls = null
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

    # 创建一个几何体
    vertices = [
        new THREE.Vector3(1, 3, 1),
        new THREE.Vector3(1, 3, -1),
        new THREE.Vector3(1, -1, 1),
        new THREE.Vector3(1, -1, -1),
        new THREE.Vector3(-1, 3, -1),
        new THREE.Vector3(-1, 3, 1),
        new THREE.Vector3(-1, -1, -1),
        new THREE.Vector3(-1, -1, 1)
    ]

    faces = [
        new THREE.Face3(0, 2, 1),
        new THREE.Face3(2, 3, 1),
        new THREE.Face3(4, 6, 5),
        new THREE.Face3(6, 7, 5),
        new THREE.Face3(4, 5, 1),
        new THREE.Face3(5, 0, 1),
        new THREE.Face3(7, 6, 2),
        new THREE.Face3(6, 3, 2),
        new THREE.Face3(5, 7, 0),
        new THREE.Face3(7, 2, 0),
        new THREE.Face3(1, 3, 4),
        new THREE.Face3(3, 6, 4),
    ]
    geom = new THREE.Geometry()
    geom.vertices = vertices
    geom.faces = faces
    geom.computeFaceNormals()


    #材质和多元材质的选择
    materials =[
        new THREE.MeshLambertMaterial {opacity: 0.6, color: 0x44ff44, transparent: true},
        new THREE.MeshBasicMaterial {color: 0x000000, wireframe: true}

    ]

    mesh = THREE.SceneUtils.createMultiMaterialObject geom, materials
    mesh.children.forEach (e) ->
        e.castShadow = true
    scene.add(mesh)

    # 控制台
    addControl = (x, y, z)->
        controls = new ()->
            this.x = x
            this.y = y
            this.z = z
            return
        return controls
    
    controlPoints = [];
    controlPoints.push addControl(3, 5, 3)
    controlPoints.push addControl(3, 5, 0)
    controlPoints.push addControl(3, 0, 3)
    controlPoints.push addControl(3, 0, 0)
    controlPoints.push addControl(0, 5, 0)
    controlPoints.push addControl(0, 5, 3)
    controlPoints.push addControl(0, 0, 0)
    controlPoints.push addControl(0, 0, 3)

    gui = new dat.GUI()
    # clone一个物体
    gui.add new () ->
            this.clone = () ->
                clonedGeom = mesh.children[0].geometry.clone()
                materials = [
                    new THREE.MeshLambertMaterial {opacity: 0.6, color: 0xff44ff, transparent: true},
                    new THREE.MeshBasicMaterial {color: 0x000000, wireframe: true}
                ]

                mesh2 = THREE.SceneUtils.createMultiMaterialObject clonedGeom, materials
                mesh2.children.forEach (e)->
                    e.castShadow = true
                mesh2.translateX(5)
                mesh2.translateZ(5)
                mesh2.name = "clone"
                scene.remove scene.getChildByName("clone")
                scene.add(mesh2)
            return this
        ,"clone"
    
    for i in [0..7]
        f1 = gui.addFolder "Vertices" + (i + 1)
        f1.add controlPoints[i], "x", -10, 10
        f1.add controlPoints[i], "y", -10, 10
        f1.add controlPoints[i], "z", -10, 10

    
    # 实时渲染
    renderScene = ()->
        stats.update()

        vertices = [];
        for i in [0..7]
            a = new THREE.Vector3(controlPoints[i].x, controlPoints[i].y, controlPoints[i].z)
            vertices.push a

        mesh.children.forEach (e) ->
            e.geometry.vertices = vertices
            e.geometry.verticesNeedUpdate = true
            e.geometry.computeFaceNormals()
            
        
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
# 监听方法二
# $(window).on "resize",()->
#     onResize()