// { "framework": "Vue"} 

/******/ (function(modules) { // webpackBootstrap
/******/ 	// The module cache
/******/ 	var installedModules = {};
/******/
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/
/******/ 		// Check if module is in cache
/******/ 		if(installedModules[moduleId]) {
/******/ 			return installedModules[moduleId].exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = installedModules[moduleId] = {
/******/ 			i: moduleId,
/******/ 			l: false,
/******/ 			exports: {}
/******/ 		};
/******/
/******/ 		// Execute the module function
/******/ 		modules[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/
/******/ 		// Flag the module as loaded
/******/ 		module.l = true;
/******/
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/
/******/
/******/ 	// expose the modules object (__webpack_modules__)
/******/ 	__webpack_require__.m = modules;
/******/
/******/ 	// expose the module cache
/******/ 	__webpack_require__.c = installedModules;
/******/
/******/ 	// define getter function for harmony exports
/******/ 	__webpack_require__.d = function(exports, name, getter) {
/******/ 		if(!__webpack_require__.o(exports, name)) {
/******/ 			Object.defineProperty(exports, name, {
/******/ 				configurable: false,
/******/ 				enumerable: true,
/******/ 				get: getter
/******/ 			});
/******/ 		}
/******/ 	};
/******/
/******/ 	// getDefaultExport function for compatibility with non-harmony modules
/******/ 	__webpack_require__.n = function(module) {
/******/ 		var getter = module && module.__esModule ?
/******/ 			function getDefault() { return module['default']; } :
/******/ 			function getModuleExports() { return module; };
/******/ 		__webpack_require__.d(getter, 'a', getter);
/******/ 		return getter;
/******/ 	};
/******/
/******/ 	// Object.prototype.hasOwnProperty.call
/******/ 	__webpack_require__.o = function(object, property) { return Object.prototype.hasOwnProperty.call(object, property); };
/******/
/******/ 	// __webpack_public_path__
/******/ 	__webpack_require__.p = "";
/******/
/******/ 	// Load entry module and return exports
/******/ 	return __webpack_require__(__webpack_require__.s = 148);
/******/ })
/************************************************************************/
/******/ ({

/***/ 1:
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(2)
)

/* script */
__vue_exports__ = __webpack_require__(3)

/* template */
var __vue_template__ = __webpack_require__(4)
__vue_options__ = __vue_exports__ = __vue_exports__ || {}
if (
  typeof __vue_exports__.default === "object" ||
  typeof __vue_exports__.default === "function"
) {
if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
__vue_options__ = __vue_exports__ = __vue_exports__.default
}
if (typeof __vue_options__ === "function") {
  __vue_options__ = __vue_options__.options
}
__vue_options__.__file = "/Users/zzzl/Documents/APP项目/direct/src/components/NavBar.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-4295d220"
__vue_options__.style = __vue_options__.style || {}
__vue_styles__.forEach(function (module) {
  for (var name in module) {
    __vue_options__.style[name] = module[name]
  }
})
if (typeof __register_static_styles__ === "function") {
  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
}

module.exports = __vue_exports__


/***/ }),

/***/ 148:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _WIFIViewController = __webpack_require__(149);

var _WIFIViewController2 = _interopRequireDefault(_WIFIViewController);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

_WIFIViewController2.default.el = '#root';
new Vue(_WIFIViewController2.default);

/***/ }),

/***/ 149:
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(150)
)

/* script */
__vue_exports__ = __webpack_require__(151)

/* template */
var __vue_template__ = __webpack_require__(152)
__vue_options__ = __vue_exports__ = __vue_exports__ || {}
if (
  typeof __vue_exports__.default === "object" ||
  typeof __vue_exports__.default === "function"
) {
if (Object.keys(__vue_exports__).some(function (key) { return key !== "default" && key !== "__esModule" })) {console.error("named exports are not supported in *.vue files.")}
__vue_options__ = __vue_exports__ = __vue_exports__.default
}
if (typeof __vue_options__ === "function") {
  __vue_options__ = __vue_options__.options
}
__vue_options__.__file = "/Users/zzzl/Documents/APP项目/direct/src/WIFIViewController.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-1a257b2f"
__vue_options__.style = __vue_options__.style || {}
__vue_styles__.forEach(function (module) {
  for (var name in module) {
    __vue_options__.style[name] = module[name]
  }
})
if (typeof __register_static_styles__ === "function") {
  __register_static_styles__(__vue_options__._scopeId, __vue_styles__)
}

