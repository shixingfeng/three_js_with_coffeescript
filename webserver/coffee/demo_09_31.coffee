console.log "demo9.31 Working with morph targets"
camera = null
scene = null
renderer = null
mesh = null
meshAnim = null
currentMesh = null
step = 0

init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 2000    
    camera.position.x = 250
    camera.position.y = 250
    camera.position.z = 350
    camera.lookAt new THREE.Vector3(100, 50, 0)


    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight    
    webGLRenderer.shadowMapEnabled = true
    
    renderer = webGLRenderer


    # 灯光
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 300, 200, 300
    spotLight.intensity = 1
    scene.add spotLight

    
    #方法区域
    showFrame = (e)->
        scene.remove currentMesh
        scene.add frames[e]
        currentMesh = frames[e]
        console.log currentMesh

    morphColorsToFaceColors = (geometry)->
        if geometry.morphColors and geometry.morphColors.length
            colorMap = geometry.morphColors[0]
            for i in  [0..colorMap.colors.length-1]
                geometry.faces[i].color = colorMap.colors[i]
                geometry.faces[i].color.offsetHSL 0, 0.3, 0

    # 引入材质
    frames = []
    clock = new THREE.Clock()
    loader = new THREE.JSONLoader()
    loader.load("/static/pictures/assets/models/horse.js", (geometry, mat)->
        mat = new THREE.MeshLambertMaterial {morphTargets: true,vertexColors: THREE.FaceColors}
        mat2 = new THREE.MeshLambertMaterial {color: 0xffffff, vertexColors: THREE.FaceColors}
        
        mesh = new THREE.Mesh(geometry, mat);
        mesh.position.x = -100
        
        frames.push mesh
        currentMesh = mesh
        morphColorsToFaceColors geometry
        
        mesh.geometry.morphTargets.forEach (e)->
            geom = new THREE.Geometry()
            geom.vertices = e.vertices
            geom.faces = geometry.faces

            morpMesh = new THREE.Mesh geom, mat2
            frames.push(morpMesh)
            morpMesh.position.x = -100

            geometry.computeVertexNormals()
            geometry.computeFaceNormals()
            geometry.computeMorphNormals()

            meshAnim = new THREE.MorphAnimMesh geometry, mat
            meshAnim.duration = 1000
            meshAnim.position.x = 200
            meshAnim.position.z = 0

            scene.add meshAnim
            showFrame 0
        ,"/static/pictures/assets/models")



    # 控制台
    controls = new ()->
        this.keyframe = 0


    # UI
    gui = new dat.GUI()
    gui.add(controls, "keyframe", 0, 15).step(1).onChange (e)->
        showFrame e

    # 执行

    # 实时渲染
    renderScene = ()->
        stats.update()
    
        delta = clock.getDelta()
        webGLRenderer.clear()

        if meshAnim
            meshAnim.updateAnimation delta * 1000
            meshAnim.rotation.y += 0.01

        
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
