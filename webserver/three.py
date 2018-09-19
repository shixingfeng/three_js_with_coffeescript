#/usr/bin/env/ python
#coding=utf8

import tornado.ioloop
import tornado.web
import httplib
import md5
import urllib
import random
from tornado.escape import json_decode

# 临时接口
class ThreeJSHandler_learn(tornado.web.RequestHandler):
    def get(self):
        self.render("template/01-basic-mesh-material.html")

# coffee重写部分

class ThreeJSHandler_demo1_3(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_1.3.html")

class ThreeJSHandler_demo1_5(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_1.5.html")

class ThreeJSHandler_demo1_6(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_1.6.html")

class ThreeJSHandler_demo1_8(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_1.8.html")

class ThreeJSHandler_demo2_1(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_2.1.html")

class ThreeJSHandler_demo2_12(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_2.12.html")

class ThreeJSHandler_demo2_2(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_2.2.html")

class ThreeJSHandler_demo2_22(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_2.22.html")

class ThreeJSHandler_demo2_3(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_2.3.html")

class ThreeJSHandler_demo2_32(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_2.32.html")

class ThreeJSHandler_demo3_2(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_3.2.html")

class ThreeJSHandler_demo3_22(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_3.22.html")

class ThreeJSHandler_demo3_23(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_3.23.html")

class ThreeJSHandler_demo3_24(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_3.24.html")

class ThreeJSHandler_demo3_31(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_3.31.html")

class ThreeJSHandler_demo3_32(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_3.32.html")

class ThreeJSHandler_demo3_33(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_3.33.html")

class ThreeJSHandler_demo4_1(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.1.html")

class ThreeJSHandler_demo4_2(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.2.html")
  

class ThreeJSHandler_demo4_23(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.23.html")


class ThreeJSHandler_demo4_24(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.24.html")

class ThreeJSHandler_demo4_25(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.25.html")

class ThreeJSHandler_demo4_31(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.31.html")

class ThreeJSHandler_demo4_32(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.32.html")

class ThreeJSHandler_demo4_33(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.33.html")

class ThreeJSHandler_demo4_41(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.41.html")

class ThreeJSHandler_demo4_42(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_4.42.html")

class ThreeJSHandler_demo5_1(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_5.1.html")

class ThreeJSHandler_demo5_12(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_5.12.html")




class ThreeJSHandler_demo9_25(tornado.web.RequestHandler):
    def get(self):
        self.render("template/demo_9.25.html")




