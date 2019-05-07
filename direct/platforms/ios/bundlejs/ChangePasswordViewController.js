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
/******/ 	return __webpack_require__(__webpack_require__.s = 61);
/******/ })
/************************************************************************/
/******/ ({

/***/ 0:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
var Order = exports.Order = {};

Order.rawValue = function (sub, rw) {
  return sub | rw;
};

var SubOrder = exports.SubOrder = {
  /// 命令码=0x00(R),读取分机设备类型、协议版本、软件版本
  status: 0x0,
  /// 命令码=0x01(R),读取分机实时数据
  realTime: 0x1,
  /// 命令码=0x02(RW),读写分机整条曲线数据
  curves: 0x2,
  /// 命令码=0x03(RW),读写分机曲线段数据
  curve: 0x3,
  /// 命令码=0x04(W),分机运行/停止控制
  run: 0x4,
  /// 命令码=0x05(W),选择分机烘烤曲线
  curveCoding: 0x5,
  /// 命令码=0x06(W),设置分机运行段
  curveNum: 0x6,
  /// 命令码=0x07(W),设置分机上/下棚
  shed: 0x7,
  /// 命令码=0x08(RW),读写分机烤次及日期时间
  time: 0x8,
  /// 命令码=0x09(R),读取分机记录数据
  record: 0x9,
  /// 命令码=0x0A(W)，远程绑定与解绑命令
  bind: 0xA,
  /// 命令码=0x10(R),读取分机生物质燃烧机状态
  burner_args: 0x10,
  /// 命令码=0x12(W),生物质燃烧机点火
  burner_fire: 0x11,
  /// 命令码=0x13(W),生物质燃烧机跳过点火
  burner_pass_fire: 0x12,
  /// 命令码=0x14(W),生物质燃烧机关机命令
  burner_off: 0x13,

  /// 心跳
  bindDevice: 0xF7,
  /// 编辑设备
  editDevice: 0xF8,
  /// 设备列表
  devices: 0xF9,
  /// 删除设备
  deleteDevice: 0xFA,
  /// 添加设备
  addDevice: 0xFB,
  /// 用户信息
  userInfo: 0xFC,
  /// 修改密码
  password: 0xFD,
  /// 登录
  login: 0xFE,
  /// 注册命令
  register: 0xFF
};

var RW = exports.RW = {
  read: 0x0,
  write: 0x40
};

/***/ }),

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

/***/ }),

/***/ 5:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.request = exports.RspStatus = exports.State = undefined;
exports.changePassword = changePassword;

var _Storage = __webpack_require__(6);

var _Order = __webpack_require__(0);

var priority = { high: 3, middle: 2, low: 1 };
var udp = weex.requireModule('UDP');
var modal = weex.requireModule('modal');
var navigator = weex.requireModule('navigator');

var State = exports.State = {
  success: 200,
  failure: 201,
  loginSSO: 2020,
  loginCard: 2021,
  registerReapt: 2030,
  deviceLost: 2040
};
var RspStatus = exports.RspStatus = {
  success: 0,
  nonsupport: 1,
  setting: 2,
  psdError: 3,
  orderError: 4
};

var request = exports.request = {};

