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
        self.render("template/05-hemisphere-light.html")

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


