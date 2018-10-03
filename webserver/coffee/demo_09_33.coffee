console.log "demo9.33 Load blender model"
camera = null
scene = null
renderer = null
mesh = null
step = 0

init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000    
    camera.position.x = 0
    camera.position.y = 0
    camera.position.z = 4
    camera.lookAt new THREE.Vector3(0,0,0)


    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight    
    webGLRenderer.shadowMapEnabled = true    
    renderer = webGLRenderer

    # 灯光
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight 

    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set 0, 50, 30
    spotLight.intensity = 2
    scene.add spotLight


    # 方法区
    onUpdate = ()->
        pos = this.pos
        console.log mesh.skeleton

        # 转动手指
        mesh.skeleton.bones[5].rotation.set 0, 0, pos
        mesh.skeleton.bones[6].rotation.set 0, 0, pos
        mesh.skeleton.bones[10].rotation.set 0, 0, pos
        mesh.skeleton.bones[11].rotation.set 0, 0, pos
        mesh.skeleton.bones[15].rotation.set 0, 0, pos
        mesh.skeleton.bones[16].rotation.set 0, 0, pos
        mesh.skeleton.bones[20].rotation.set 0, 0, pos
        mesh.skeleton.bones[21].rotation.set 0, 0, pos

        # 转动手腕
        mesh.skeleton.bones[1].rotation.set pos, 0, 0

    # 渐变
    tween = new TWEEN.Tween({pos: -1})
                .to({pos: 0}, 3000)
                .easing(TWEEN.Easing.Cubic.InOut)
                .yoyo(true)
                .repeat(Infinity)
                .onUpdate(onUpdate)


    # 载入纹理
    clock = new THREE.Clock()
    loader = new THREE.JSONLoader()
    loader.load("/static/pictures/assets/models/hand-1.js", (geometry, mat)->
        mat = new THREE.MeshLambertMaterial {color: 0xF0C8C9, skinning: true}
        mesh = new THREE.SkinnedMesh geometry, mat
        mesh.rotation.x = 0.5 * Math.PI
        mesh.rotation.z = 0.7 * Math.PI
        scene.add mesh
        tween.start()
    ,"/static/pictures/assets/models")

    # 控制台
    controls = new ()->
        

    # UI
    gui = new dat.GUI()
    

    # 实时渲染
    renderScene = ()->
        stats.update()
        TWEEN.update()
        
        delta = clock.getDelta()

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
