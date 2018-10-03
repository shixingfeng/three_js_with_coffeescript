console.log "demo9.43 animation from md2"
camera = null
scene = null
renderer = null
mesh = null
step = 0
meshAnim = null

init = ()->
    # 场景
    scene = new THREE.Scene()
    
    # 摄像机
    camera = new THREE.PerspectiveCamera 45, window.innerWidth/window.innerHeight, 0.1, 1000    
    camera.position.x = -50
    camera.position.y = 40
    camera.position.z = 60
    camera.lookAt new THREE.Vector3(0,0,0)


    # 渲染器
    webGLRenderer = new THREE.WebGLRenderer()
    webGLRenderer.setClearColor new THREE.Color(0xEEEEEE, 1.0)
    webGLRenderer.setSize window.innerWidth, window.innerHeight    
    webGLRenderer.shadowMapEnabled = true    
    renderer = webGLRenderer

    # 灯光
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -50, 70, 60
    spotLight.intensity = 1
    scene.add spotLight


    # 载入纹理,动画
    clock = new THREE.Clock()
    loader = new THREE.JSONLoader()
    loader.load "/static/pictures/assets/models/ogre/ogro.js", (geometry, mat, Color)->    
        geometry.computeMorphNormals()
        mat = new THREE.MeshLambertMaterial {
            map: THREE.ImageUtils.loadTexture("/static/pictures/assets/models/ogre/skins/skin.jpg"),
            morphTargets: true,
            morphNormals: true,
            Color:0x4e0f0a}
        mesh = new THREE.MorphAnimMesh geometry, mat
        mesh.rotation.y = 0.7
        
        mesh.parseAnimations()

        animLabels = []
        for key in mesh.geometry.animations
            if key == "length" or not mesh.geometry.animations.hasOwnProperty(key)
                continue
            animLabels.push key

        gui.add(controls, "animations", animLabels).onChange (e)->
            mesh.playAnimation controls.animations, controls.fps
        gui.add(controls, "fps", 1, 20).step(1).onChange (e)->
            mesh.playAnimation controls.animations, controls.fps
        mesh.playAnimation "crattack", 10
        scene.add mesh
    

    # 控制台
    controls = new ()->
        this.animations = "crattack"
        this.fps = 10

        

    # UI
    gui = new dat.GUI()

    # 实时渲染
    renderScene = ()->
        stats.update()        
        
        delta = clock.getDelta()
        if mesh
            mesh.updateAnimation delta * 1000        
        

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
