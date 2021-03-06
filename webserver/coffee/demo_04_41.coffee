console.log "demo_4.41  lineBasicMaterial"
camera = null
scene = null
renderer = null
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
    renderer.setClearColor new THREE.Color(0x000000, 1.0)
    renderer.setSize window.innerWidth, window.innerHeight
    renderer.shadowMapEnabled = true


    # 光源
    ambientLight = new THREE.AmbientLight 0x0c0c0c
    scene.add ambientLight
    spotLight = new THREE.SpotLight 0xffffff
    spotLight.position.set -40, 60, -10
    spotLight.castShadow = true
    scene.add spotLight
    
    gosper = (a, b)->
        turtle = [0, 0, 0]
        points = []
        count = 0
        rt = (x)->
            turtle[2] += x

        lt = (x)->
            turtle[2] -= x

        fd = (dist)->
            points.push {x: turtle[0], y: turtle[1], z: Math.sin(count) * 5}
            dir = turtle[2] * (Math.PI / 180)
            turtle[0] += Math.cos(dir) * dist
            turtle[1] += Math.sin(dir) * dist
            points.push({x: turtle[0], y: turtle[1], z: Math.sin(count) * 5})

        rg = (st, ln, turtle)->
            st--
            ln = ln / 2.6457
            if st > 0
                rg st, ln, turtle
                rt 60
                gl st, ln, turtle
                rt 120
                gl st, ln, turtle
                lt 60
                rg st, ln, turtle
                lt 120
                rg st, ln, turtle
                rg st, ln, turtle
                lt 60
                gl st, ln, turtle
                rt 60
            if st == 0
                fd ln
                rt 60
                fd ln
                rt 120
                fd ln
                lt 60
                fd ln
                lt 120
                fd ln
                fd ln
                lt 60
                fd ln
                rt 60


        gl = (st, ln, turtle)->
            st--
            ln = ln / 2.6457
            if st > 0
                lt 60
                rg st, ln, turtle
                rt 60
                gl st, ln, turtle
                gl st, ln, turtle
                rt 120
                gl st, ln, turtle
                rt 60
                rg st, ln, turtle
                lt 120
                rg st, ln, turtle
                lt 60
                gl st, ln, turtle
            if st == 0
                lt 60
                fd ln
                rt 60
                fd ln
                fd ln
                rt 120
                fd ln
                rt 60
                fd ln
                lt 120
                fd ln
                lt 60
                fd ln
        rg a, b, turtle
        
        return points       
            
    # 创建几何体材质
    points = gosper 4, 60
    lines = new THREE.Geometry()
    colors = []
    i = 0
    points.forEach (e)->        
        lines.vertices.push new THREE.Vector3(e.x, e.z, e.y)
        colors[i] = new THREE.Color 0xffffff
        colors[i].setHSL e.x / 100 + 0.5, (  e.y * 20 ) / 300, 0.8
        i++

    lines.colors = colors
    
    material = new THREE.LineBasicMaterial {
        opacity: 1.0,
        linewidth: 1,
        vertexColors: THREE.VertexColors
    }

    line = new THREE.Line lines, material
    line.position.set 25, -30, -60
    scene.add line
    

    step = 0
    
    # 实时渲染
    renderScene = ()->
        stats.update()
    
        line.rotation.z = step += 0.01

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
