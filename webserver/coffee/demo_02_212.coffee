console.log "demo_02_212 修改几何顶点"
console.log "computeFaceNormals绘制图形,控制8个顶点在xyz三轴上变形,clone方法复制图像"
camera = null
renderer = null

# 屏幕适配
onResize = ()->
    console.log "onResize"
    camera.aspect = window.innerWidth / window.innerHeight
    camera.updateProjectionMatrix()
    renderer.setSize window.innerWidth, window.innerHeight

init = ()->
    # 场景
    scene = new THREE.Scene()

    # 摄像机参数
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
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight

    # 八个顶点，12个面的长方体,用computeFaceNormals绘制出物体
    vertices = [
        new THREE.Vector3(1, 3, 1),
        new THREE.Vector3(1, 3, -1),
        new THREE.Vector3(1, -1, 1),
        new THREE.Vector3(1, -1, -1),
        new THREE.Vector3(-1, 3, -1),
        new THREE.Vector3(-1, 3, 1),
        new THREE.Vector3(-1, -1, -1),
        new THREE.Vector3(-1, -1, 1)]
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
        new THREE.Face3(3, 6, 4),]
    geom = new THREE.Geometry()
    geom.vertices = vertices
    geom.faces = faces
    geom.computeFaceNormals()


    #材质和多元材质的选择
    materials =[
        new THREE.MeshLambertMaterial {
            opacity: 0.6,
            color: 0x44ff44,
            transparent: true},
        new THREE.MeshBasicMaterial {
            color: 0x000000,
            wireframe: true}]
    mesh = THREE.SceneUtils.createMultiMaterialObject geom, materials
    mesh.children.forEach (e) ->
        e.castShadow = true
    scene.add mesh

    # 控制台、复制方法
    addControl = (x, y, z)->
        controls = new ()->
            this.x = x
            this.y = y
            this.z = z
        return controls
    
    controlPoints = []
    controlPoints.push addControl 3, 5, 3
    controlPoints.push addControl 3, 5, 0
    controlPoints.push addControl 3, 0, 3
    controlPoints.push addControl 3, 0, 0
    controlPoints.push addControl 0, 5, 0
    controlPoints.push addControl 0, 5, 3
    controlPoints.push addControl 0, 0, 0
    controlPoints.push addControl 0, 0, 3

    gui = new dat.GUI()
    gui.add new () ->
        this.clone = () ->
            clonedGeom = mesh.children[0].geometry.clone()
            materials = [
                new THREE.MeshLambertMaterial {
                    opacity: 0.6,
                    color: 0xff44ff,
                    transparent: true},
                new THREE.MeshBasicMaterial {
                    color: 0x000000,
                    wireframe: true}]

            mesh2 = THREE.SceneUtils.createMultiMaterialObject clonedGeom, materials
            mesh2.children.forEach (e)->
                e.castShadow = true
            mesh2.translateX 5
            mesh2.translateZ 5
            mesh2.name = "clone"
            scene.remove scene.getChildByName "clone"
            scene.add mesh2
        return this
    ,"clone"
    
    for i in [0..7]
        f1 = gui.addFolder "Vertices" + (i + 1)
        f1.add controlPoints[i], "x", -10, 10
        f1.add controlPoints[i], "y", -10, 10
        f1.add controlPoints[i], "z", -10, 10

    
    #帧数显示
    initStats = ()->
        stats = new Stats()
        stats.setMode 0
        stats.domElement.style.position = "absolute"
        stats.domElement.style.left = "0px"
        stats.domElement.style.top = "0px"
        $("#Stats-output").append stats.domElement
        return stats

    # 帧数更新、物体控制参数、调用渲染本身,将结果输出到屏幕
    renderScene = ()->
        stats.update()

        vertices = []
        for i in [0..7]
            a = new THREE.Vector3 controlPoints[i].x, controlPoints[i].y, controlPoints[i].z
            vertices.push a

        mesh.children.forEach (e) ->
            e.geometry.vertices = vertices
            e.geometry.verticesNeedUpdate = true
            e.geometry.computeFaceNormals()
            
        
        requestAnimationFrame renderScene
        renderer.render scene,camera
        $("#WebGL-output").append renderer.domElement
    
    # 执行帧数显示(在renderScene中执行更新)、实时渲染、屏幕监听
    stats = initStats()
    renderScene()
    window.addEventListener "resize", onResize, false



# 浏览器加载完成时，执行函数init()
window.onload = init