request.netWrite = function (order, param, callback) {
  if (param === null) {
    param = {};
  }

  request.net(order | _Order.RW.write, param, function (state, msg, data) {
    // if (data.rspCode === RspStatus.psdError) {
    //   storage.setDevicePassword(param.mid, null)
    //   prompt()
    // } else {
    callback(state, msg, data);
    // }
  });

  // storage.devicePassword(param.mid, (success, value) => {
  //   let prompt = () => {
  //     modal.prompt({
  //       message: '请输入六位数字密码后再次尝试！',
  //       okTitle: '确认',
  //       cancelTitle: '取消'
  //     }, ret => {
  //       if (ret.result === '确认') {
  //         let data = ret.data
  //         const re = /^[1-9]+[0-9]*]*$/
  //
  //         if (!re.test(data)) {
  //           modal.toast({
  //             message: '请输入六位数字密码',
  //             duration: 1
  //           })
  //         } else {
  //           storage.setDevicePassword(param.mid, ret.data)
  //         }
  //       }
  //     })
  //   }
  //   if (success) {
  //     param.password = value
  //
  //     request.net(order | RW.write, param, (state, msg, data) => {
  //       if (data.rspCode === RspStatus.psdError) {
  //         storage.setDevicePassword(param.mid, null)
  //         prompt()
  //       } else {
  //         callback(state, msg, data)
  //       }
  //     })
  //   } else {
  //     prompt()
  //   }
  // })
};
request.net = function (order, param, callback) {
  _Storage.storage.token(function (success, value) {
    if (success && value !== undefined) {
      param.token = value;
    }

    if (param.priority === undefined) {
      param.priority = priority.middle;
    }
    udp.send(order, param, function (rsp) {
      var state = rsp.state;

      if (state === State.loginSSO) {
        _Storage.storage.setToken(null);
        udp.interruptAll();
        modal.alert({
          message: rsp.msg
        }, function () {
          var url = weex.config.bundleUrl + 'LoginViewController.js';
          navigator.push({
            url: url,
            animated: true
          });
        });
      } else if (callback !== undefined) {
        callback(state, rsp.msg, rsp.data);
      }
    });
  });
};
/**
 * TODO 修改密码
 * @param name 用户名
 * @param password 密码
 * @param card 证件号
 * @param callback 回调
 */
function changePassword(name, password, card, callback) {
  // request.changePassword = (name, password, card, callback) => {
  var param = { password: password, card: card };

  if (name !== undefined) {
    param.name = name;
  }
  var order = new _Order.Order(_Order.SubOrder.password, _Order.RW.read);
  request.net(order.rawValue, param, callback);
}
/**
 * TODO 设备列表
 * @param callback
 */
request.devices = function (callback) {
  request.net(_Order.Order.rawValue(_Order.SubOrder.devices, _Order.RW.read), { priority: priority.low }, callback);
};
/**
 * TODO 添加设备
 * @param deviceId 设备ID
 * @param remark
 * @param callback 回调
 */
request.addDevice = function (deviceId, remark, callback) {
  var param = {};
  param.deviceId = deviceId;
  param.remark = remark;
  console.log(JSON.stringify(param), '-------------------------------------------');
  request.net(_Order.Order.rawValue(_Order.SubOrder.addDevice, _Order.RW.read), param, callback);
};
/**
 * TODO 编辑设备
 * @param mid 设备ID
 * @param callback 回调
 */
request.editDevice = function (mid, callback) {
  request.net(_Order.Order.rawValue(_Order.SubOrder.editDevice, _Order.RW.read), { remark: mid.remark, mid: mid.mid }, callback);
};
/**
 * TODO 用户信息
 * @param callback 回调
 */
request.userInfo = function (callback) {
  request.net(_Order.Order.rawValue(_Order.SubOrder.userInfo, _Order.RW.read), {}, callback);
};
/**
 * TODO 注册
 * @param name 用户名
 * @param password 密码
 * @param card 证件号
 * @param callback 回调
 */
request.register = function (name, password, card, callback) {
  request.net(_Order.Order.rawValue(_Order.SubOrder.register, _Order.RW.read), { name: name, password: password, card: card }, callback);
};
/**
 * TODO 登录
 * @param name 用户名
 * @param password 密码
 * @param card 证件号
 * @param callback 回调
 */
request.login = function (name, password, card, callback) {
  var param = { name: name, password: password };

  if (card !== undefined && card !== null && card.length > 0) {
    param.card = card;
  }
  request.net(_Order.Order.rawValue(_Order.SubOrder.login, _Order.RW.read), param, callback);
};
/**
 * TODO 退出登录
 * @param callback 回调
 */
request.logout = function (callback) {
  _Storage.storage.setToken(null, function (success) {
    if (success) {
      callback(State.success, '', {});
    } else {
      callback(State.failure, '失败', {});
    }
  });
};
/**
 * TODO 心跳
 * @param callback 回调
 * @param mid 设备ID
 */
