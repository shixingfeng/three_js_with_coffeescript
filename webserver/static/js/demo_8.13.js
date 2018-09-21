// Generated by CoffeeScript 2.3.1
(function() {
  var camera, group, init, onResize, renderer, scene;

  console.log("demo_8.11  Grouping");

  camera = null;

  scene = null;

  renderer = null;

  group = null;

  init = function() {
    var controls, createMesh, cubeFolder, ground, groundMesh, gui, initStats, renderScene, setFromObject, sphereFolder, stats, step, webGLRenderer;
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
    webGLRenderer.setClearColor(new THREE.Color(0xEEEEEE, 1.0));
    webGLRenderer.setSize(window.innerWidth, window.innerHeight);
    webGLRenderer.shadowMapEnabled = true;
    renderer = webGLRenderer;
    // 地面
    ground = new THREE.PlaneGeometry(100, 100, 50, 50);
    groundMesh = THREE.SceneUtils.createMultiMaterialObject(ground, [
      new THREE.MeshBasicMaterial({
        wireframe: true,
        overdraw: true,
        color: 0x00ff00
      }),
      new THREE.MeshBasicMaterial({
        color: 0x00ff00,
        transparent: true,
        opacity: 0.5
      })
    ]);
    groundMesh.rotation = -0.5 * Math.PI;
    scene.add(groundMesh);
    setFromObject = function(object) {
      var box, v1;
      box = new THREE.Box3();
      v1 = new THREE.Vector3();
      object.updateMatrixWorld(true);
      box.makeEmpty();
      object.traverse(function(node) {
        var i, j, ref, results, vertices;
        if (node.geometry !== void 0 && node.geometry.vertices !== void 0) {
          vertices = node.geometry.vertices;
          console.log(vertices.length);
          results = [];
          for (i = j = 0, ref = vertices.length; (0 <= ref ? j <= ref : j >= ref); i = 0 <= ref ? ++j : --j) {
            v1.copy(vertices[i]);
            v1.applyMatrix4(node.matrixWorld);
            results.push(box.expandByPoint(v1));
          }
          return results;
        }
      });
      return box;
    };
    // 材质
    createMesh = function(geom) {
      var meshMaterial, plane, wireFrameMat;
      meshMaterial = new THREE.MeshNormalMaterial();
      meshMaterial.side = THREE.DoubleSide;
      wireFrameMat = new THREE.MeshBasicMaterial();
      wireFrameMat.wireframe = true;
      plane = THREE.SceneUtils.createMultiMaterialObject(geom, [meshMaterial, wireFrameMat]);
      return plane;
    };
    
    // 控制条
    controls = new function() {
      this.cubePosX = 0;
      this.cubePosY = 3;
      this.cubePosZ = 10;
      this.spherePosX = 10;
      this.spherePosY = 5;
      this.spherePosZ = 0;
      this.groupPosX = 10;
      this.groupPosY = 5;
      this.groupPosZ = 0;
      this.grouping = false;
      this.rotate = false;
      this.groupScale = 1;
      this.cubeScale = 1;
      this.sphereScale = 1;
      this.positionBoundingBox = function() {
        var bbox, bboxMesh, box, depth, height, width;
        scene.remove(bboxMesh);
        box = setFromObject(group);
        width = box.max.x - box.min.x;
        height = box.max.y - box.min.y;
        depth = box.max.z - box.min.z;
        bbox = new THREE.BoxGeometry(width, height, depth);
        bboxMesh = new THREE.Mesh(bbox, new THREE.MeshBasicMaterial({
          color: 0x000000,
          vertexColors: THREE.VertexColors,
          wireframeLinewidth: 2,
          wireframe: true
        }));
        bboxMesh.position.x = (box.min.x + box.max.x) / 2;
        bboxMesh.position.y = (box.min.y + box.max.y) / 2;
        bboxMesh.position.z = (box.min.z + box.max.z) / 2;
        return this;
      };
      this.redraw = function() {
        var arrow, cube, sphere;
        scene.remove(group);
        sphere = createMesh(new THREE.SphereGeometry(5, 10, 10));
        cube = createMesh(new THREE.BoxGeometry(6, 6, 6));
        sphere.position.set(controls.spherePosX, controls.spherePosY, controls.spherePosZ);
        cube.position.set(controls.cubePosX, controls.cubePosY, controls.cubePosZ);
        group = new THREE.Group();
        group.add(sphere);
        group.add(cube);
        scene.add(group);
        controls.positionBoundingBox();
        arrow = new THREE.ArrowHelper(new THREE.Vector3(0, 1, 0), group.position, 10, 0x0000ff);
        return scene.add(arrow);
      };
      return this;
    };
    // UI呈现
    gui = new dat.GUI();
    sphereFolder = gui.addFolder("sphere");
    sphereFolder.add(controls, "spherePosX", -20, 20).onChange(function(e) {
      sphere.position.x = e;
      return controls.positionBoundingBox();
    });
    sphereFolder.add(controls, "spherePosZ", -20, 20).onChange(function(e) {
      sphere.position.z = e;
      return controls.positionBoundingBox();
    });
    sphereFolder.add(controls, "spherePosY", -20, 20).onChange(function(e) {
      sphere.position.y = e;
      return controls.positionBoundingBox();
    });
    sphereFolder.add(controls, "sphereScale", 0, 3).onChange(function(e) {
      sphere.scale.set(e, e, e);
      return controls.positionBoundingBox();
    });
    cubeFolder = gui.addFolder("cube");
    cubeFolder.add(controls, "cubePosX", -20, 20).onChange(function(e) {
      cube.position.x = e;
      return controls.positionBoundingBox();
    });
    cubeFolder.add(controls, "cubePosZ", -20, 20).onChange(function(e) {
      cube.position.z = e;
      return controls.positionBoundingBox();
    });
    cubeFolder.add(controls, "cubePosY", -20, 20).onChange(function(e) {
      cube.position.y = e;
      return controls.positionBoundingBox();
    });
    cubeFolder.add(controls, "cubeScale", 0, 3).onChange(function(e) {
      cube.scale.set(e, e, e);
      return controls.positionBoundingBox();
    });
    cubeFolder = gui.addFolder("group");
    cubeFolder.add(controls, "groupPosX", -20, 20).onChange(function(e) {
      group.position.x = e;
      return controls.positionBoundingBox();
    });
    cubeFolder.add(controls, "groupPosZ", -20, 20).onChange(function(e) {
      group.position.z = e;
      return controls.positionBoundingBox();
    });
    cubeFolder.add(controls, "groupPosY", -20, 20).onChange(function(e) {
      group.position.y = e;
      return controls.positionBoundingBox();
    });
    cubeFolder.add(controls, "groupScale", 0, 3).onChange(function(e) {
      group.scale.set(e, e, e);
      return controls.positionBoundingBox();
    });
    gui.add(controls, "grouping");
    gui.add(controls, "rotate");
    controls.redraw();
    step = 0.03;
    // 实时渲染
    renderScene = function() {
      stats.update();
      if (controls.grouping && controls.rotate) {
        group.rotation.y += step;
      }
      if (controls.rotate && !controls.grouping) {
        sphere.rotation.y += step;
        cube.rotation.y += step;
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
