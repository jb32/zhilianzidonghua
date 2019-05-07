import {storage} from './Storage'
import {SubOrder, Order, RW} from './Order'

const priority = { high: 3, middle: 2, low: 1 }
const udp = weex.requireModule('UDP')
const modal = weex.requireModule('modal')
const navigator = weex.requireModule('navigator')

export const State = {
  success: 200,
  failure: 201,
  loginSSO: 2020,
  loginCard: 2021,
  registerReapt: 2030,
  deviceLost: 2040
}
export const RspStatus = {
  success: 0,
  nonsupport: 1,
  setting: 2,
  psdError: 3,
  orderError: 4
}

export let request = {}

request.netWrite = function (order, param, callback) {
  if (param === null) { param = {} }

  request.net(order | RW.write, param, (state, msg, data) => {
    // if (data.rspCode === RspStatus.psdError) {
    //   storage.setDevicePassword(param.mid, null)
    //   prompt()
    // } else {
    callback(state, msg, data)
    // }
  })

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
}
request.net = function (order, param, callback) {
  storage.token((success, value) => {
    if (success && value !== undefined) {
      param.token = value
    }

    if (param.priority === undefined) {
      param.priority = priority.middle
    }
    udp.send(order, param, function (rsp) {
      let state = rsp.state

      if (state === State.loginSSO) {
        storage.setToken(null)
        udp.interruptAll()
        modal.alert({
          message: rsp.msg
        }, () => {
          const url = weex.config.bundleUrl + 'LoginViewController.js'
          navigator.push({
            url: url,
            animated: true
          })
        })
      } else if (callback !== undefined) {
        callback(state, rsp.msg, rsp.data)
      }
    })
  })
}
/**
 * TODO 修改密码
 * @param name 用户名
 * @param password 密码
 * @param card 证件号
 * @param callback 回调
 */
export function changePassword (name, password, card, callback) {
// request.changePassword = (name, password, card, callback) => {
  let param = { password: password, card: card }

  if (name !== undefined) {
    param.name = name
  }
  const order = new Order(SubOrder.password, RW.read)
  request.net(order.rawValue, param, callback)
}
/**
 * TODO 设备列表
 * @param callback
 */
request.devices = (callback) => {
  request.net(Order.rawValue(SubOrder.devices, RW.read), {priority: priority.low}, callback)
}
/**
 * TODO 添加设备
 * @param deviceId 设备ID
 * @param remark
 * @param callback 回调
 */
request.addDevice = (deviceId, remark, callback) => {
  let param = {}
  param.deviceId = deviceId
  param.remark = remark
  console.log(JSON.stringify(param), '-------------------------------------------')
  request.net(Order.rawValue(SubOrder.addDevice, RW.read), param, callback)
}
/**
 * TODO 编辑设备
 * @param mid 设备ID
 * @param callback 回调
 */
request.editDevice = (mid, callback) => {
  request.net(Order.rawValue(SubOrder.editDevice, RW.read), { remark: mid.remark, mid: mid.mid }, callback)
}
/**
 * TODO 用户信息
 * @param callback 回调
 */
request.userInfo = (callback) => {
  request.net(Order.rawValue(SubOrder.userInfo, RW.read), {}, callback)
}
/**
 * TODO 注册
 * @param name 用户名
 * @param password 密码
 * @param card 证件号
 * @param callback 回调
 */
request.register = (name, password, card, callback) => {
  request.net(Order.rawValue(SubOrder.register, RW.read), { name: name, password: password, card: card }, callback)
}
/**
 * TODO 登录
 * @param name 用户名
 * @param password 密码
 * @param card 证件号
 * @param callback 回调
 */
request.login = (name, password, card, callback) => {
  let param = { name: name, password: password }

  if (card !== undefined && card !== null && card.length > 0) {
    param.card = card
  }
  request.net(Order.rawValue(SubOrder.login, RW.read), param, callback)
}
/**
 * TODO 退出登录
 * @param callback 回调
 */
