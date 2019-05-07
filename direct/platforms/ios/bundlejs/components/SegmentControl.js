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
/******/ 	return __webpack_require__(__webpack_require__.s = 74);
/******/ })
/************************************************************************/
/******/ ({

/***/ 35:
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(36)
)

/* script */
__vue_exports__ = __webpack_require__(37)

/* template */
var __vue_template__ = __webpack_require__(38)
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
__vue_options__.__file = "/Users/zzzl/Documents/APP项目/direct/src/components/SegmentControl.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-bbbed04c"
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

/***/ 36:
/***/ (function(module, exports) {

module.exports = {
  "segment": {
    "borderRadius": "20",
    "borderColor": "#D3D3D3",
    "borderWidth": "2",
    "height": "60",
    "width": "700",
    "flexDirection": "row",
    "justifyContent": "space-between"
  },
  "text": {
    "fontSize": "28"
  },
  "test": {
    "borderTopRightRadius": "20"
  },
  "tabStart": {
    "marginTop": "0",
    "marginRight": "0",
    "marginBottom": "0",
    "marginLeft": "0",
    "backgroundColor": "#7FFFD4",
    "justifyContent": "center",
    "alignItems": "center",
    "flexDirection": "row",
    "flex": 1,
    "borderTopLeftRadius": "20",
    "borderBottomLeftRadius": "20",
    "borderRightWidth": "2",
    "borderColor": "rgb(173,173,187)"
  },
  "tabEnd": {
    "marginTop": "0",
    "marginRight": "0",
    "marginBottom": "0",
    "marginLeft": "0",
    "backgroundColor": "#7FFFD4",
    "justifyContent": "center",
    "alignItems": "center",
    "flexDirection": "row",
    "flex": 1,
    "borderTopRightRadius": "20",
    "borderBottomRightRadius": "20"
  },
  "tabLine": {
    "marginTop": "0",
    "marginRight": "0",
    "marginBottom": "0",
    "marginLeft": "0",
    "backgroundColor": "#7FFFD4",
    "justifyContent": "center",
    "alignItems": "center",
    "flexDirection": "row",
    "flex": 1,
    "borderRightWidth": "2",
    "borderColor": "rgb(173,173,187)"
  },
  "line": {
    "width": "10",
    "backgroundColor": "#000000"
  },
  "activeText": {
    "color": "#FFFFFF",
    "fontSize": "38"
  },
  "normalText": {
    "color": "#000000",
    "fontSize": "38"
  },
  "activeBG": {
    "backgroundColor": "#717171"
  },
  "normalBG": {
    "backgroundColor": "#FFFFFF"
  }
}

/***/ }),

/***/ 37:
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

exports.default = {
  name: 'SegmentControl',
  props: {
    items: {
      type: Array,
      default: function _default() {
        return ['item1', 'item2'];
      }
    },
    activeIndex: {
      type: Number,
      default: 0
    }
  },
  data: function data() {},

  methods: {
    onClick: function onClick(index) {
      var self = this;

      this.$emit('segmentClicked', {
        data: index,
        callback: function callback(isChange) {
          if (index !== self.activeIndex && isChange) {
            self.activeIndex = index;
          }
        }
      });
    }
  }
};

/***/ }),

/***/ 38:
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    staticClass: ["segment"]
  }, _vm._l((_vm.items), function(item, index) {
    return _c('div', {
      key: index,
      class: [(index === 0) ? 'tabStart' : '',
        (index === _vm.items.length - 1) ? 'tabEnd' : '',
        (index !== _vm.items.length - 1) && (index !== 0) ? 'tabLine' : '',
        (index === _vm.activeIndex) ? 'activeBG' : 'normalBG'
      ],
      on: {
        "click": function($event) {
          _vm.onClick(index)
        }
      }
    }, [_c('text', {
      class: [(index === _vm.activeIndex) ? 'activeText' : 'normalText']
    }, [_vm._v(_vm._s(item))])])
  }))
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ }),

/***/ 74:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _SegmentControl = __webpack_require__(35);

var _SegmentControl2 = _interopRequireDefault(_SegmentControl);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

_SegmentControl2.default.el = '#root';
new Vue(_SegmentControl2.default);

/***/ })

/******/ });