// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, mesh, onResize, renderer, scene;

  console.log("demo_8.15  Load blender model");

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
    webGLRenderer.setClearColor(new THREE.Color(0xEEEEEE, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMapEnabled = true;
    renderer = webGLRenderer;
    //灯光
    spotLight = new THREE.SpotLight(0xffffff);
    spotLight.position.set(0, 50, 30);
    spotLight.intensity = 2;
    scene.add(spotLight);
    // 控制条
    controls = new function() {};
    
    // UI呈现
    gui = new dat.GUI();
    loader = new THREE.JSONLoader();
    add_uri = "/static/pictures/assets/models/";
    loader.load(add_uri + "misc_chair01.js", function(geometry, mat) {
      mesh = new THREE.Mesh(geometry, mat[0]);
      mesh.scale.x = 15;
      mesh.scale.y = 15;
      mesh.scale.z = 15;
      return scene.add(mesh);
    }, add_uri);
    step = 0;
    // 实时渲染
    renderScene = function() {
      stats.update();
      if (mesh) {
        mesh.rotation.y += 0.02;
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
