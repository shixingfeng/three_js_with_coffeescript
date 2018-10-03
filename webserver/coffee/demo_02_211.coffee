console.log "demo_02_211 标准几何体"
console.log "展示threejs中标准几何体"
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
    camera.position.x = -50
    camera.position.y = 30
    camera.position.z = 20
    camera.lookAt new THREE.Vector3 -10, 0, 0
    
    # 渲染器
    renderer = new THREE.WebGLRenderer()
    renderer.setClearColor new THREE.Color 0xEEEEEE, 1.0
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true
    
    # 物体材质和几何
    planeGeometry = new THREE.PlaneGeometry 60, 40, 1, 1
    planeMaterial = new THREE.MeshLambertMaterial {color:0xffffff}
    plane = new THREE.Mesh planeGeometry, planeMaterial
    plane.receiveShadow = true
    plane.rotation.x = -0.5 * Math.PI
    plane.position.x = 0
    plane.position.y = 0
    plane.position.z = 0
    scene.add plane
    
    # 灯光 类型、位置、阴影并加入场景
    ambientLight = new THREE.AmbientLight 0x090909
    scene.add ambientLight
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 40, 50
    spotLight.castShadow = true
    scene.add spotLight

    # # 方法区
    addGeometries = (scene)->
        geoms = []
        geoms.push new THREE.CylinderGeometry 1, 4, 4
        # 方块
        geoms.push new THREE.BoxGeometry 2, 2, 2

        # 圆
        geoms.push new THREE.SphereGeometry 2

        # 二十面体
        geoms.push new THREE.IcosahedronGeometry 4

        # 没有凹痕的形状，使用点来绘制，例如一个方块
        points = [
            new THREE.Vector3(2, 2, 2),
            new THREE.Vector3(2, 2, -2),
            new THREE.Vector3(-2, 2, -2),
            new THREE.Vector3(-2, 2, 2),
            new THREE.Vector3(2, -2, 2),
            new THREE.Vector3(2, -2, -2),
            new THREE.Vector3(-2, -2, -2),
            new THREE.Vector3(-2, -2, 2)]
        geoms.push new THREE.ConvexGeometry points

        # 长条形
        pts = []
        detail = .1
        radius = 3
        for angle in [0.0..Math.PI] by angle += detail
            pts.push new THREE.Vector3 Math.cos(angle) * radius, 0, Math.sin(angle) * radius
        geoms.push new THREE.LatheGeometry pts, 12

        # 八面体
        geoms.push new THREE.OctahedronGeometry 3

        # 用提供参数的方法创建物体
        geoms.push new THREE.ParametricGeometry THREE.ParametricGeometries.mobius3d, 20, 10

        #四面体
        geoms.push new THREE.TetrahedronGeometry 3

        # 花托
        geoms.push new THREE.TorusGeometry 3, 1, 10, 10

        # 花结
        geoms.push new THREE.TorusKnotGeometry 3, 0.5, 50, 20

        # 设置物体参数，加入场景中
        j = 0
        for i in [0..geoms.length-1]
            cubeMaterial = new THREE.MeshLambertMaterial {
                wireframe: true,
                color: Math.random() * 0xffffff}

            materials = [
                new THREE.MeshLambertMaterial({color: Math.random() * 0xffffff, shading: THREE.FlatShading}),
                new THREE.MeshBasicMaterial({color: 0x000000, wireframe: true})]

            mesh = THREE.SceneUtils.createMultiMaterialObject geoms[i], materials
            mesh.traverse (e)->
                e.castShadow = true

            mesh.position.x = -24 + ((i % 4) * 12)
            mesh.position.y = 4
            mesh.position.z = -8 + (j * 12)
            if (i + 1) % 4 == 0
                j++
            scene.add mesh
    
    # 往场景添加材质
    addGeometries scene

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
        

        requestAnimationFrame renderScene
        renderer.render scene,camera
        $("#WebGL-output").append renderer.domElement
    
    # 执行帧数显示(在renderScene中执行更新)、实时渲染、屏幕监听
    stats = initStats()
    renderScene()
    window.addEventListener "resize", onResize, false


# 浏览器加载完成时，执行函数init()
window.onload = init