request.heart = function (callback, mid) {
  var param = {};
  if (mid !== undefined && mid !== null && mid.length > 0) {
    param.mid = mid;
  }
  param.priority = priority.low;

  request.net(_Order.Order.rawValue(_Order.SubOrder.heart, _Order.RW.read), param, callback);
};
/**
 * TODO 中断命令
 * @param sub
 * @param rw
 */
request.interrupt = function (sub, rw) {
  udp.interrupt(_Order.Order.rawValue(sub, rw));
};
// ------------------------------------------------------------------------------------
/**
 * TODO 读取分机实时数据
 * @param param
 * @param callback
 */
request.status = function (param, callback) {
  request.net(_Order.Order.rawValue(_Order.SubOrder.status, _Order.RW.read), param, callback);
};
/**
 * TODO 读取分机实时数据
 * @param param
 * @param callback
 */
request.realTime = function (param, callback) {
  param.priority = priority.low;
  request.net(_Order.Order.rawValue(_Order.SubOrder.realTime, _Order.RW.read), param, callback);
};
/**
 * TODO 读写分机整条曲线数据
 * @param rw
 * @param param
 * @param callback
 */
request.curves = function (rw, param, callback) {
  if (rw === _Order.RW.read) {
    request.net(_Order.Order.rawValue(_Order.SubOrder.curves, _Order.RW.read), param, callback);
  } else {
    request.netWrite(_Order.Order.rawValue(_Order.SubOrder.curves, _Order.RW.write), param, callback);
  }
};
/**
 * TODO 读写分机曲线段数据
 * @param rw
 * @param param
 * @param callback
 */
request.curve = function (rw, param, callback) {
  if (rw === _Order.RW.read) {
    request.net(_Order.Order.rawValue(_Order.SubOrder.curve, _Order.RW.read), param, callback);
  } else {
    request.netWrite(_Order.Order.rawValue(_Order.SubOrder.curve, _Order.RW.write), param, callback);
  }
};
/**
 * TODO 分机运行/停止控制
 * @param param
 * @param callback
 */
request.run = function (param, callback) {
  request.netWrite(_Order.Order.rawValue(_Order.SubOrder.run, _Order.RW.write), param, callback);
};
/* TODO 选择分机烘烤曲线 */
request.curveCoding = function (param, callback) {
  request.netWrite(_Order.Order.rawValue(_Order.SubOrder.curveCoding, _Order.RW.write), param, callback);
};
/* TODO 设置分机运行段 */
request.curveNum = function (param, callback) {
  request.netWrite(_Order.Order.rawValue(_Order.SubOrder.curveNum, _Order.RW.write), param, callback);
};
request.shed = function (param, callback) {
  request.netWrite(_Order.Order.rawValue(_Order.SubOrder.shed, _Order.RW.write), param, callback);
};
/**
 * TODO 读写分机烤次及日期时间
 * @param rw
 * @param param
 * @param callback
 */
request.time = function (rw, param, callback) {
  if (rw === _Order.RW.read) {
    request.net(_Order.Order.rawValue(_Order.SubOrder.time, _Order.RW.read), param, callback);
  } else {
    request.netWrite(_Order.Order.rawValue(_Order.SubOrder.time, _Order.RW.write), param, callback);
  }
};
/* 获取记录 */
request.getRecord = function (param, callback) {
  request.net(_Order.Order.rawValue(_Order.SubOrder.record, _Order.RW.read), param, callback);
};
/**/
request.bind = function (param, callback) {
  request.netWrite(_Order.Order.rawValue(_Order.SubOrder.bind, _Order.RW.write), param, callback);
};
request.bindService = function (param, callback) {
  request.net(_Order.Order.rawValue(_Order.SubOrder.bindDevice, _Order.RW.write), param, callback);
};

request.burner_args = function (param, callback) {
  request.net(_Order.Order.rawValue(_Order.SubOrder.burner_args, _Order.RW.read), param, callback);
};

request.burner_fire = function (param, callback) {
  request.netWrite(_Order.Order.rawValue(_Order.SubOrder.burner_fire, _Order.RW.write), param, callback);
};

request.burner_off = function (param, callback) {
  request.netWrite(_Order.Order.rawValue(_Order.SubOrder.burner_off, _Order.RW.write), param, callback);
};

/***/ }),

/***/ 6:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
var success = 'success';
var store = weex.requireModule('storage');