module.exports = __vue_exports__


/***/ }),

/***/ 150:
/***/ (function(module, exports) {

module.exports = {
  "inputSuper": {
    "marginTop": "40",
    "marginLeft": "40",
    "marginRight": "40"
  },
  "inputText": {
    "marginTop": "40"
  },
  "input": {
    "marginTop": "40",
    "width": "500",
    "height": "44"
  },
  "defaultFont": {
    "fontSize": "40",
    "color": "#000000"
  }
}

/***/ }),

/***/ 151:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _NavBar = __webpack_require__(1);

var _NavBar2 = _interopRequireDefault(_NavBar);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var easyLink = weex.requireModule('WIFILink'); //
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

var modal = weex.requireModule('modal');
// const hud = weex.requireModule('HUD')

exports.default = {
  name: 'WIFIViewController',
  components: { NavBar: _NavBar2.default },
  data: function data() {
    return {
      iphoneSSID: '',
      pwd: ''
    };
  },
  created: function created() {
    var self = this;
    easyLink.start(function (e) {
      self.iphoneSSID = e; // 'TP-LINK_E78B'
    });
  },
  destroyed: function destroyed() {
    easyLink.stop();
  },

  methods: {
    pwdInput: function pwdInput(e) {
      this.pwd = e.value;
    },
    viewappear: function viewappear() {},
    connect: function connect() {
      this.$refs.pwd.blur();

      if (this.iphoneSSID.length === 0) {
        modal.toast({
          message: '您的手机尚未连接无线网',
          duration: 1
        });
        return;
      }

      if (this.pwd.length === 0) {
        modal.toast({
          message: '请输入密码',
          duration: 1
        });
        return;
      }

      var param = { password: this.pwd, _ssid: this.iphoneSSID
        // hud.show()
      };modal.toast({
        message: '连接中请稍等……',
        duration: 1
      });
      easyLink.connect(param, function (rsp) {
        // hud.hide()
        modal.toast({
          message: rsp.msg,
          duration: 0.3
        });
      });
    }
  }
};

/***/ }),

/***/ 152:
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    on: {
      "viewappear": _vm.viewappear
    }
  }, [_c('nav-bar', {
    attrs: {
      "title": "无线网络",
      "left": "返回",
      "right": "连接"
    },
    on: {
      "rightButtonClicked": _vm.connect
    }
  }), _c('div', {
    staticClass: ["inputSuper"]
  }, [_c('div', {
    staticStyle: {
      flexDirection: "row"
    }
  }, [_c('text', {
    staticClass: ["inputText", "defaultFont"]
  }, [_vm._v("名称：")]), _c('text', {
    staticClass: ["input", "defaultFont"]
  }, [_vm._v(_vm._s(_vm.iphoneSSID))])]), _c('div', {
    staticStyle: {
      flexDirection: "row"
    }
  }, [_c('text', {
    staticClass: ["inputText", "defaultFont"]
  }, [_vm._v("密码：")]), _c('input', {
    ref: "pwd",
    staticClass: ["input", "defaultFont"],
    attrs: {
      "type": "password",
      "placeholder": "请输入密码"
    },
    on: {
      "input": _vm.pwdInput
    }
  })])])], 1)
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ }),

