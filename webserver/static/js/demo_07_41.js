// Generated by CoffeeScript 2.3.1
(function() {
  var camera, cloud, init, onResize, renderer, scene, system1;

  console.log(" demo7.41 Particles Rainy scene");

  camera = null;

  scene = null;

  renderer = null;

  cloud = null;

  system1 = null;

  init = function() {
    var controls, createPointCloud, gui, initStats, renderScene, stats, step, webGLRenderer;
    // 场景
    scene = new THREE.Scene();
    
    // 摄像机
    camera = new THREE.PerspectiveCamera(45, window.innerWidth / window.innerHeight, 0.1, 200);
    camera.position.x = 20;
    camera.position.y = 40;
    camera.position.z = 110;
    camera.lookAt(new THREE.Vector3(20, 30, 0));
    
    // 渲染器
    webGLRenderer = new THREE.WebGLRenderer();
    webGLRenderer.setClearColor(new THREE.Color(0x000000, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    renderer = webGLRenderer;
    createPointCloud = function(size, transparent, opacity, sizeAttenuation, color) {
      var geom, i, j, material, particle, range, texture;
      texture = THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/particles/raindrop-2.png");
      geom = new THREE.Geometry();
      material = new THREE.ParticleBasicMaterial({
        size: size,
        transparent: transparent,
        opacity: opacity,
        map: texture,
        blending: THREE.AdditiveBlending,
        sizeAttenuation: sizeAttenuation,
        color: color
      });
      range = 40;
      for (i = j = 0; j <= 1499; i = ++j) {
        particle = new THREE.Vector3(Math.random() * range - range / 2, Math.random() * range * 1.5, Math.random() * range - range / 2);
        // 方向和下落速度
        particle.velocityY = 0.1 + Math.random() / 5;
        particle.velocityX = (Math.random() - 0.5) / 3;
        geom.vertices.push(particle);
      }
      cloud = new THREE.ParticleSystem(geom, material);
      cloud.sortParticles = true;
      return scene.add(cloud);
    };
    //控制条
    controls = new function() {
      this.size = 3;
      this.transparent = true;
      this.opacity = 0.6;
      this.color = 0xffffff;
      this.sizeAttenuation = true;
      this.redraw = function() {
        scene.remove(scene.getObjectByName("particles1"));
        scene.remove(scene.getObjectByName("particles2"));
        return createPointCloud(controls.size, controls.transparent, controls.opacity, controls.sizeAttenuation, controls.color);
      };
      return this;
    };
    // UI
    gui = new dat.GUI();
    gui.add(controls, "size", 0, 20).onChange(controls.redraw);
    gui.add(controls, "transparent").onChange(controls.redraw);
    gui.add(controls, "opacity", 0, 1).onChange(controls.redraw);
    gui.addColor(controls, "color").onChange(controls.redraw);
    gui.add(controls, "sizeAttenuation").onChange(controls.redraw);
    //执行绘图
    controls.redraw();
    step = 0;
    // 实时渲染
    renderScene = function() {
      var vertices;
      stats.update();
      vertices = cloud.geometry.vertices;
      vertices.forEach(function(v) {
        v.y = v.y - v.velocityY;
        v.x = v.x - v.velocityX;
        if (v.y <= 0) {
          v.y = 60;
        }
        if (v.x <= -20 || v.x >= 20) {
          return v.velocityX = v.velocityX * -1;
        }
      });
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
