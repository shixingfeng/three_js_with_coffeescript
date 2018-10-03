// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, mesh, onResize, renderer, scene;

  console.log("demo_11.11 Effect composings");

  camera = null;

  scene = null;

  renderer = null;

  mesh = null;

  init = function() {
    var ambi, clock, composer, controls, createMesh, effectFilm, gui, initStats, orbitControls, renderPass, renderScene, sphere, spotLight, stats, step, webGLRenderer;
    // 场景
    scene = new THREE.Scene();
    
    // 摄像机
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.x = -10;
    camera.position.y = 15;
    camera.position.z = 25;
    camera.lookAt(new THREE.Vector3(0, 0, 0));
    orbitControls = new THREE.OrbitControls(camera);
    orbitControls.autoRotate = false;
    // 渲染器
    webGLRenderer = new THREE.WebGLRenderer();
    webGLRenderer.setClearColor(new THREE.Color(0x000, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMapEnabled = true;
    renderer = webGLRenderer;
    //灯光
    ambi = new THREE.AmbientLight(0x181818);
    scene.add(ambi);
    spotLight = new THREE.DirectionalLight(0xffffff);
    spotLight.position.set(550, 100, 550);
    spotLight.intensity = 0.6;
    scene.add(spotLight);
    // 方法
    createMesh = function(geom) {
      var normalTexture, planetMaterial, planetTexture, specularTexture;
      planetTexture = THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/planets/Earth.png");
      specularTexture = THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/planets/EarthSpec.png");
      normalTexture = THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/planets/EarthNormal.png");
      planetMaterial = new THREE.MeshPhongMaterial();
      planetMaterial.specularMap = specularTexture;
      planetMaterial.specular = new THREE.Color(0x4444aa);
      planetMaterial.normalMap = normalTexture;
      planetMaterial.map = planetTexture;
      mesh = THREE.SceneUtils.createMultiMaterialObject(geom, [planetMaterial]);
      return mesh;
    };
    
    //球体
    sphere = createMesh(new THREE.SphereGeometry(10, 40, 40));
    scene.add(sphere);
    
    // 效果组合器
    renderPass = new THREE.RenderPass(scene, camera);
    effectFilm = new THREE.FilmPass(0.8, 0.325, 256, false);
    effectFilm.renderToScreen = true;
    composer = new THREE.EffectComposer(webGLRenderer);
    composer.addPass(renderPass);
    composer.addPass(effectFilm);
    
    // 控制条
    controls = new function() {
      this.scanlinesCount = 256;
      this.grayscale = false;
      this.scanlinesIntensity = 0.3;
      this.noiseIntensity = 0.8;
      this.updateEffectFilm = function() {
        effectFilm.uniforms.grayscale.value = controls.grayscale;
        effectFilm.uniforms.nIntensity.value = controls.noiseIntensity;
        effectFilm.uniforms.sIntensity.value = controls.scanlinesIntensity;
        return effectFilm.uniforms.sCount.value = controls.scanlinesCount;
      };
      return this;
    };
    // UI
    gui = new dat.GUI;
    gui.add(controls, "scanlinesIntensity", 0, 1).onChange(controls.updateEffectFilm);
    gui.add(controls, "noiseIntensity", 0, 3).onChange(controls.updateEffectFilm);
    gui.add(controls, "grayscale").onChange(controls.updateEffectFilm);
    gui.add(controls, "scanlinesCount", 0, 2048).step(1).onChange(controls.updateEffectFilm);
    step = 0;
    clock = new THREE.Clock();
    // 实时渲染
    renderScene = function() {
      var delta;
      stats.update();
      delta = clock.getDelta();
      orbitControls.update(delta);
      sphere.rotation.y += 0.002;
      requestAnimationFrame(renderScene);
      // renderer.render scene,camera
      return composer.render(delta);
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