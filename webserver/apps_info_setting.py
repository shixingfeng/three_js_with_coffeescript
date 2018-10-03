#/usr/bin/env/ python
#coding=utf8
apps_info = {
    "01_41":{
        "title":u"demo_01_41 第一个场景",
        "description":u"本例中，渲染器中setClearColorHex()已经被移除，用setClearColor()代替",
        "image":"/static/images/demo/demo_01_41.png",
        "schedule":u"已完成"
    },

    "01_51":{
        "title":u"demo_01_51 材质、光线、阴影",
        "description":u"在渲染器中加入阴影选项，对性能有很大影响",
        "image":"/static/images/demo/demo_01_51.png",
        "schedule":u"已完成"
    },

    "01_61":{
        "title":u"demo_01_61 材质、灯光、动画",
        "description":u"引入动画 requestAnimationFrame",
        "image":"/static/images/demo/demo_01_61.png",
        "schedule":u"已完成"
    },

    "01_71":{
        "title":u"demo_01_71 控制条",
        "description":u"引入动作条文件 dat.gui.js",
        "image":"/static/images/demo/demo_01_71.png",
        "schedule":u"已完成"
    },

    "01_81":{
        "title":u"demo_01_81 屏幕自适应",
        "description":u"onResize 方法，window.addeventListener方法监听",
        "image":"/static/images/demo/demo_01_81.png",
        "schedule":u"已完成"
    },

    "02_11":{
        "title":u"demo_02_11 场景基本功能",
        "description":u"dat.gui中关于webkitrequestframe命令有错误，修改为requesframe即可解决报错",
        "image":"/static/images/demo/demo_02_11.png",
        "schedule":u"已完成"
    },

    "02_12":{
        "title":u"demo_02_12 场景雾化效果",
        "description":u"雾化效果，线性(fog)和非线性增长(fogExp2)",
        "image":"/static/images/demo/demo_02_12.png",
        "schedule":u"已完成"
    },

    "02_13":{
        "title":u"demo_02_13 材质覆盖",
        "description":u"overrideMaterial属性,为场景中所有物体指定材质",
        "image":"/static/images/demo/demo_02_13.png",
        "schedule":u"已完成"
    },

    "02_211":{
        "title":u"demo_02_211 标准几何体",
        "description":u"展示threejs中标准几何体",
        "image":"/static/images/demo/demo_02_211.png",
        "schedule":u"已完成"
    },

    "02_212":{
        "title":u"demo_02_212 修改几何顶点",
        "description":u"computeFaceNormals绘制图形,控制8个顶点在xyz三轴上变形,clone方法复制图像",
        "image":"/static/images/demo/demo_02_212.png",
        "schedule":u"已完成"
    },

    "02_22":{
        "title":u"demo_02_22 物体属性",
        "description":u"属性：缩放、移动、旋转、相对位置、是否可见",
        "image":"/static/images/demo/demo_02_22.png",
        "schedule":u"已完成"
    },

    "02_31":{
        "title":u"demo_02_31 正交投影和透视投影",
        "description":u"PerspectiveCamera透视投影，最自然的视图、OrthographicCamera正交投影，物体尺寸不受远近影响",
        "image":"/static/images/demo/demo_02_31.png",
        "schedule":u"已完成"
    },

    "02_32":{
        "title":u"demo_02_32 跟随物体移动摄像头",
        "description":u"这是假的物体移动，只是控制摄像头跟随点在移动",
        "image":"/static/images/demo/demo_02_32.png",
        "schedule":u"已完成"
    },
    "03_21":{
        "title":u"demo_03_21 AmbientLight",
        "description":u"ambientLight没有阴影，通常和其他光源一起用弱化阴影",
        "image":"/static/images/demo/demo_03_21.png",
        "schedule":u"已完成"
    },
    "03_22":{
        "title":u"demo_03_22 PointLight",
        "description":u"点光源朝所有方向发光",
        "image":"/static/images/demo/demo_03_22.png",
        "schedule":u"已完成"
    },
    "03_23":{
        "title":u"demo_03_23 SpotLight",
        "description":u"聚光源朝一个方向发光，类似手电筒",
        "image":"/static/images/demo/demo_03_23.png",
        "schedule":u"已完成"
    },
    "03_24":{
        "title":u"demo_03_24 DirectionaLight",
        "description":u"平行光，类似太阳光",
        "image":"/static/images/demo/demo_03_24.png",
        "schedule":u"已完成"
    },
    "03_31":{
        "title":u"demo_03_31 HemisphereLight",
        "description":u"提供一种户外光自然光的简单解决方案",
        "image":"/static/images/demo/demo_03_31.png",
        "schedule":u"已完成"
    },
    "03_32":{
        "title":u"demo_03_32 AreaLight",
        "description":u"发光区域块，可以模拟窗口光",
        "image":"/static/images/demo/demo_03_32.png",
        "schedule":u"已完成"
    },
    "03_33":{
        "title":u"demo_03_33 lensflares",
        "description":u"镜头光晕，模拟散射类的效果",
        "image":"/static/images/demo/demo_03_33.png",
        "schedule":u"已完成"
    },
    "04_21":{
        "title":u"demo_04_21 MeshBasicMaterial",
        "description":u"简单的材质，不考虑场景中的光照影响",
        "image":"/static/images/demo/demo_04_21.png",
        "schedule":u"已完成"
    },
    "04_22":{
        "title":u"demo_04_22 MeshDepthMaterial",
        "description":u"物体的外观由物体到摄像机的距离决定，使用overideMaterial属性可以渲染全局物体",
        "image":"/static/images/demo/demo_04_22.png",
        "schedule":u"已完成"
    },
    "04_23":{
        "title":u"demo_04_23 联合材质",
        "description":u"使用联合材质组合出自己想要的效果(亮度和深度)",
        "image":"/static/images/demo/demo_04_23.png",
        "schedule":u"已完成"
    },
    "04_24":{
        "title":u"demo_04_24 MeshNormalMaterial",
        "description":u"这种材质使用功能强大的法向量来计渲染颜色、阴影、亮度等，法向量提供外部接口丰富的信息来处理数据",
        "image":"/static/images/demo/demo_04_24.png",
        "schedule":u"已完成"
    },
    "04_25":{
        "title":u"demo_04_25 MeshFaceMaterial",
        "description":u"这种材质看起来像是一个材质容器，为每一个面指定不同的材质，用数组存储",
        "image":"/static/images/demo/demo_04_25.png",
        "schedule":u"已完成"
    },
    "04_31":{
        "title":u"demo_04_31 MeshLambertMaterial",
        "description":u"用来创建暗淡的并不光亮的表面，对光源产生反应",
        "image":"/static/images/demo/demo_04_31.png",
        "schedule":u"已完成"
    },
    "04_32":{
        "title":u"demo_04_32 MeshPhongMaterial",
        "description":u"创建一种光亮的材质，可用属性和MeshLambertMaterial基本一致",
        "image":"/static/images/demo/demo_04_32.png",
        "schedule":u"已完成"
    },
    "04_33":{
        "title":u"demo_04_33 ShaderMaterial",
        "description":u"最通用、最复杂的一个材质之一，通过它定制自己的着色器，直接在webgl中运行，覆盖或者修改three库中的默认值",
        "image":"/static/images/demo/demo_04_33.png",
        "schedule":u"已完成"
    },
    "04_41":{
        "title":u"demo_04_41 LineBasicMaterial",
        "description":u"基本线条效果，为线条指定线宽，线色等属性",
        "image":"/static/images/demo/demo_04_41.png",
        "schedule":u"已完成"
    },
    "04_42":{
        "title":u"demo_04_42 LineDashedMaterial",
        "description":u"有与LineBasicMaterial一样的属性，还增添虚线长，虚线宽等",
        "image":"/static/images/demo/demo_04_42.png",
        "schedule":u"已完成"
    },

    "05_111":{
        "title":u"demo_05_111 THREE.PlaneGeometry",
        "description":u"创建一个二维矩形",
        "image":"/static/images/demo/demo_05_111.png",
        "schedule":u"已完成"
    },
    
    "05_112":{
        "title":u"demo_05_112 THREE.CircleGeometry",
        "description":u"创建一个二维圆形",
        "image":"/static/images/demo/demo_05_112.png",
        "schedule":u"已完成"
    },
    "05_113":{
        "title":u"demo_05_113 THREE.RingGeometry",
        "description":u"类似二维圆，可在中心点定义一个孔",
        "image":"/static/images/demo/demo_05_113.png",
        "schedule":u"已完成"
    },
    "05_114":{
        "title":u"demo_05_114 THREE.ShapeGeometry",
        "description":u"创建自定义的二维图形用这个方法",
        "image":"/static/images/demo/demo_05_114.png",
        "schedule":u"已完成"
    },
    "05_121":{
    "title":u"demo_05_121 THREE.BoxGeometry",
        "description":u"简单的三维几何体",
        "image":"/static/images/demo/demo_05_121.png",
        "schedule":u"已完成"
    },
    "05_122":{
        "title":u"demo_05_122 THREE.SphereGeometry",
        "description":u"三维球体",
        "image":"/static/images/demo/demo_05_122.png",
        "schedule":u"已完成"
    },
    "05_123":{
        "title":u"demo_05_123 THREE.CylinderGeometry",
        "description":u"三维圆柱体",
        "image":"/static/images/demo/demo_05_123.png",
        "schedule":u"已完成"
    },
    "05_124":{
        "title":u"demo_05_124 THREE.ToursGeometry",
        "description":u"圆环，看起来像甜甜圈",
        "image":"/static/images/demo/demo_05_124.png",
        "schedule":u"已完成"
    },
    "05_125":{
        "title":u"demo_05_125 THREE.TorusKnotGeometry",
        "description":u"环状扭结",
        "image":"/static/images/demo/demo_05_125.png",
        "schedule":u"已完成"
    },
    "05_126":{
        "title":u"demo_05_126 THREE.PolyhedronGeometry",
        "description":u"三角形多面体创建，IcosahedronGeometry(20个三角形面的多面体)，tetrahedronGeometry（正四面体），octahedron(八面体)，dodecahedron(十二面体)",
        "image":"/static/images/demo/demo_05_126.png",
        "schedule":u"已完成"
    },

    "06_11":{
        "title":u"demo_06_11 ConvexGeometry",
        "description":u"凸点，例子将这些凸起来的点连起来",
        "image":"/static/images/demo/demo_06_11.png",
        "schedule":u"已完成"
    },

    "06_21":{
        "title":u"demo_06_21 LatheGeometry",
        "description":u"样条曲线，沿一条光滑的曲线创建图形",
        "image":"/static/images/demo/demo_06_21.png",
        "schedule":u"已完成"
    },

    "06_31":{
        "title":u"demo_06_31 ExtrudeGeometry",
        "description":u"从一个二维图形创建出一个三维图形",
        "image":"/static/images/demo/demo_06_31.png",
        "schedule":u"已完成"
    },

    "06_32":{
        "title":u"demo_06_32 TubeGeometry",
        "description":u"沿着一条三维的样条曲线拉伸出一根管",
        "image":"/static/images/demo/demo_06_32.png",
        "schedule":u"已完成"
    },
    "06_33":{
        "title":u"demo_06_33 svg拉伸",
        "description":u"使用ExtrudeGeometry拉伸一个蝙蝠侠标志",
        "image":"/static/images/demo/demo_06_33.png",
        "schedule":u"已完成"
    },
    "06_34":{
        "title":u"demo_06_34 ParametricGeometry",
        "description":u"利用几何体公式创建几何体",
        "image":"/static/images/demo/demo_06_34.png",
        "schedule":u"已完成"
    },
    "06_41":{
        "title":u"demo_06_41 TextGeometry",
        "description":u"渲染文本",
        "image":"/static/images/demo/demo_06_41.png",
        "schedule":u"已完成"
    },
    "06_51":{
        "title":u"demo_06_51 subtract函数",
        "description":u"subtract、intersect、union函数基于BSP文件提供的方法调用，非常方便控制物体的位置，相交，重合等",
        "image":"/static/images/demo/demo_06_51.png",
        "schedule":u"已完成"
    },

    "07_11":{
        "title":u"demo_07_11 particles",
        "description":u"渲染100个粒子，包含100个对象",
        "image":"/static/images/demo/demo_07_11.png",
        "schedule":u"已完成"
    },

    "07_12":{
        "title":u"demo_07_12 PointCloud",
        "description":u"渲染一个对象，包含多个粒子",
        "image":"/static/images/demo/demo_07_12.png",
        "schedule":u"已完成"
    },

    "07_21":{
        "title":u"demo_07_21 ponitCloud、pointCloudMaterial",
        "description":u"粒子云和粒子的材质",
        "image":"/static/images/demo/demo_07_21.png",
        "schedule":u"已完成"
    },

    "07_31":{
        "title":u"demo_07_31 spriteCanvasRenderer",
        "description":u"利用spriteCanvasRenderer方法把画布作为粒子纹理",
        "image":"/static/images/demo/demo_07_31.png",
        "schedule":u"已完成"
    },

    "07_32":{
        "title":u"demo_07_32  在webGLRenderer中使用HTML5画布",
        "description":u"用sprite和spriteMaterial 中的map属性指定画布纹理",
        "image":"/static/images/demo/demo_07_32.png",
        "schedule":u"已完成"
    },

    "07_33":{
        "title":u"demo_07_33 画布纹理",
        "description":u"另外一份不同的画布纹理",
        "image":"/static/images/demo/demo_07_33.png",
        "schedule":u"已完成"
    },

    "07_41":{
        "title":u"demo_07_41 rain",
        "description":u"引入图片纹理，制造雨滴效果",
        "image":"/static/images/demo/demo_07_41.png",
        "schedule":u"已完成"
    },

    "07_42":{
        "title":u"demo_07_42 snow",
        "description":u"引入图片纹理，制造下雪的效果",
        "image":"/static/images/demo/demo_07_42.png",
        "schedule":u"已完成"
    },

    "07_51":{
        "title":u"demo_07_51 精灵贴图",
        "description":u"平面贴图",
        "image":"/static/images/demo/demo_07_51.png",
        "schedule":u"已完成"
    },

    "07_52":{
        "title":u"demo_07_52 精灵贴图2",
        "description":u"带有远近空间的贴图",
        "image":"/static/images/demo/demo_07_52.png",
        "schedule":u"已完成"
    },

    "07_61":{
        "title":u"demo_07_61 环状扭结渲染成点云",
        "description":u"镜头光晕，模拟散射类的效果",
        "image":"/static/images/demo/demo_07_61.png",
        "schedule":u"已完成"
    },

    "08_11":{
        "title":u"demo_08_11 对象组合，",
        "description":u"染一个中心点将不同对象组合到一起",
        "image":"/static/images/demo/demo_08_11.png",
        "schedule":u"已完成"
    },


    "08_12":{
        "title":u"demo_08_12 merge",
        "description":u"网格组合，保证图像同时，尽量不丢失性能，场景中网格数量有限制",
        "image":"/static/images/demo/demo_08_12.png",
        "schedule":u"已完成"
    },

    "08_13":{
        "title":u"demo_08_13 Save & Load",
        "description":u"保存和载入场景中的对象",
        "image":"/static/images/demo/demo_08_13.png",
        "schedule":u"已完成"
    },

    "08_14":{
        "title":u"demo_08_14 Load and save scene",
        "description":u"保存和载入场景",
        "image":"/static/images/demo/demo_08_14.png",
        "schedule":u"已完成"
    },

    "08_15":{
        "title":u"demo_08_15 Load blender model",
        "description":u"载入blender模型，以JSON格式",
        "image":"/static/images/demo/demo_08_15.png",
        "schedule":u"已完成"
    },

    "08_1611":{
        "title":u"demo_08_1611 Load OBJ model",
        "description":u"载入OBJ模型",
        "image":"/static/images/demo/demo_08_1611.png",
        "schedule":u"已完成"
    },

    "08_1612":{
        "title":u"demo_08_1612 Load OBJ and MTL",
        "description":u"OBJ和MTL模型一同载入",
        "image":"/static/images/demo/demo_08_1612.png",
        "schedule":u"已完成"
    },

    "08_1613":{
        "title":u"demo_08_1613 Load collada model",
        "description":u"载入collada模型",
        "image":"/static/images/demo/demo_08_1613.png",
        "schedule":u"已完成"
    },

    "08_1631":{
        "title":u"demo_08_1631 Load stl model",
        "description":u"stl格式模型",
        "image":"/static/images/demo/demo_08_1631.png",
        "schedule":u"已完成"
    },

    "08_1632":{
        "title":u"demo_08_1632 ctm",
        "description":u"ctm格式模型",
        "image":"/static/images/demo/demo_08_1632.png",
        "schedule":u"已完成"
    },

    "08_1633":{
        "title":u"demo_08_1633 vtk",
        "description":u"vtk格式模型",
        "image":"/static/images/demo/demo_08_1633.png",
        "schedule":u"已完成"
    },

    "08_1634":{
        "title":u"demo_08_1634 awd",
        "description":u"awd格式模型",
        "image":"/static/images/demo/demo_08_1634.png",
        "schedule":u"已完成"
    },

    "08_1635":{
        "title":u"demo_08_1635 assimp",
        "description":u"assimp格式模型",
        "image":"/static/images/demo/demo_08_1635.png",
        "schedule":u"已完成"
    },

    "08_1636":{
        "title":u"demo_08_1636 VRML",
        "description":u"VRML格式模型",
        "image":"/static/images/demo/demo_08_1636.png",
        "schedule":u"已完成"
    },

    "08_1637":{
        "title":u"demo_08_1637 babylon",
        "description":u"babylon格式，是加载一个完整的场景，包括光源",
        "image":"/static/images/demo/demo_08_1637.png",
        "schedule":u"已完成"
    },

    "08_1641":{
        "title":u"demo_08_1638 pdb",
        "description":u"蛋白质模型",
        "image":"/static/images/demo/demo_08_1641.png",
        "schedule":u"已完成"
    },

    "08_1651":{
        "title":u"demo_08_1651 ply",
        "description":u"好看的汽车粒子模型",
        "image":"/static/images/demo/demo_08_1651.png",
        "schedule":u"已完成"
    },


    "09_11":{
        "title":u"demo_09_11 Basic animations",
        "description":u"简单的动画效果",
        "image":"/static/images/demo/demo_09_11.png",
        "schedule":u"已完成"
    },


    "09_12":{
        "title":u"demo_09_12 选择场景中的对象",
        "description":u"使用projector 和 raycaster 检测鼠标是否点击了场景中的对象",
        "image":"/static/images/demo/demo_09_12.png",
        "schedule":u"已完成"
    },


    "09_13":{
        "title":u"demo_09_13 补间动画",
        "description":u"镜头光晕，模拟散射类的效果",
        "image":"/static/images/demo/demo_09_13.png",
        "schedule":u"已完成"
    },


    "09_21":{
        "title":u"demo_09_21 trackballControls",
        "description":u"轨球控制器",
        "image":"/static/images/demo/demo_09_21.png",
        "schedule":u"已完成"
    },


    "09_22":{
        "title":u"demo_09_22 flycontrols",
        "description":u"飞行控制器",
        "image":"/static/images/demo/demo_09_22.png",
        "schedule":u"已完成"
    },


    "09_23":{
        "title":u"demo_09_23 rollcontrols",
        "description":u"翻滚控制器",
        "image":"/static/images/demo/demo_09_23.png",
        "schedule":u"已完成"
    },


    "09_24":{
        "title":u"demo_09_24 FirstPersonControls",
        "description":u"第一视角控制器",
        "image":"/static/images/demo/demo_09_24.png",
        "schedule":u"已完成"
    },


    "09_25":{
        "title":u"demo_09_25 orbitcontrols",
        "description":u"轨道控制器",
        "image":"/static/images/demo/demo_09_25.png",
        "schedule":u"已完成"
    },


    "09_31":{
        "title":u"demo_09_31 MorphAnimlMesh",
        "description":u"变形动画",
        "image":"/static/images/demo/demo_09_31.png",
        "schedule":u"已完成"
    },


    "09_32":{
        "title":u"demo_09_32 MorphAnimlMesh",
        "description":u"创建一个可编辑的方块聊体",
        "image":"/static/images/demo/demo_09_32.png",
        "schedule":u"已完成"
    },


    "09_33":{
        "title":u"demo_09_33 blender model",
        "description":u"导入外部骨骼动画",
        "image":"/static/images/demo/demo_09_33.png",
        "schedule":u"已完成"
    },

    "09_41":{
        "title":u"demo_09_41 blender model",
        "description":u"骨骼动画2",
        "image":"/static/images/demo/demo_09_41.png",
        "schedule":u"已完成"
    },

    "09_42":{
        "title":u"demo_09_42 collada模型",
        "description":u"加载collada模型",
        "image":"/static/images/demo/demo_09_42.png",
        "schedule":u"已完成"
    },

    "09_43":{
        "title":u"demo_09_43 MD2",
        "description":u"雷神之锤模型",
        "image":"/static/images/demo/demo_09_43.png",
        "schedule":u"已完成"
    },


    "10_111":{
        "title":u"demo_10_111 Basic textures dds",
        "description":u"加载基本纹理dds格式",
        "image":"/static/images/demo/demo_10_111.png",
        "schedule":u"已完成"
    },

    "10_112":{
        "title":u"demo_10_112 textures PVR",
        "description":u"pvr格式，并非所有webgl都支持pvr格式",
        "image":"/static/images/demo/demo_10_112.png",
        "schedule":u"已完成"
    },

    "10_113":{
        "title":u"demo_10_113 textures TGA",
        "description":u"tga格式",
        "image":"/static/images/demo/demo_10_113.png",
        "schedule":u"已完成"
    },

    "10_12":{
        "title":u"demo_10_12 bump-map",
        "description":u"凹凸贴图",
        "image":"/static/images/demo/demo_10_12.png",
        "schedule":u"已完成"
    },

    "10_13":{
        "title":u"demo_10_13 normal-map",
        "description":u"法向量贴图，更加细致地凹凸和皱褶",
        "image":"/static/images/demo/demo_10_13.png",
        "schedule":u"已完成"
    },

    "10_14":{
        "title":u"demo_10_14 light-map",
        "description":u"光照贴图",
        "image":"/static/images/demo/demo_10_14.png",
        "schedule":u"已完成"
    },

    "10_15":{
        "title":u"demo_10_15 env-map",
        "description":u"环境贴图创建反光效果",
        "image":"/static/images/demo/demo_10_15.png",
        "schedule":u"已完成"
    },

    "10_16":{
        "title":u"demo_10_16 specular-map",
        "description":u"高光贴图",
        "image":"/static/images/demo/demo_10_16.png",
        "schedule":u"已完成"
    },

    "10_211":{
        "title":u"demo_10_211 uv-mapping-manual",
        "description":u"自定义uv映射",
        "image":"/static/images/demo/demo_10_211.png",
        "schedule":u"已完成"
    },

    "10_212":{
        "title":u"demo_10_212 mapping-manual",
        "description":u"不同uv面效果",
        "image":"/static/images/demo/demo_10_212.png",
        "schedule":u"已完成"
    },

    "10_22":{
        "title":u"demo_10_22 repeat-wrapping",
        "description":u"重复纹理",
        "image":"/static/images/demo/demo_10_22.png",
        "schedule":u"已完成"
    },

    "10_231":{
        "title":u"demo_10_231 canvas-texture",
        "description":u"将画布作为纹理",
        "image":"/static/images/demo/demo_10_231.png",
        "schedule":u"已完成"
    },

    "10_232":{
        "title":u"demo_10_232 canvas-texture-bumpmap",
        "description":u"将画布应用为凹凸贴图",
        "image":"/static/images/demo/demo_10_232.png",
        "schedule":u"已完成"
    },

    "10_241":{
        "title":u"demo_10_241 video-texture",
        "description":u"将视频输出作为纹理",
        "image":"/static/images/demo/demo_10_241.png",
        "schedule":u"已完成"
    },


    "11_11":{
        "title":u"demo_11_11 effectComposer",
        "description":u"自定义后期效果，添加电视栅格效果",
        "image":"/static/images/demo/demo_11_11.png",
        "schedule":u"已完成"
    },

    "11_12":{
        "title":u"demo_11_12 Simple passes",
        "description":u"在一个屏幕上输出四个不同的渲染结果",
        "image":"/static/images/demo/demo_11_12.png",
        "schedule":u"已完成"
    },

    "11_13":{
        "title":u"demo_11_13 glitchpass",
        "description":u"模拟一种电脉冲效果",
        "image":"/static/images/demo/demo_11_13.png",
        "schedule":u"已完成"
    },

    "11_21":{
        "title":u"demo_11_21 masks",
        "description":u"模拟星球的空间感",
        "image":"/static/images/demo/demo_11_21.png",
        "schedule":u"已完成"
    },

    "11_231":{
        "title":u"demo_11_231 shaderpass-simple",
        "description":u"自定义着色器",
        "image":"/static/images/demo/demo_11_231.png",
        "schedule":u"已完成"
    },
    "11_232":{
        "title":u"demo_11_232 shaderpass-blur",
        "description":u"模糊着色器",
        "image":"/static/images/demo/demo_11_232.png",
        "schedule":u"已完成"
    },
    "11_233":{
        "title":u"demo_11_233 TriangleShader",
        "description":u"模糊着色器，horizontalTiltShiftShader,VerticalTiltSHiftshader处理，只模糊一个小区域",
        "image":"/static/images/demo/demo_11_233.png",
        "schedule":u"已完成"
    },
    "11_31":{
        "title":u"demo_11_31 custom-shader",
        "description":"自定义灰度图着色器，两个组间：顶点着色器(vertexShader)和片段着色器(fragmentShader)",
        "image":"/static/images/demo/demo_11_31.png",
        "schedule":u"已完成"
    },

    "12_11":{
        "title":u"demo_12_11 physijs",
        "description":u"模拟多米诺骨牌的物理效果",
        "image":"/static/images/demo/demo_12_11.png",
        "schedule":u"已完成"
    },
    "12_21":{
        "title":u"demo_12_21 properties",
        "description":u"物体具有摩擦和能量属性，resitution(数值越大，弹性越大). friction",
        "image":"/static/images/demo/demo_12_21.png",
        "schedule":u"已完成"
    },
    "12_31":{
        "title":u"demo_12_31 shapes",
        "description":u"各种不同形状的物体在一个场中的碰撞",
        "image":"/static/images/demo/demo_12_31.png",
        "schedule":u"已完成"
    },
    "12_41":{
        "title":u"demo_12_41 constraints",
        "description":u"约束对象在两点间移动",
        "image":"/static/images/demo/demo_12_41.png",
        "schedule":u"已完成"
    },
    "12_51":{
        "title":u"demo_12_51 car",
        "description":u"一辆可以控制方向的模型小车",
        "image":"/static/images/demo/demo_12_51.png",
        "schedule":u"已完成"
    },
    "12_61":{
        "title":u"demo_12_61 voice",
        "description":u"往场景中添加声音",
        "image":"/static/images/demo/demo_12_61.png",
        "schedule":u"未完成"
    },


  

}
