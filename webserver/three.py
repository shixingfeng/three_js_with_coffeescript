#/usr/bin/env/ python
#coding=utf8
import tornado.ioloop
import tornado.web
import httplib
import md5
import urllib
import random
import time
from tornado.escape import json_decode
from apps_info_setting import apps_info
apps = [
    "01_41","01_51","01_61","01_71","01_81",

    "02_11","02_12","02_13","02_211","02_212",
    "02_22","02_31","02_32",
    
    "03_21","03_22","03_23","03_24","03_31","03_32","03_33",
    
    "04_21","04_22","04_23","04_24","04_25",
    "04_31","04_32","04_33","04_41","04_42",
    
    "05_111","05_112","05_113","05_114","05_121","05_122",
    "05_123","05_124","05_125","05_126",

    "06_11","06_21","06_31","06_32","06_33","06_34",
    "06_41","06_51",

    "07_11","07_12","07_21","07_31","07_32","07_33",
    "07_41","07_42","07_51","07_52","07_61",


    "08_11","08_12","08_13","08_14","08_15","08_1611","08_1612",
    "08_1613","08_1631","08_1632","08_1633","08_1634","08_1635",
    "08_1636","08_1637","08_1641","08_1651",


    "09_11","09_12","09_13","09_21","09_22","09_23",
    "09_24","09_25","09_31","09_32","09_33","09_41",
    "09_42","09_43",

    "10_111","10_112","10_113","10_12","10_13",
    "10_14","10_15","10_16","10_211","10_212",
    "10_22","10_231","10_232","10_241",

    "11_11","11_12","11_13","11_21","11_231",
    "11_232","11_233","11_31",

    "12_11","12_21","12_31","12_41","12_51","12_61",
]

class ThreeJSListHandler(tornado.web.RequestHandler):
    def get(self):
        self.apps_info = apps_info
        self.apps = apps
        self.render("template/threejs_list.html")

# 临时接口
class ThreeJSHandler_learn(tornado.web.RequestHandler):
    def get(self):
        self.js_time = time.time()
        self.render("template/shoes.html")

# coffee重写部分
class ThreeJSHandler_demo(tornado.web.RequestHandler):
    def get(self, app):
        if not app in apps:
            self.finish({"info":"no demos"})
            return
        demo_plus_arr = app.split("_")
        self.js_time = time.time()
        template_uri = "template/demo_%s_%s.html"%(demo_plus_arr[0],demo_plus_arr[1])
        self.render(template_uri)
