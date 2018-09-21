#/usr/bin/env/ python
#coding=utf8
import os
import tornado.ioloop
import tornado.web
import httplib
import md5
import urllib
import random
from tornado.escape import json_decode
import three


settings ={
	"debug" : True,
	"static_path" : os.path.join(os.path.dirname(__file__),"static")
}

class MainHandler(tornado.web.RequestHandler):
    def get(self):
        self.write("Hello, w2sss44")

def make_app():
    return tornado.web.Application([
        # coffee重写例子
        (r"/threejs1_3",three.ThreeJSHandler_demo1_3),
        (r"/threejs1_5",three.ThreeJSHandler_demo1_5),
        (r"/threejs1_6",three.ThreeJSHandler_demo1_6),
        (r"/threejs1_8",three.ThreeJSHandler_demo1_8),
        (r"/threejs2_1",three.ThreeJSHandler_demo2_1),
        (r"/threejs2_12",three.ThreeJSHandler_demo2_12),
        (r"/threejs2_2",three.ThreeJSHandler_demo2_2),
        (r"/threejs2_22",three.ThreeJSHandler_demo2_22),
        (r"/threejs2_3",three.ThreeJSHandler_demo2_3),
        (r"/threejs2_32",three.ThreeJSHandler_demo2_32),
        (r"/threejs3_2",three.ThreeJSHandler_demo3_2),
        (r"/threejs3_22",three.ThreeJSHandler_demo3_22),
        (r"/threejs3_23",three.ThreeJSHandler_demo3_23),
        (r"/threejs3_24",three.ThreeJSHandler_demo3_24),
        (r"/threejs3_31",three.ThreeJSHandler_demo3_31),
        (r"/threejs3_32",three.ThreeJSHandler_demo3_32),
        (r"/threejs3_33",three.ThreeJSHandler_demo3_33),
        (r"/threejs4_1",three.ThreeJSHandler_demo4_1),
        (r"/threejs4_2",three.ThreeJSHandler_demo4_2),
        (r"/threejs4_23",three.ThreeJSHandler_demo4_23),
        (r"/threejs4_24",three.ThreeJSHandler_demo4_24),
        (r"/threejs4_25",three.ThreeJSHandler_demo4_25),
        (r"/threejs4_31",three.ThreeJSHandler_demo4_31),
        (r"/threejs4_32",three.ThreeJSHandler_demo4_32),
        (r"/threejs4_33",three.ThreeJSHandler_demo4_33),
        (r"/threejs4_41",three.ThreeJSHandler_demo4_41),
        (r"/threejs4_42",three.ThreeJSHandler_demo4_42),
        (r"/threejs5_1",three.ThreeJSHandler_demo5_1),
        (r"/threejs5_12",three.ThreeJSHandler_demo5_12),
        (r"/threejs5_13",three.ThreeJSHandler_demo5_13),
        (r"/threejs5_14",three.ThreeJSHandler_demo5_14),
        (r"/threejs5_21",three.ThreeJSHandler_demo5_21),
        (r"/threejs5_22",three.ThreeJSHandler_demo5_22),
        (r"/threejs5_23",three.ThreeJSHandler_demo5_23),
        (r"/threejs5_24",three.ThreeJSHandler_demo5_24),
        (r"/threejs5_25",three.ThreeJSHandler_demo5_25),
        (r"/threejs5_26",three.ThreeJSHandler_demo5_26),
        (r"/threejs6_1",three.ThreeJSHandler_demo6_1),
        (r"/threejs6_2",three.ThreeJSHandler_demo6_2),
        (r"/threejs6_31",three.ThreeJSHandler_demo6_31),
        (r"/threejs6_32",three.ThreeJSHandler_demo6_32),
        (r"/threejs6_33",three.ThreeJSHandler_demo6_33),
        (r"/threejs6_34",three.ThreeJSHandler_demo6_34),
        (r"/threejs6_41",three.ThreeJSHandler_demo6_41),
        (r"/threejs6_51",three.ThreeJSHandler_demo6_51),
        
        (r"/threejs8_11",three.ThreeJSHandler_demo8_11),
        (r"/threejs8_13",three.ThreeJSHandler_demo8_13),
        (r"/threejs8_14",three.ThreeJSHandler_demo8_14),
        


        (r"/threejs9_25",three.ThreeJSHandler_demo9_25),

        # 调用例子的临时接口
        (r"/threejs_learn",three.ThreeJSHandler_learn),
        (r"/", MainHandler),
    ],**settings)

if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()