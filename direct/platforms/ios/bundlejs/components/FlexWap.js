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
/******/ 	return __webpack_require__(__webpack_require__.s = 71);
/******/ })
/************************************************************************/
/******/ ({

/***/ 25:
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(26)
)

/* script */
__vue_exports__ = __webpack_require__(27)

/* template */
var __vue_template__ = __webpack_require__(28)
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
__vue_options__.__file = "/Users/zzzl/Documents/APP项目/direct/src/components/FlexWap.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-62c910a6"
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

/***/ 26:
/***/ (function(module, exports) {

module.exports = {
  "text": {
    "marginTop": "5",
    "marginLeft": "10",
    "paddingTop": "5",
    "paddingRight": "5",
    "paddingBottom": "5",
    "paddingLeft": "5",
    "backgroundColor": "#FF0000",
    "borderRadius": "10",
    "color": "#ffffff"
  },
  "div": {
    "flexDirection": "row"
  }
}

/***/ }),

/***/ 27:
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

exports.default = {
  name: 'FlexWap',
  data: function data() {
    return {};
  },

  props: {
    list: {
      type: Array,
      default: function _default() {}
    },
    fontSize: {
      type: Number,
      default: 34
    },
    width: {
      type: Number,
      default: 750
    }
  },
  created: function created() {},

  computed: {
    updateList: function updateList() {
      var list = this.list,
          fontSize = this.fontSize,
          width = this.width;

      var arr = [];
      var rows = [];
      var w = 0;

      if (list) {
        for (var i = 0, len = list.length; i < len; i++) {
          var str = list[i];
          var size = fontSize * str.length;

          w += 20 + size;

          if (w >= width) {
            arr.push(JSON.parse(JSON.stringify(rows)));
            w = 0;
            rows = [];
          }
          var item = { title: str, len: size };
          rows.push(item);
        }
        arr.push(JSON.parse(JSON.stringify(rows)));
      }
      return arr;
    }
  }
};

/***/ }),

/***/ 28:
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', _vm._l((_vm.updateList), function(arr, i) {
    return _c('div', {
      key: i,
      staticClass: ["div"]
    }, _vm._l((arr), function(item, m) {
      return _c('text', {
        key: m,
        staticClass: ["text"],
        style: {
          fontSize: _vm.fontSize
        }
      }, [_vm._v(_vm._s(item.title))])
    }))
  }))
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ }),

/***/ 71:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _FlexWap = __webpack_require__(25);

var _FlexWap2 = _interopRequireDefault(_FlexWap);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

_FlexWap2.default.el = '#root';
new Vue(_FlexWap2.default);

/***/ })

/******/ });