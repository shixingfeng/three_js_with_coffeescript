// Generated by CoffeeScript 2.3.1
(function() {
  var camera, hullMesh, init, onResize, renderer, scene, spGroup;

  console.log("demo_6.1  geometries - Convex Hull");

  camera = null;

  scene = null;

  renderer = null;

  spGroup = null;

  hullMesh = null;

  init = function() {
    var controls, createMesh, generatePoints, gui, initStats, renderScene, stats, step, webGLRenderer;
    // 场景
    scene = new THREE.Scene();
    
    // 摄像机
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.x = -30;
    camera.position.y = 40;
    camera.position.z = 50;
    camera.lookAt(new THREE.Vector3(10, 0, 0));
    
    // 渲染器
    webGLRenderer = new THREE.WebGLRenderer();
    webGLRenderer.setClearColor(new THREE.Color(0xEEEEEE, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMapEnabled = true;
    renderer = webGLRenderer;
    //材质
    createMesh = function(geom) {
      var mesh, meshMaterial, wireFrameMat;
      meshMaterial = new THREE.MeshBasicMaterial({
        color: 0x00ff00,
        transparent: true,
        opacity: 0.2
      });
      meshMaterial.side = THREE.DoubleSide;
      wireFrameMat = new THREE.MeshBasicMaterial();
      wireFrameMat.wireframe = true;
      mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial, wireFrameMat]);
      return mesh;
    };
    
    // 生成点
    generatePoints = function() {
      var hullGeometry, i, j, material, points, randomX, randomY, randomZ;
      // 随机三个数值的点
      points = [];
      for (i = j = 0; j <= 19; i = ++j) {
        randomX = -15 + Math.round(Math.random() * 30);
        randomY = -15 + Math.round(Math.random() * 30);
        randomZ = -15 + Math.round(Math.random() * 30);
        points.push(new THREE.Vector3(randomX, randomY, randomZ));
      }
      spGroup = new THREE.Object3D();
      material = new THREE.MeshBasicMaterial({
        color: 0xff0000,
        transparent: false
      });
      
      // 为每个点指定材质大小以及位置
      points.forEach(function(point) {
        var spGeom, spMesh;
        spGeom = new THREE.SphereGeometry(0.2);
        spMesh = new THREE.Mesh(spGeom, material);
        spMesh.position.copy(point);
        return spGroup.add(spMesh);
      });
      scene.add(spGroup);
      // 将点连接
      hullGeometry = new THREE.ConvexGeometry(points);
      hullMesh = createMesh(hullGeometry);
      return scene.add(hullMesh);
    };
    // 执行生成点函数
    generatePoints();
    
    // 控制条
    controls = new function() {
      this.redraw = function() {
        scene.remove(spGroup);
        scene.remove(hullMesh);
        return generatePoints();
      };
      return this;
    };
    gui = new dat.GUI();
    gui.add(controls, "redraw");
    step = 0;
    // 实时渲染
    renderScene = function() {
      stats.update();
      spGroup.rotation.y = step;
      hullMesh.rotation.y = step += 0.01;
      requestAnimationFrame(renderScene);
      return renderer.render(scene, camera);
    };
    
    // 状态条
    initStats = function() {
      var stats;
      stats = new Stats();
      stats.setMode(0);
      stats.domElement.style.position = "absolute";
      stats.domElement.style.left = "0px";
      stats.domElement.style.top = "0px";
      $("#Stats-output").append(stats.domElement);
      return stats;
    };
    stats = initStats();
    $("#WebGL-output").append(renderer.domElement);
    return renderScene();
  };

  
  //屏幕适配
  onResize = function() {
    console.log("onResize");
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    return renderer.setSize(window.innerWidth, window.innerHeight);
  };

  window.onload = init();

  window.addEventListener("resize", onResize, false);

}).call(this);
