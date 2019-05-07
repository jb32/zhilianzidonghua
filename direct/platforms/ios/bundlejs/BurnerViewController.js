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
/******/ 	return __webpack_require__(__webpack_require__.s = 55);
/******/ })
/************************************************************************/
/******/ ([
/* 0 */
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
/* 1 */
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
/* 2 */
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
/* 3 */
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
/* 4 */
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
/* 5 */
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
/* 6 */
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
/* 7 */
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(8)
)

/* script */
__vue_exports__ = __webpack_require__(9)

/* template */
var __vue_template__ = __webpack_require__(10)
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
__vue_options__.__file = "/Users/zzzl/Documents/APP项目/direct/src/components/UIButton.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-a52e7014"
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
/* 8 */
/***/ (function(module, exports) {

module.exports = {
  "button": {
    "justifyContent": "center"
  },
  "buttonTxt": {
    "textAlign": "center",
    "color": "#FFFFFF",
    "fontSize": "40"
  }
}

/***/ }),
/* 9 */
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

exports.default = {
  name: 'UIButton',
  props: {
    color: {
      type: String,
      default: '#FFFFFF'
    },
    fontSize: {
      type: Number,
      default: 40
    },
    bgColor: {
      type: String,
      default: '#0088fb'
    },
    borderRadius: {
      type: Number,
      default: 10
    },
    title: {
      type: String,
      default: ''
    }
  },
  methods: {
    doClick: function doClick(e) {
      this.$emit('doClick', e);
    }
  }
};

/***/ }),
/* 10 */
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    staticClass: ["button"],
    style: {
      backgroundColor: _vm.bgColor,
      borderRadius: _vm.borderRadius
    },
    on: {
      "click": _vm.doClick
    }
  }, [_c('text', {
    staticClass: ["buttonTxt"],
    style: {
      color: _vm.color,
      fontSize: _vm.fontSize
    }
  }, [_vm._v(_vm._s(_vm.title))])])
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ }),
/* 11 */
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(12)
)

/* script */
__vue_exports__ = __webpack_require__(13)

