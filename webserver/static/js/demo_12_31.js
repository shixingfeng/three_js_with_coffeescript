// Generated by CoffeeScript 2.3.1
(function() {
  var applyForce, box, box_material, boxes, camera, createGround, createHeightMap, createShape, direction, getMaterial, ground, ground_material, initScene, light, mesh, mouse_position, onResize, physics_stats, projector, render, render_stats, renderer, scale, scene, setMousePosition, setPosAndShade, stepX;

  console.log("demo_12.31 Physijs shapes");

  camera = null;

  scene = null;

  renderer = null;

  mesh = null;

  stepX = null;

  direction = 1;

  "use strict";

  scale = chroma.scale(["white", "blue"]);

  Physijs.scripts.worker = "/static/js/libs/physijs_worker.js";

  Physijs.scripts.ammo = "/static/js/libs/ammo.js";

  initScene = [];

  render = [];

  applyForce = [];

  setMousePosition = [];

  mouse_position = [];

  ground_material = [];

  projector = [];

  box_material = [];

  renderer = [];

  render_stats = [];

  physics_stats = [];

  scene = [];

  ground = [];

  light = [];

  camera = [];

  box = [];

  boxes = [];

  // 实时渲染
  render = function() {
    render_stats.update();
    requestAnimationFrame(render);
    renderer.render(scene, camera);
    return scene.simulate(void 0, 2);
  };

  createHeightMap = function(pn) {
    var ground_geometry, i, j, ref, value, vertex;
    ground_material = Physijs.createMaterial(new THREE.MeshLambertMaterial({
      map: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/ground/grasslight-big.jpg")
    }), .3, .8);
    ground_geometry = new THREE.PlaneGeometry(120, 100, 100, 100);
    for (i = j = 0, ref = ground_geometry.vertices.length - 1; (0 <= ref ? j <= ref : j >= ref); i = 0 <= ref ? ++j : --j) {
      vertex = ground_geometry.vertices[i];
      value = pn.noise(vertex.x / 10, vertex.y / 10, 0);
      vertex.z = value * 10;
    }
    ground_geometry.computeFaceNormals();
    ground_geometry.computeVertexNormals();
    ground = new Physijs.HeightfieldMesh(ground_geometry, ground_material, 0, 100, 100);
    ground.rotation.x = Math.PI / -2;
    ground.rotation.y = 0.4;
    ground.receiveShadow = true;
    return ground;
  };

  createShape = function() {
    var hullGeometry, i, j, points, randomX, randomY, randomZ;
    points = [];
    for (i = j = 0; j <= 29; i = ++j) {
      randomX = -5 + Math.round(Math.random() * 10);
      randomY = -5 + Math.round(Math.random() * 10);
      randomZ = -5 + Math.round(Math.random() * 10);
      points.push(new THREE.Vector3(randomX, randomY, randomZ));
    }
    hullGeometry = new THREE.ConvexGeometry(points);
    return hullGeometry;
  };

  setPosAndShade = function(obj) {
    obj.position.set(Math.random() * 20 - 45, 40, Math.random() * 20 - 5);
    obj.rotation.set(Math.random() * 2 * Math.PI, Math.random() * 2 * Math.PI, Math.random() * 2 * Math.PI);
    return obj.castShadow = true;
  };

  getMaterial = function() {
    var material;
    material = Physijs.createMaterial(new THREE.MeshLambertMaterial({
      color: scale(Math.random()).hex()
    }), 0.5, 0.7);
    return material;
  };

  createGround = function() {
    var borderBottom, borderLeft, borderRight, borderTop, length, width;
    length = 120;
    width = 120;
    ground_material = Physijs.createMaterial(new THREE.MeshPhongMaterial({
      map: THREE.ImageUtils.loadTexture("/static/pictures/assets/textures/general/floor-wood.jpg'")
    }), 1, .7);
    ground = new Physijs.BoxMesh(new THREE.BoxGeometry(length, 1, width), ground_material, 0);
    ground.receiveShadow = true;
    borderLeft = new Physijs.BoxMesh(new THREE.BoxGeometry(2, 6, width), ground_material, 0);
    borderLeft.position.x = -1 * length / 2 - 1;
    borderLeft.position.y = 2;
    borderLeft.receiveShadow = true;
    ground.add(borderLeft);
    borderRight = new Physijs.BoxMesh(new THREE.BoxGeometry(2, 6, width), ground_material, 0);
    borderRight.position.x = length / 2 + 1;
    borderRight.position.y = 2;
    borderRight.receiveShadow = true;
    ground.add(borderRight);
    borderBottom = new Physijs.BoxMesh(new THREE.BoxGeometry(width - 1, 6, 2), ground_material, 0);
    borderBottom.position.z = width / 2;
    borderBottom.position.y = 1.5;
    borderBottom.receiveShadow = true;
    ground.add(borderBottom);
    borderTop = new Physijs.BoxMesh(new THREE.BoxGeometry(width, 6, 2), ground_material, 0);
    borderTop.position.z = -width / 2;
    borderTop.position.y = 2;
    borderTop.receiveShadow = true;
    ground.position.x = 0;
    ground.position.z = 0;
    ground.add(borderTop);
    ground.receiveShadow = true;
    return scene.add(ground);
  };

  initScene = function() {
    var ambi, controls, date, gui, map, meshes, pn, webGLRenderer;
    // 场景
    scene = new Physijs.Scene({
      reportSize: 10,
      fixedTimeStep: 1 / 60
    });
    scene.setGravity(new THREE.Vector3(0, -20, 0));
    
    // 摄像机
    camera = new THREE.PerspectiveCamera(35, window.innerWidth / window.innerHeight, 1, 1000);
    camera.position.set(105, 85, 85);
    camera.lookAt(new THREE.Vector3(0, 0, 0));
    scene.add(camera);
    
    // 渲染器
    webGLRenderer = new THREE.WebGLRenderer();
    webGLRenderer.antialias = true;
    webGLRenderer.setClearColor(new THREE.Color(0x000000));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    renderer = webGLRenderer;
    $("#viewport").append(renderer.domElement);
    //灯光
    ambi = new THREE.AmbientLight(0x222222);
    scene.add(ambi);
    light = new THREE.SpotLight(0xFFFFFF);
    light.position.set(40, 50, 100);
    light.castShadow = true;
    light.shadowMapDebug = true;
    light.shadowCameraNear = 10;
    light.shadowCameraFar = 200;
    light.intensity = 1.5;
    scene.add(light);
    meshes = [];
    // 控制条
    controls = new function() {
      this.addSphereMesh = function() {
        var sphere;
        sphere = new Physijs.SphereMesh(new THREE.SphereGeometry(3, 20), getMaterial());
        setPosAndShade(sphere);
        meshes.push(sphere);
        return scene.add(sphere);
      };
      this.addBoxMesh = function() {
        var cube;
        cube = new Physijs.BoxMesh(new THREE.BoxGeometry(4, 2, 6), getMaterial());
        setPosAndShade(cube);
        meshes.push(cube);
        return scene.add(cube);
      };
      this.addCylinderMesh = function() {
        var cylinder;
        cylinder = new Physijs.CylinderMesh(new THREE.CylinderGeometry(2, 2, 6), getMaterial());
        setPosAndShade(cylinder);
        meshes.push(cylinder);
        return scene.add(cylinder);
      };
      this.addConeMesh = function() {
        var cone;
        cone = new Physijs.ConeMesh(new THREE.CylinderGeometry(0, 3, 7, 20, 10), getMaterial());
        setPosAndShade(cone);
        meshes.push(cone);
        return scene.add(cone);
      };
      this.addPlaneMesh = function() {
        var plane;
        plane = new Physijs.PlaneMesh(new THREE.PlaneGeometry(5, 5, 10, 10), getMaterial());
        setPosAndShade(plane);
        meshes.push(plane);
        return scene.add(plane);
      };
      this.addCapsuleMesh = function() {
        var bot, capsule, cyl, matrix, merged, top;
        merged = new THREE.Geometry();
        cyl = new THREE.CylinderGeometry(2, 2, 6);
        top = new THREE.SphereGeometry(2);
        bot = new THREE.SphereGeometry(2);
        matrix = new THREE.Matrix4();
        matrix.makeTranslation(0, 3, 0);
        top.applyMatrix(matrix);
        matrix = new THREE.Matrix4();
        matrix.makeTranslation(0, -3, 0);
        bot.applyMatrix(matrix);
        merged.merge(top);
        merged.merge(bot);
        merged.merge(cyl);
        capsule = new Physijs.CapsuleMesh(merged, getMaterial());
        setPosAndShade(capsule);
        meshes.push(capsule);
        return scene.add(capsule);
      };
      this.addConvexMesh = function() {
        var convex;
        convex = new Physijs.ConvexMesh(new THREE.TorusKnotGeometry(0.5, 0.3, 64, 8, 2, 3, 10), getMaterial());
        setPosAndShade(convex);
        meshes.push(convex);
        return scene.add(convex);
      };
      this.clearMeshes = function() {
        meshes.forEach(function(e) {
          return scene.remove(e);
        });
        return meshes = [];
      };
      return this;
    };
    
    // UI
    gui = new dat.GUI();
    gui.add(controls, "addPlaneMesh");
    gui.add(controls, "addBoxMesh");
    gui.add(controls, "addSphereMesh");
    gui.add(controls, "addCylinderMesh");
    gui.add(controls, "addConeMesh");
    gui.add(controls, "addCapsuleMesh");
    gui.add(controls, "addConvexMesh");
    gui.add(controls, "clearMeshes");
    date = new Date();
    pn = new Perlin("rnd" + date.getTime());
    map = createHeightMap(pn);
    scene.add(map);
    requestAnimationFrame(render);
    scene.simulate();
    
    // 状态条
    render_stats = new Stats();
    render_stats.setMode(0);
    render_stats.domElement.style.position = "absolute";
    render_stats.domElement.style.top = "1px";
    render_stats.domElement.style.zIndex = 100;
    return $("#viewport").append(render_stats.domElement);
  };

  //屏幕适配
  onResize = function() {
    console.log("onResize");
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
    return renderer.setSize(window.innerWidth, window.innerHeight);
  };

  window.onload = initScene;

  window.addEventListener("resize", onResize, false);

}).call(this);