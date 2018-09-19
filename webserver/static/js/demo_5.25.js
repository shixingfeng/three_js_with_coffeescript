// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, onResize, renderer, scene;

  console.log("demo_5.25  geometries - Torusknot");

  camera = null;

  scene = null;

  renderer = null;

  init = function() {
    var controls, createMesh, gui, initStats, knot, renderScene, stats, step, webGLRenderer;
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
      meshMaterial = new THREE.MeshNormalMaterial();
      meshMaterial.side = THREE.DoubleSide;
      wireFrameMat = new THREE.MeshBasicMaterial();
      wireFrameMat.wireframe = true;
      mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial, wireFrameMat]);
      return mesh;
    };
    // 创建二维几何体 knot
    knot = createMesh(new THREE.TorusKnotGeometry(10, 1, 64, 8, 2, 3, 1));
    scene.add(knot);
    
    // 控制条
    controls = new function() {
      this.radius = knot.children[0].geometry.parameters.radius;
      this.tube = 0.3;
      this.radialSegments = knot.children[0].geometry.parameters.radialSegments;
      this.tubularSegments = knot.children[0].geometry.parameters.tubularSegments;
      this.p = knot.children[0].geometry.parameters.p;
      this.q = knot.children[0].geometry.parameters.q;
      this.heightScale = knot.children[0].geometry.parameters.heightScale;
      this.redraw = function() {
        scene.remove(knot);
        knot = createMesh(new THREE.TorusKnotGeometry(controls.radius, controls.tube, Math.round(controls.radialSegments), Math.round(controls.tubularSegments), Math.round(controls.p), Math.round(controls.q), controls.heightScale));
        return scene.add(knot);
      };
      return this;
    };
    gui = new dat.GUI();
    gui.add(controls, "radius", 0, 40).onChange(controls.redraw);
    gui.add(controls, "tube", 0, 40).onChange(controls.redraw);
    gui.add(controls, "radialSegments", 0, 400).step(1).onChange(controls.redraw);
    gui.add(controls, "tubularSegments", 1, 20).step(1).onChange(controls.redraw);
    gui.add(controls, "p", 1, 10).step(1).onChange(controls.redraw);
    gui.add(controls, "q", 1, 15).step(1).onChange(controls.redraw);
    gui.add(controls, "heightScale", 0, 5).onChange(controls.redraw);
    step = 0;
    // 实时渲染
    renderScene = function() {
      stats.update();
      knot.rotation.y = step += 0.01;
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