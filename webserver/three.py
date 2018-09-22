#/usr/bin/env/ python
#coding=utf8

import tornado.ioloop
import tornado.web
import httplib
import md5
import urllib
import random
from tornado.escape import json_decode
apps = [
    "1_3","1_5","1_6","1_8",

    "2_1","2_12","2_2","2_22","2_3","2_32",
    
    "3_2","3_22","3_23","3_24","3_31","3_32","3_33",
    
    "4_1","4_2","4_23","4_24","4_25",
    "4_31","4_32","4_33","4_41","4_42",
    
    "5_1","5_12","5_13","5_14","5_21","5_22",
    "5_23","5_24","5_25","5_26",

    "6_1","6_2","6_31","6_32","6_33","6_34",
    "6_41","6_51",

    "8_11","8_13","8_14","8_15","8_161","8_162",
    "8_2","8_31","8_32","8_33","8_34",

    "9_25",
]
# 临时接口
class ThreeJSHandler_learn(tornado.web.RequestHandler):
    def get(self):
        self.render("template/07-load-obj-mtl.html")

# coffee重写部分
class ThreeJSHandler_demo(tornado.web.RequestHandler):
    def get(self, app):
        if not app in apps:
            self.finish({"info":"no demos"})
            return
        demo_plus_arr = app.split("_")
        template_uri = "template/demo_%s.%s.html"%(demo_plus_arr[0],demo_plus_arr[1])
        self.render(template_uri)