var storage = exports.storage = {};

storage.getItem = function (key, callback) {
  store.getItem(key, function (e) {
    var isSuccess = e.result === success;
    var data = e.data;

    if (data === 'undefined') {
      isSuccess = false;
    }
    callback(isSuccess, e.data);
  });
};

storage.setItem = function (key, value, callback) {
  if (value === undefined || value === null || value.length === 0) {
    store.removeItem(key, function (e) {
      var result = e.result === success;

      if (callback !== undefined) {
        callback(result);
      }
    });
  } else {
    store.setItem(key, value, function (e) {
      var isSuccess = e.result === success;
      console.log(key, isSuccess, ':', e.data);
      if (callback !== undefined) {
        callback(isSuccess);
      }
    });
  }
};

storage.token = function (callback) {
  storage.getItem('zzzl_token', callback);
};

storage.setToken = function (token, callback) {
  storage.setItem('zzzl_token', token, callback);
};

storage.setName = function (name, callback) {
  storage.setItem('zzzl_name', name, callback);
};

storage.name = function (callback) {
  storage.getItem('zzzl_name', callback);
};

storage.setPassword = function (password, callback) {
  storage.setItem('zzzl_password', password, callback);
};

storage.password = function (callback) {
  storage.getItem('zzzl_password', callback);
};

storage.setDevicePassword = function (mid, password, callback) {
  storage.setItem('zzzl_device_password' + mid, password, callback);
};

storage.devicePassword = function (mid, callback) {
  storage.getItem('zzzl_device_password' + mid, callback);
};

/***/ }),

/***/ 61:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _ChangePasswordViewController = __webpack_require__(62);

var _ChangePasswordViewController2 = _interopRequireDefault(_ChangePasswordViewController);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

_ChangePasswordViewController2.default.el = '#root';
new Vue(_ChangePasswordViewController2.default);

/***/ }),

/***/ 62:
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(63)
)

/* script */
__vue_exports__ = __webpack_require__(64)

/* template */
var __vue_template__ = __webpack_require__(65)
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
__vue_options__.__file = "/Users/zzzl/Documents/APP项目/direct/src/ChangePasswordViewController.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-d7aa3836"
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

/***/ 63:
/***/ (function(module, exports) {

module.exports = {
  "view": {
    "top": "40",
    "alignItems": "center"
  },
  "inputName": {
    "marginTop": "30",
    "fontSize": "38",
    "color": "#000000",
    "height": "50"
  },
  "inputSuper": {
    "marginTop": "40"
  },
  "input": {
    "fontSize": "38",
    "marginTop": "30",
    "paddingLeft": "20",
    "width": "500",
    "height": "50",
    "backgroundColor": "#F5F5F5"
  }
}

/***/ }),

/***/ 64:
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _typeof = typeof Symbol === "function" && typeof Symbol.iterator === "symbol" ? function (obj) { return typeof obj; } : function (obj) { return obj && typeof Symbol === "function" && obj.constructor === Symbol && obj !== Symbol.prototype ? "symbol" : typeof obj; }; //
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

var _NavBar = __webpack_require__(1);

var _NavBar2 = _interopRequireDefault(_NavBar);

var _Request = __webpack_require__(5);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var modal = weex.requireModule('modal');

