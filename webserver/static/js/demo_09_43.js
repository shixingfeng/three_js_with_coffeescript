// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, mesh, meshAnim, onResize, renderer, scene, step;

  console.log("demo9.43 animation from md2");

  camera = null;

  scene = null;

  renderer = null;

  mesh = null;

  step = 0;

  meshAnim = null;

  init = function() {
    var clock, controls, gui, initStats, loader, renderScene, spotLight, stats, webGLRenderer;
    // 场景
    scene = new THREE.Scene();
    
    // 摄像机
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.x = -50;
    camera.position.y = 40;
    camera.position.z = 60;
    camera.lookAt(new THREE.Vector3(0, 0, 0));
    // 渲染器
    webGLRenderer = new THREE.WebGLRenderer();
    webGLRenderer.setClearColor(new THREE.Color(0xEEEEEE, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMapEnabled = true;
    renderer = webGLRenderer;
    // 灯光
    spotLight = new THREE.SpotLight(0xffffff);
    spotLight.position.set(-50, 70, 60);
    spotLight.intensity = 1;
    scene.add(spotLight);
    // 载入纹理,动画
    clock = new THREE.Clock();
    loader = new THREE.JSONLoader();
    loader.load("/static/pictures/assets/models/ogre/ogro.js", function(geometry, mat, Color) {
      var animLabels, i, key, len, ref;
      geometry.computeMorphNormals();
      mat = new THREE.MeshLambertMaterial({
        map: THREE.ImageUtils.loadTexture("/static/pictures/assets/models/ogre/skins/skin.jpg"),
        morphTargets: true,
        morphNormals: true,
        Color: 0x4e0f0a
      });
      mesh = new THREE.MorphAnimMesh(geometry, mat);
      mesh.rotation.y = 0.7;
      mesh.parseAnimations();
      animLabels = [];
      ref = mesh.geometry.animations;
      for (i = 0, len = ref.length; i < len; i++) {
        key = ref[i];
        if (key === "length" || !mesh.geometry.animations.hasOwnProperty(key)) {
          continue;
        }
        animLabels.push(key);
      }
      gui.add(controls, "animations", animLabels).onChange(function(e) {
        return mesh.playAnimation(controls.animations, controls.fps);
      });
      gui.add(controls, "fps", 1, 20).step(1).onChange(function(e) {
        return mesh.playAnimation(controls.animations, controls.fps);
      });
      mesh.playAnimation("crattack", 10);
      return scene.add(mesh);
    });
    
    // 控制台
    controls = new function() {
      this.animations = "crattack";
      return this.fps = 10;
    };
    
    // UI
    gui = new dat.GUI();
    // 实时渲染
    renderScene = function() {
      var delta;
      stats.update();
      delta = clock.getDelta();
      if (mesh) {
        mesh.updateAnimation(delta * 1000);
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