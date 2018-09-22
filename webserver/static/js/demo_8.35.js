// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, mesh, model, onResize, renderer, scene;

  console.log("demo_8.35  Load assimp model");

  camera = null;

  scene = null;

  renderer = null;

  mesh = null;

  model = null;

  init = function() {
    var add_uri, controls, dir1, dir2, dir3, group, gui, initStats, loader, orbit, renderScene, spotLight, stats, step, webGLRenderer;
    // 场景
    scene = new THREE.Scene();
    
    // 摄像机
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.x = 30;
    camera.position.y = 30;
    camera.position.z = 30;
    camera.lookAt(new THREE.Vector3(0, 0, 0));
    
    // 渲染器
    webGLRenderer = new THREE.WebGLRenderer();
    webGLRenderer.setClearColor(new THREE.Color(0x000, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMapEnabled = true;
    renderer = webGLRenderer;
    //灯光
    orbit = new THREE.OrbitControls(camera);
    dir1 = new THREE.DirectionalLight();
    dir1.position.set(-30, 30, -30);
    scene.add(dir1);
    dir2 = new THREE.DirectionalLight();
    dir2.position.set(-30, 30, 30);
    scene.add(dir2);
    dir3 = new THREE.DirectionalLight();
    dir3.position.set(30, 30, -30);
    scene.add(dir3);
    // 阴影
    spotLight = new THREE.SpotLight(0xffffff);
    spotLight.position.set(30, 30, 30);
    scene.add(spotLight);
    // 控制条
    controls = new function() {};
    
    // UI呈现
    gui = new dat.GUI();
    loader = new THREE.AssimpJSONLoader();
    group = new THREE.Object3D();
    add_uri = "/static/pictures/assets/models/assimp/";
    loader.load(add_uri + "spider.obj.assimp.json", function(model) {
      console.log(model);
      model.traverse(function(child) {
        if (child instanceof THREE.Mesh) {
          return child.material = new THREE.MeshLambertMaterial({
            color: 0x8bc34a
          });
        }
      });
      model.scale.set(0.05, 0.05, 0.05);
      return scene.add(model);
    });
    step = 0;
    // 实时渲染
    renderScene = function() {
      stats.update();
      orbit.update();
      scene.rotation.y = step += 0.005;
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
