// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, loadedMesh, onResize, renderer, scene;

  console.log("demo_8.13  Save & Load");

  camera = null;

  scene = null;

  renderer = null;

  loadedMesh = null;

  init = function() {
    var controls, createMesh, gui, initStats, ioGui, knot, meshGui, renderScene, stats, step, webGLRenderer;
    // 场景
    scene = new THREE.Scene();
    
    // 摄像机
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.x = -30;
    camera.position.y = 40;
    camera.position.z = 50;
    camera.lookAt(new THREE.Vector3(-20, 0, 0));
    
    // 渲染器
    webGLRenderer = new THREE.WebGLRenderer();
    webGLRenderer.setClearColor(new THREE.Color(0xEEEEEE, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMapEnabled = true;
    renderer = webGLRenderer;
    
    // 材质
    createMesh = function(geom) {
      var mesh, meshMaterial;
      meshMaterial = new THREE.MeshBasicMaterial({
        vertexColors: THREE.VertexColors,
        wireframe: true,
        wireframeLinewidth: 2,
        color: 0xaaaaaa
      });
      meshMaterial.side = THREE.DoubleSide;
      mesh = new THREE.Mesh(geom, meshMaterial);
      return mesh;
    };
    
    //网格物体
    knot = createMesh(new THREE.TorusKnotGeometry(10, 1, 64, 8, 2, 3, 1));
    scene.add(knot);
    // 控制条
    controls = new function() {
      console.log(knot.geometry.parameters);
      this.radius = knot.geometry.parameters.radius;
      this.tube = 0.3;
      this.radialSegments = knot.geometry.parameters.radialSegments;
      this.tubularSegments = knot.geometry.parameters.tubularSegments;
      this.p = knot.geometry.parameters.p;
      this.q = knot.geometry.parameters.q;
      this.heightScale = knot.geometry.parameters.heightScale;
      this.redraw = function() {
        scene.remove(knot);
        knot = createMesh(new THREE.TorusKnotGeometry(controls.radius, controls.tube, Math.round(controls.radialSegments), Math.round(controls.tubularSegments), Math.round(controls.p), Math.round(controls.q), controls.heightScale));
        return scene.add(knot);
      };
      this.save = function() {
        var result;
        result = knot.toJSON();
        return localStorage.setItem("json", JSON.stringify(result));
      };
      this.load = function() {
        var json, loadedGeometry, loader;
        scene.remove(loadedMesh);
        json = localStorage.getItem("json");
        if (json) {
          //将数据由json格式转换成对象
          loadedGeometry = JSON.parse(json);
          loader = new THREE.ObjectLoader();
          loadedMesh = loader.parse(loadedGeometry);
          loadedMesh.position.x -= 50;
          return scene.add(loadedMesh);
        }
      };
      return this;
    };
    // UI呈现
    gui = new dat.GUI();
    ioGui = gui.addFolder("Save & Load");
    ioGui.add(controls, "save").onChange(controls.save);
    ioGui.add(controls, "load").onChange(controls.load);
    meshGui = gui.addFolder("mesh");
    meshGui.add(controls, "radius", 0, 40).onChange(controls.redraw);
    meshGui.add(controls, "tube", 0, 40).onChange(controls.redraw);
    meshGui.add(controls, "radialSegments", 0, 400).step(1).onChange(controls.redraw);
    meshGui.add(controls, "tubularSegments", 1, 20).step(1).onChange(controls.redraw);
    meshGui.add(controls, "p", 1, 10).step(1).onChange(controls.redraw);
    meshGui.add(controls, "q", 1, 15).step(1).onChange(controls.redraw);
    meshGui.add(controls, "heightScale", 0, 5).onChange(controls.redraw);
    controls.redraw();
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
