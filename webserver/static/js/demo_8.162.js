// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, mesh, onResize, renderer, scene;

  console.log("demo_8.162  Load OBJ and MTL");

  camera = null;

  scene = null;

  renderer = null;

  mesh = null;

  init = function() {
    var add_uri, controls, gui, initStats, loader, renderScene, spotLight, stats, step, webGLRenderer;
    // 场景
    scene = new THREE.Scene();
    
    // 摄像机
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.x = -30;
    camera.position.y = 40;
    camera.position.z = 50;
    camera.lookAt(new THREE.Vector3(0, 10, 0));
    
    // 渲染器
    webGLRenderer = new THREE.WebGLRenderer();
    webGLRenderer.setClearColor(new THREE.Color(0xaaaaff, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMapEnabled = true;
    renderer = webGLRenderer;
    //灯光
    spotLight = new THREE.SpotLight(0xffffff);
    spotLight.position.set(0, 40, 30);
    spotLight.intensity = 2;
    scene.add(spotLight);
    // 控制条
    controls = new function() {};
    
    // UI呈现
    gui = new dat.GUI();
    loader = new THREE.OBJMTLLoader();
    add_uri = "/static/pictures/assets/models/";
    loader.load(add_uri + "butterfly.obj", add_uri + "butterfly.mtl", function(object) {
      var wing1, wing2;
      wing2 = object.children[5].children[0];
      wing1 = object.children[4].children[0];
      wing1.material.opacity = 0.6;
      wing1.material.transparent = true;
      wing1.material.depthTest = false;
      wing1.material.side = THREE.DoubleSide;
      wing2.material.opacity = 0.6;
      wing2.material.depthTest = false;
      wing2.material.transparent = true;
      wing2.material.side = THREE.DoubleSide;
      object.scale.set(140, 140, 140);
      mesh = object;
      scene.add(mesh);
      object.rotation.x = 0.2;
      return object.rotation.y = -1.3;
    });
    step = 0;
    // 实时渲染
    renderScene = function() {
      stats.update();
      if (mesh) {
        mesh.rotation.y += 0.006;
      }
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