request.logout = (callback) => {
  storage.setToken(null, success => {
    if (success) {
      callback(State.success, '', {})
    } else {
      callback(State.failure, '失败', {})
    }
  })
}
/**
 * TODO 心跳
 * @param callback 回调
 * @param mid 设备ID
 */
request.heart = (callback, mid) => {
  let param = {}
  if (mid !== undefined && mid !== null && mid.length > 0) {
    param.mid = mid
  }
  param.priority = priority.low

  request.net(Order.rawValue(SubOrder.heart, RW.read), param, callback)
}
/**
 * TODO 中断命令
 * @param sub
 * @param rw
 */
request.interrupt = (sub, rw) => {
  udp.interrupt(Order.rawValue(sub, rw))
}
// ------------------------------------------------------------------------------------
/**
 * TODO 读取分机实时数据
 * @param param
 * @param callback
 */
request.status = (param, callback) => {
  request.net(Order.rawValue(SubOrder.status, RW.read), param, callback)
}
/**
 * TODO 读取分机实时数据
 * @param param
 * @param callback
 */
request.realTime = (param, callback) => {
  param.priority = priority.low
  request.net(Order.rawValue(SubOrder.realTime, RW.read), param, callback)
}
/**
 * TODO 读写分机整条曲线数据
 * @param rw
 * @param param
 * @param callback
 */
request.curves = (rw, param, callback) => {
  if (rw === RW.read) {
    request.net(Order.rawValue(SubOrder.curves, RW.read), param, callback)
  } else {
    request.netWrite(Order.rawValue(SubOrder.curves, RW.write), param, callback)
  }
}
/**
 * TODO 读写分机曲线段数据
 * @param rw
 * @param param
 * @param callback
 */
request.curve = (rw, param, callback) => {
  if (rw === RW.read) {
    request.net(Order.rawValue(SubOrder.curve, RW.read), param, callback)
  } else {
    request.netWrite(Order.rawValue(SubOrder.curve, RW.write), param, callback)
  }
}
/**
 * TODO 分机运行/停止控制
 * @param param
 * @param callback
 */
request.run = (param, callback) => {
  request.netWrite(Order.rawValue(SubOrder.run, RW.write), param, callback)
}
/* TODO 选择分机烘烤曲线 */
request.curveCoding = (param, callback) => {
  request.netWrite(Order.rawValue(SubOrder.curveCoding, RW.write), param, callback)
}
/* TODO 设置分机运行段 */
request.curveNum = (param, callback) => {
  request.netWrite(Order.rawValue(SubOrder.curveNum, RW.write), param, callback)
}
request.shed = (param, callback) => {
  request.netWrite(Order.rawValue(SubOrder.shed, RW.write), param, callback)
}
/**
 * TODO 读写分机烤次及日期时间
 * @param rw
 * @param param
 * @param callback
 */
request.time = (rw, param, callback) => {
  if (rw === RW.read) {
    request.net(Order.rawValue(SubOrder.time, RW.read), param, callback)
  } else {
    request.netWrite(Order.rawValue(SubOrder.time, RW.write), param, callback)
  }
}
/* 获取记录 */
request.getRecord = (param, callback) => {
  request.net(Order.rawValue(SubOrder.record, RW.read), param, callback)
}
/**/
request.bind = (param, callback) => {
  request.netWrite(Order.rawValue(SubOrder.bind, RW.write), param, callback)
}
request.bindService = (param, callback) => {
  request.net(Order.rawValue(SubOrder.bindDevice, RW.write), param, callback)
}

request.burner_args = (param, callback) => {
  request.net(Order.rawValue(SubOrder.burner_args, RW.read), param, callback)
}

request.burner_fire = (param, callback) => {
  request.netWrite(Order.rawValue(SubOrder.burner_fire, RW.write), param, callback)
}

request.burner_off = (param, callback) => {
  request.netWrite(Order.rawValue(SubOrder.burner_off, RW.write), param, callback)
}