/* template */
var __vue_template__ = __webpack_require__(14)
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
__vue_options__.__file = "/Users/zzzl/Documents/APP项目/direct/src/components/UILine.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-23c6fab8"
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
/* 12 */
/***/ (function(module, exports) {

module.exports = {
  "line": {
    "backgroundColor": "#dddddd",
    "height": "1"
  }
}

/***/ }),
/* 13 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
//
//
//
//

exports.default = {
  name: 'UILine'
};

/***/ }),
/* 14 */
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    staticClass: ["line"]
  })
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ }),
/* 15 */,
/* 16 */,
/* 17 */,
/* 18 */,
/* 19 */,
/* 20 */,
/* 21 */,
/* 22 */,
/* 23 */,
/* 24 */,
/* 25 */,
/* 26 */,
/* 27 */,
/* 28 */,
/* 29 */,
/* 30 */,
/* 31 */,
/* 32 */,
/* 33 */,
/* 34 */,
/* 35 */,
/* 36 */,
/* 37 */,
/* 38 */,
/* 39 */,
/* 40 */,
/* 41 */,
/* 42 */,
/* 43 */,
/* 44 */,
/* 45 */,
/* 46 */,
/* 47 */,
/* 48 */,
/* 49 */,
/* 50 */,
/* 51 */,
/* 52 */,
/* 53 */,
/* 54 */,
/* 55 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


var _BurnerViewController = __webpack_require__(56);

var _BurnerViewController2 = _interopRequireDefault(_BurnerViewController);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

_BurnerViewController2.default.el = '#root';
new Vue(_BurnerViewController2.default);

/***/ }),
/* 56 */
/***/ (function(module, exports, __webpack_require__) {

var __vue_exports__, __vue_options__
var __vue_styles__ = []

/* styles */
__vue_styles__.push(__webpack_require__(57)
)

/* script */
__vue_exports__ = __webpack_require__(58)

/* template */
var __vue_template__ = __webpack_require__(60)
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
__vue_options__.__file = "/Users/zzzl/Documents/APP项目/direct/src/BurnerViewController.vue"
__vue_options__.render = __vue_template__.render
__vue_options__.staticRenderFns = __vue_template__.staticRenderFns
__vue_options__._scopeId = "data-v-6eb9e6f6"
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
/* 57 */
/***/ (function(module, exports) {

module.exports = {
  "font": {
    "fontSize": "38"
  },
  "view": {
    "marginTop": "20"
  },
  "line": {
    "marginTop": "20"
  },
  "cell": {
    "paddingLeft": "20",
    "paddingRight": "20",
    "paddingTop": "20"
  },
  "cell_div": {
    "flexDirection": "row",
    "justifyContent": "space-between"
  },
  "cell_title": {
    "justifyContent": "center"
  },
  "cell_detail": {
    "width": "300",
    "textAlign": "right"
  },
  "bottom": {
    "flexDirection": "row",
    "paddingTop": "30",
    "paddingRight": "30",
    "paddingBottom": "30",
    "paddingLeft": "30"
  },
  "bottom_btn": {
    "flex": 1,
    "height": "70"
  }
}

/***/ }),
/* 58 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});

var _NavBar = __webpack_require__(1);

var _NavBar2 = _interopRequireDefault(_NavBar);

var _UILine = __webpack_require__(11);

var _UILine2 = _interopRequireDefault(_UILine);

var _UIButton = __webpack_require__(7);

var _UIButton2 = _interopRequireDefault(_UIButton);

var _BurnerVM = __webpack_require__(59);

var _Order = __webpack_require__(0);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

var userInfoModule = weex.requireModule('UserInfoModule'); //
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
//
//
//
//
//

exports.default = {
  name: 'BurnerViewController',
  components: { UIButton: _UIButton2.default, UILine: _UILine2.default, NavBar: _NavBar2.default },
  data: function data() {
    return {
      burnerVM: new _BurnerVM.BurnerVM(),
      switchTitle: '关闭'
    };
  },

  methods: {
    onViewAppear: function onViewAppear() {
      var self = this;
      userInfoModule.getParam(function (mid) {
        self.burnerVM.mid = mid;
        self.toStatus();
      });
    },
    onViewDisAppear: function onViewDisAppear() {
      this.burnerVM.interrupt(_Order.SubOrder.burner_args, _Order.RW.read);
      this.burnerVM.interrupt(_Order.SubOrder.burner_fire, _Order.RW.write);
      this.burnerVM.interrupt(_Order.SubOrder.burner_off, _Order.RW.write);
    },
    toFire: function toFire() {
      this.burnerVM.toFire();
    },
    toOff: function toOff() {
      this.burnerVM.toOff();
    },
    toStatus: function toStatus() {
      this.burnerVM.toStatus();
    }
  }
};

/***/ }),
/* 59 */
/***/ (function(module, exports, __webpack_require__) {

"use strict";


Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.BurnerVM = BurnerVM;

var _Request = __webpack_require__(5);

var status = ['空闲', '预进料', '点火', '加热缓冲', '正常燃烧', '关机阶段'];

function BurnerVM() {
  this.status = 0;
  this.alarm = [];
  this.fire = 0;
  this.times = 0;
  this.thermocouple = 0;
  this.mid = {};

  this.modal = weex.requireModule('modal');
}

BurnerVM.prototype.statusName = function () {
  return status[this.status];
};

BurnerVM.prototype.alarmName = function () {
  if (this.alarm.length === 0) {
    return '正常';
  }
  return this.alarm.join(',');
};

BurnerVM.prototype.isOn = function () {
  return this.status !== 0 || this.status !== 5;
};

BurnerVM.prototype.toStatus = function () {
  var _this = this;

  var mid = JSON.parse(JSON.stringify(this.mid));
  _Request.request.burner_args(mid, function (state, msg, data) {
    if (state === _Request.State.success) {
      _this.status = data.status;
      _this.alarm = data.alarm;
      _this.fire = data.fire;
      _this.times = data.times;
      _this.thermocouple = data.thermocouple;
    }
    _this.toStatus();
  });
};

BurnerVM.prototype.toFire = function () {
  var _this2 = this;

  var mid = JSON.parse(JSON.stringify(this.mid));
  _Request.request.burner_fire(mid, function (state, msg, data) {
    if (state === _Request.State.success) {
      _this2.status = data.status;
      _this2.toStatus();
    }
  });
};

BurnerVM.prototype.toOff = function () {
  var _this3 = this;

  var mid = JSON.parse(JSON.stringify(this.mid));
  _Request.request.burner_off(mid, function (state, msg, data) {
    if (state === _Request.State.success) {
      _this3.status = data.status;
      _this3.toStatus();
    }
  });
};

BurnerVM.prototype.interrupt = function (sub, rw) {
  _Request.request.interrupt(sub, rw);
};

/***/ }),
/* 60 */
/***/ (function(module, exports) {

module.exports={render:function (){var _vm=this;var _h=_vm.$createElement;var _c=_vm._self._c||_h;
  return _c('div', {
    on: {
      "viewappear": _vm.onViewAppear,
      "viewdisappear": _vm.onViewDisAppear
    }
  }, [_c('nav-bar', {
    attrs: {
      "title": "燃烧机",
      "left": "返回"
    }
  }), _c('list', {
    staticClass: ["view"]
  }, [_c('cell', {
    staticClass: ["cell"],
    appendAsTree: true,
    attrs: {
      "append": "tree"
    }
  }, [_c('div', {
    staticClass: ["cell_div"]
  }, [_c('text', {
    staticClass: ["font"]
  }, [_vm._v("状态")]), _c('text', {
    staticClass: ["font"]
  }, [_vm._v(_vm._s(_vm.burnerVM.statusName()))])]), _c('u-i-line', {
    staticClass: ["line"]
  })], 1), _c('cell', {
    staticClass: ["cell"],
    appendAsTree: true,
    attrs: {
      "append": "tree"
    }
  }, [_c('div', {
    staticClass: ["cell_div"]
  }, [_c('text', {
    staticClass: ["cell_title", "font"]
  }, [_vm._v("报警")]), _c('text', {
    staticClass: ["cell_detail", "font"]
  }, [_vm._v(_vm._s(_vm.burnerVM.alarmName()))])]), _c('u-i-line', {
    staticClass: ["line"]
  })], 1), _c('cell', {
    staticClass: ["cell"],
    appendAsTree: true,
    attrs: {
      "append": "tree"
    }
  }, [_c('div', {
    staticClass: ["cell_div"]
  }, [_c('text', {
    staticClass: ["cell_title", "font"]
  }, [_vm._v("输出火力")]), _c('text', {
    staticClass: ["cell_detail", "font"]
  }, [_vm._v(_vm._s(_vm.burnerVM.fire) + "%")])]), _c('u-i-line', {
    staticClass: ["line"]
  })], 1), _c('cell', {
    staticClass: ["cell"],
    appendAsTree: true,
    attrs: {
      "append": "tree"
    }
  }, [_c('div', {
    staticClass: ["cell_div"]
  }, [_c('text', {
    staticClass: ["cell_title", "font"]
  }, [_vm._v("已进料")]), _c('text', {
    staticClass: ["cell_detail", "font"]
  }, [_vm._v(_vm._s(_vm.burnerVM.times) + "秒")])]), _c('u-i-line', {
    staticClass: ["line"]
  })], 1), _c('cell', {
    staticClass: ["cell"],
    appendAsTree: true,
    attrs: {
      "append": "tree"
    }
  }, [_c('div', {
    staticClass: ["cell_div"]
  }, [_c('text', {
    staticClass: ["cell_title", "font"]
  }, [_vm._v("热电偶温度")]), _c('text', {
    staticClass: ["cell_detail", "font"]
  }, [_vm._v(_vm._s(_vm.burnerVM.thermocouple) + "度")])])])]), _c('div', {
    staticClass: ["bottom"]
  }, [_c('u-i-button', {
    staticClass: ["bottom_btn"],
    attrs: {
      "title": "点火",
      "bgColor": "red"
    },
    on: {
      "doClick": _vm.toFire
    }
  }), _c('u-i-button', {
    staticClass: ["bottom_btn"],
    staticStyle: {
      marginLeft: "10px"
    },
    attrs: {
      "title": _vm.switchTitle
    },
    on: {
      "doClick": _vm.toOff
    }
  })], 1)], 1)
},staticRenderFns: []}
module.exports.render._withStripped = true

/***/ })
/******/ ]);