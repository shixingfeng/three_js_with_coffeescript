// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, onResize, renderer, scene;

  console.log("demo_6.31  geometries - Extrude");

  camera = null;

  scene = null;

  renderer = null;

  init = function() {
    var controls, createMesh, drawShape, gui, initStats, renderScene, shape, stats, step, webGLRenderer;
    // 场景
    scene = new THREE.Scene();
    
    // 摄像机
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.x = -20;
    camera.position.y = 60;
    camera.position.z = 60;
    camera.lookAt(new THREE.Vector3(20, 20, 0));
    
    // 渲染器
    webGLRenderer = new THREE.WebGLRenderer();
    webGLRenderer.setClearColor(new THREE.Color(0xEEEEEE, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMapEnabled = true;
    renderer = webGLRenderer;
    //材质
    createMesh = function(geom) {
      var mesh, meshMaterial, wireFrameMat;
      geom.applyMatrix(new THREE.Matrix4().makeTranslation(-20, 0, 0));
      meshMaterial = new THREE.MeshNormalMaterial({
        shading: THREE.FlatShading,
        transparent: true,
        opacity: 0.7
      });
      wireFrameMat = new THREE.MeshBasicMaterial();
      wireFrameMat.wireframe = true;
      mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial]);
      return mesh;
    };
    
    // 画图
    drawShape = function() {
      var hole1, hole2, hole3, shape;
      shape = new THREE.Shape();
      shape.moveTo(10, 10);
      shape.lineTo(10, 40);
      shape.bezierCurveTo(15, 25, 25, 25, 30, 40);
      shape.splineThru([new THREE.Vector2(32, 30), new THREE.Vector2(28, 20), new THREE.Vector2(30, 10)]);
      shape.quadraticCurveTo(20, 15, 10, 10);
      hole1 = new THREE.Path();
      hole1.absellipse(16, 24, 2, 3, 0, Math.PI * 2, true);
      shape.holes.push(hole1);
      hole2 = new THREE.Path();
      hole2.absellipse(23, 24, 2, 3, 0, Math.PI * 2, true);
      shape.holes.push(hole2);
      hole3 = new THREE.Path();
      hole3.absarc(20, 16, 2, 0, Math.PI, true);
      shape.holes.push(hole3);
      return shape;
    };
    //执行画图 加入场景
    shape = createMesh(new THREE.ShapeGeometry(drawShape()));
    scene.add(shape);
    // 控制条
    controls = new function() {
      this.amount = 2;
      this.bevelThickness = 2;
      this.bevelSize = 0.5;
      this.bevelEnabled = true;
      this.bevelSegments = 3;
      this.bevelEnabled = true;
      this.curveSegments = 12;
      this.steps = 1;
      this.asGeom = function() {
        var options;
        scene.remove(shape);
        options = {
          amount: controls.amount,
          bevelThickness: controls.bevelThickness,
          bevelSize: controls.bevelSize,
          bevelSegments: controls.bevelSegments,
          bevelEnabled: controls.bevelEnabled,
          curveSegments: controls.curveSegments,
          steps: controls.steps
        };
        shape = createMesh(new THREE.ExtrudeGeometry(drawShape(), options));
        return scene.add(shape);
      };
      return this;
    };
    gui = new dat.GUI();
    gui.add(controls, "amount", 0, 20).onChange(controls.asGeom);
    gui.add(controls, "bevelThickness", 0, 10).onChange(controls.asGeom);
    gui.add(controls, "bevelSize", 0, 10).onChange(controls.asGeom);
    gui.add(controls, "bevelSegments", 0, 30).step(1).onChange(controls.asGeom);
    gui.add(controls, "bevelEnabled").onChange(controls.asGeom);
    gui.add(controls, "curveSegments", 1, 30).step(1).onChange(controls.asGeom);
    gui.add(controls, "steps", 1, 5).step(1).onChange(controls.asGeom);
    controls.asGeom();
    step = 0;
    // 实时渲染
    renderScene = function() {
      stats.update();
      shape.rotation.y = step += 0.01;
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