/***/ 2:
/***/ (function(module, exports) {

module.exports = {
  "nav": {
    "height": "100",
    "width": "750",
    "zIndex": 10000
  },
  "nav0": {
    "flexDirection": "row",
    "justifyContent": "center",
    "alignItems": "center",
    "height": "88",
    "backgroundColor": "#FFFFFF",
    "marginTop": "40"
  },
  "nav1": {
    "flexDirection": "row",
    "height": "1"
  },
  "leftClass": {
    "marginLeft": "20",
    "marginRight": "20",
    "fontSize": "40",
    "textAlign": "left",
    "flex": 1
  },
  "centerClass": {
    "marginLeft": "20",
    "marginRight": "20",
    "fontSize": "40",
    "textAlign": "center",
    "flex": 1
  },
  "rightClass": {
    "marginLeft": "20",
    "marginRight": "20",
    "fontSize": "40",
    "textAlign": "right",
    "flex": 1
  },
  "line": {
    "backgroundColor": "#dddddd",
    "width": "750",
    "height": "1"
  }
}

/***/ }),

/***/ 3:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//
//

var navigator = weex.requireModule('navigator');

exports.default = {
  name: 'NavBar',
  data: function data() {
    return {
      platform: weex.config.env.platform
    };
  },

  props: {
    title: {
      type: String,
      default: ''
    },
    left: {
      type: String,
      default: ''
    },
    right: {
      type: String,
      default: ''
    },
    backgroundColor: {
      type: String,
      default: '#ffffff'
    },
    rightItemColor: {
      type: String,
      default: '#000000'
    },
    leftItemColor: {
      type: String,
      default: '#000000'
    },
    titleColor: {
      type: String,
      default: '#000000'
    },
    useDefaultReturn: {
      type: String,
      default: 'true'
    }
  },
  created: function created() {},

  methods: {
    leftButtonClicked: function leftButtonClicked() {
      var isPop = this.useDefaultReturn === 'true';

      if (isPop) {
        navigator.pop({}, function (e) {});
      }
      this.$emit('leftButtonClicked', {});
    },
    rightButtonClicked: function rightButtonClicked() {
      this.$emit('rightButtonClicked', {});
    }
  }
};

/***/ }),

/***/ 4:
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    attrs: {
      "dataRole": "navbar"
    }
  }, [(_vm.platform === 'iOS') ? _c('div', {
    staticClass: ["nav1"],
    style: {
      backgroundColor: _vm.backgroundColor
    }
  }, [_c('text', {
    staticClass: ["leftClass"],
    style: {
      color: _vm.leftItemColor
    },
    attrs: {
      "naviItemPosition": "left",
      "value": _vm.left
    },
    on: {
      "click": _vm.leftButtonClicked
    }
  }), _c('text', {
    staticClass: ["centerClass"],
    style: {
      color: _vm.titleColor
    },
    attrs: {
      "naviItemPosition": "center",
      "value": _vm.title
    }
  }), _c('text', {
    staticClass: ["rightClass"],
    style: {
      color: _vm.rightItemColor
    },
    attrs: {
      "naviItemPosition": "right",
      "value": _vm.right
    },
    on: {
      "click": _vm.rightButtonClicked
    }
  })]) : _vm._e(), (_vm.platform !== 'iOS') ? _c('div', {
    staticClass: ["nav0"],
    style: {
      backgroundColor: _vm.backgroundColor
    }
  }, [_c('text', {
    staticClass: ["leftClass"],
    style: {
      color: _vm.leftItemColor
    },
    attrs: {
      "naviItemPosition": "left",
      "value": _vm.left
    },
    on: {
      "click": _vm.leftButtonClicked
    }
  }), _c('text', {
    staticClass: ["centerClass"],
    style: {
      color: _vm.titleColor
    },
    attrs: {
      "naviItemPosition": "center",
      "value": _vm.title
    }
  }), _c('text', {
    staticClass: ["rightClass"],
    style: {
      color: _vm.rightItemColor
    },
    attrs: {
      "naviItemPosition": "right",
      "value": _vm.right
    },
    on: {
      "click": _vm.rightButtonClicked
    }
  })]) : _vm._e(), _c('div', {
    staticClass: ["line"]
  })])
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ })

/******/ });