// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, onResize, renderer, scene;

  console.log("demo_5.24  geometries - Torus");

  camera = null;

  scene = null;

  renderer = null;

  init = function() {
    var controls, createMesh, gui, initStats, renderScene, spotLight, stats, step, torus, webGLRenderer;
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
    // 创建二维几何体 圆柱
    torus = createMesh(new THREE.TorusGeometry(10, 10, 8, 6, Math.PI * 2));
    scene.add(torus);
    
    // 光源
    spotLight = new THREE.SpotLight(0xffffff);
    spotLight.position.set(-40, 60, -10);
    scene.add(spotLight);
    
    // 控制条
    controls = new function() {
      this.radius = torus.children[0].geometry.parameters.radius;
      this.tube = torus.children[0].geometry.parameters.tube;
      this.radialSegments = torus.children[0].geometry.parameters.radialSegments;
      this.tubularSegments = torus.children[0].geometry.parameters.tubularSegments;
      this.arc = torus.children[0].geometry.parameters.arc;
      this.redraw = function() {
        scene.remove(torus);
        torus = createMesh(new THREE.TorusGeometry(controls.radius, controls.tube, Math.round(controls.radialSegments), Math.round(controls.tubularSegments), controls.arc));
        return scene.add(torus);
      };
      return this;
    };
    gui = new dat.GUI();
    gui.add(controls, "radius", 0, 40).onChange(controls.redraw);
    gui.add(controls, "tube", 0, 40).onChange(controls.redraw);
    gui.add(controls, "radialSegments", 0, 40).onChange(controls.redraw);
    gui.add(controls, "tubularSegments", 1, 20).onChange(controls.redraw);
    gui.add(controls, "arc", 0, Math.PI * 2).onChange(controls.redraw);
    step = 0;
    // 实时渲染
    renderScene = function() {
      stats.update();
      torus.rotation.y = step += 0.01;
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