exports.default = {
  name: 'ChangePasswordViewController',
  components: { NavBar: _NavBar2.default },
  data: function data() {
    return {
      isForget: false
    };
  },
  created: function created() {
    var info = weex.requireModule('UserInfoModule');
    var self = this;
    info.getParam(function (param) {
      console.log(param.isForget, '-------------------', _typeof(param.isForget));
      self.isForget = param.isForget;
    });
  },

  methods: {
    toMakeSure: function toMakeSure() {
      if (!this.isForget) {
        this.$refs.name.blur();
      }
      this.$refs.card.blur();
      this.$refs.pwd.blur();
      this.$refs.repwd.blur();

      if (!this.isForget && (this.name === undefined || this.name === null || this.name.length === 0)) {
        modal.toast({
          message: '请输入用户名',
          duration: 0.3
        });
        return;
      }
      if (this.card === undefined || this.card === null || this.card.length === 0) {
        modal.toast({
          message: '请输入证件号',
          duration: 0.3
        });
        return;
      }
      if (this.pwd === undefined || this.pwd === null || this.pwd.length === 0) {
        modal.toast({
          message: '请输入新密码',
          duration: 0.3
        });
        return;
      }
      if (this.pwd1 === undefined || this.pwd1 === null || this.pwd1.length === 0) {
        modal.toast({
          message: '请再次输入新密码',
          duration: 0.3
        });
        return;
      }
      if (this.pwd1 !== this.pwd) {
        modal.toast({
          message: '两次输入密码不同',
          duration: 0.3
        });
      }
      (0, _Request.changePassword)(this.name, this.pwd, this.card, function (state, msg, data) {
        modal.toast({
          message: msg,
          duration: 0.3
        });
      });
    },
    nameInput: function nameInput(e) {
      this.name = e.value;
    },
    cardInput: function cardInput(e) {
      this.card = e.value;
    },
    pwdInput: function pwdInput(e) {
      this.pwd = e.value;
    },
    rePwdInput: function rePwdInput(e) {
      this.pwd1 = e.value;
    }
  }
};

/***/ }),

/***/ 65:
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', [_c('nav-bar', {
    attrs: {
      "title": "修改密码",
      "left": "返回",
      "right": "确认"
    },
    on: {
      "rightButtonClicked": _vm.toMakeSure
    }
  }), _c('div', {
    staticClass: ["view"]
  }, [_c('div', {
    staticClass: ["inputSuper"]
  }, [(_vm.isForget) ? _c('div', {
    staticStyle: {
      flexDirection: "row"
    }
  }, [_c('text', {
    staticClass: ["inputName"]
  }, [_vm._v("用")]), _c('text', {
    staticClass: ["inputName"],
    staticStyle: {
      paddingLeft: "19px"
    }
  }, [_vm._v("户")]), _c('text', {
    staticClass: ["inputName"],
    staticStyle: {
      paddingLeft: "19px"
    }
  }, [_vm._v("名：")]), _c('input', {
    ref: "name",
    staticClass: ["input"],
    attrs: {
      "type": "text",
      "placeholder": "请输入用户名"
    },
    on: {
      "input": _vm.nameInput
    }
  })]) : _vm._e(), _c('div', {
    staticStyle: {
      flexDirection: "row"
    }
  }, [_c('text', {
    staticClass: ["inputName"]
  }, [_vm._v("证")]), _c('text', {
    staticClass: ["inputName"],
    staticStyle: {
      paddingLeft: "19px"
    }
  }, [_vm._v("件")]), _c('text', {
    staticClass: ["inputName"],
    staticStyle: {
      paddingLeft: "19px"
    }
  }, [_vm._v("号：")]), _c('input', {
    ref: "card",
    staticClass: ["input"],
    attrs: {
      "type": "text",
      "placeholder": "请输入证件号"
    },
    on: {
      "input": _vm.cardInput
    }
  })]), _c('div', {
    staticStyle: {
      flexDirection: "row"
    }
  }, [_c('text', {
    staticClass: ["inputName"]
  }, [_vm._v("新")]), _c('text', {
    staticClass: ["inputName"],
    staticStyle: {
      paddingLeft: "19px"
    }
  }, [_vm._v("密")]), _c('text', {
    staticClass: ["inputName"],
    staticStyle: {
      paddingLeft: "19px"
    }
  }, [_vm._v("码：")]), _c('input', {
    ref: "pwd",
    staticClass: ["input"],
    attrs: {
      "type": "password",
      "placeholder": "请输入密码"
    },
    on: {
      "input": _vm.pwdInput
    }
  })]), _c('div', {
    staticStyle: {
      flexDirection: "row"
    }
  }, [_c('text', {
    staticClass: ["inputName"]
  }, [_vm._v("确认密码：")]), _c('input', {
    ref: "repwd",
    staticClass: ["input"],
    attrs: {
      "type": "password",
      "placeholder": "请再次输入密码"
    },
    on: {
      "input": _vm.rePwdInput
    }
  })])])])], 1)
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ })

/******/ });