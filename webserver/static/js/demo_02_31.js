// Generated by CoffeeScript 2.3.1
(function() {
  var camera, init, onResize, renderer;

  console.log("demo_02_31 正交投影和透视投影");

  console.log("PerspectiveCamera透视投影，最自然的视图、OrthographicCamera正交投影，物体尺寸不受远近影响");

  camera = null;

  renderer = null;

  // 屏幕适配
  onResize = function() {
    console.log("onResize");
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    return renderer.setSize(window.innerWidth, window.innerHeight);
  };

  init = function() {
    var ambientLight, controls, cube, cubeGeometry, cubeMaterial, directionalLight, gui, i, initStats, j, k, l, plane, planeGeometry, planeMaterial, ref, ref1, renderScene, rnd, scene, stats;
    // 场景
    scene = new THREE.Scene();
    // 摄像机
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
    camera.position.x = 120;
    camera.position.y = 60;
    camera.position.z = 180;
    camera.lookAt(scene.position);
    
    // 渲染器
    renderer = new THREE.WebGLRenderer();
    renderer.setClearColor(new THREE.Color(0xEEEEEE, 1.0));
    renderer.setSize(window.innerWidth, window.innerHeight);
    renderer.shadowMapEnabled = true;
    
    // 物体材质和几何
    planeGeometry = new THREE.PlaneGeometry(180, 180);
    planeMaterial = new THREE.MeshLambertMaterial({
      color: 0xffffff
    });
    plane = new THREE.Mesh(planeGeometry, planeMaterial);
    plane.rotation.x = -0.5 * Math.PI;
    plane.position.x = 0;
    plane.position.y = 0;
    plane.position.z = 0;
    plane.receiveShadow = true;
    scene.add(plane);
    cubeGeometry = new THREE.BoxGeometry(4, 4, 4);
    for (j = k = 0, ref = planeGeometry.parameters.height / 5; (0 <= ref ? k <= ref : k >= ref); j = 0 <= ref ? ++k : --k) {
      for (i = l = 0, ref1 = planeGeometry.parameters.width / 5; (0 <= ref1 ? l <= ref1 : l >= ref1); i = 0 <= ref1 ? ++l : --l) {
        rnd = Math.random() * 0.75 + 0.25;
        cubeMaterial = new THREE.MeshLambertMaterial();
        cubeMaterial.color = new THREE.Color(rnd, 0, 0);
        cube = new THREE.Mesh(cubeGeometry, cubeMaterial);
        cube.position.z = -(planeGeometry.parameters.height / 2) + 2 + (j * 5);
        cube.position.x = -(planeGeometry.parameters.width / 2) + 2 + (i * 5);
        cube.position.y = 2;
        scene.add(cube);
      }
    }
    // 环境光
    ambientLight = new THREE.AmbientLight(0x292929);
    scene.add(ambientLight);
    directionalLight = new THREE.DirectionalLight(0xffffff, 0.7);
    directionalLight.position.set(-20, 40, 60);
    scene.add(directionalLight);
    // 控制台
    controls = new function() {
      this.perspective = "Perspective";
      this.switchCamera = function() {
        if (camera instanceof THREE.PerspectiveCamera) {
          camera = new THREE.OrthographicCamera(window.innerWidth / -16, window.innerWidth / 16, window.innerHeight / 16, window.innerHeight / -16, -200, 500);
          camera.position.x = 120;
          camera.position.y = 60;
          camera.position.z = 180;
          camera.lookAt(scene.position);
          return this.perspective = "Orthographic";
        } else {
          camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 1000);
          camera.position.x = 120;
          camera.position.y = 60;
          camera.position.z = 180;
          camera.lookAt(scene.position);
          return this.perspective = "Perspective";
        }
      };
      return this;
    };
    gui = new dat.GUI();
    gui.add(controls, "switchCamera");
    gui.add(controls, "perspective").listen();
    
    // 帧数更新、物体控制参数、调用渲染本身,将结果输出到屏幕
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
    // 帧数更新、物体控制参数、调用渲染本身,将结果输出到屏幕
    renderScene = function() {
      stats.update();
      requestAnimationFrame(renderScene);
      renderer.render(scene, camera);
      return $("#WebGL-output").append(renderer.domElement);
    };
    // 执行帧数显示(在renderScene中执行更新)、实时渲染、屏幕监听
    stats = initStats();
    renderScene();
    return window.addEventListener("resize", onResize, false);
  };

  // 浏览器加载完成时，执行函数init()
  window.onload = init;

}).call(this);