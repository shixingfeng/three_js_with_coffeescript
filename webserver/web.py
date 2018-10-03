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
        # 调用例子的临时接口
        (r"/threejs_learn",three.ThreeJSHandler_learn),
        (r"/threejs_list",three.ThreeJSListHandler),
        # coffee重写例子
        (r"/threejs(.*)", three.ThreeJSHandler_demo),
        (r"/", MainHandler),
    ],**settings)

if __name__ == "__main__":
    app = make_app()
    app.listen(8888)
    tornado.ioloop.IOLoop.current().start()