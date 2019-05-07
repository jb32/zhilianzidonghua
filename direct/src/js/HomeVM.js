import {request, State} from './Request'
import {RW} from './Order'
import {Curve, CurveNum, Shed, Coding} from './Curve'
import Vue from 'Vue'

export function HomeVM () {
  this.type = []
  this.treatyVersions = ''
  this.versions = ''

  this.coding = 0
  this.run = 0
  this.shed = 0
  this.subAlarm = 0
  this.dryT = 0
  this.wetT = 0
  this.time = ''
  this.timeTotal = ''
  this.dryAim = 0
  this.wetAim = 0
  this.voltage = 0
  this.isAlarm = false
  this.voltageStatu = 0
  this.isFanOn = false
  this.fan = 0
  this.warm = false
  this.intakeOn = false
  this.alarmStatus = []
  this.dryTHelp = 0
  this.wetTHelp = 0
  this.currentCurve = {}

  this.bakeTimes = 0
  this.year = 0
  this.month = 0
  this.day = 0
  this.hour = 0
  this.minute = 0

  this.displayCurves = []
  this.curves = []
  this.mid = {}

  this.sheds = [
    {title: Shed.names[Shed.up], value: Shed.up, checked: false},
    {title: Shed.names[Shed.down], value: Shed.down, checked: false}
  ]
  this.codings = Coding.names

  this.handler = false
  this.modal = weex.requireModule('modal')
}

HomeVM.prototype.created = function (callback) {
  this.__status((state, msg) => {
    this.__time((state, msg) => {
      this.__realtime((state, msg) => {
        callback(state, msg)
        this.handler = true
      })
    })
  })
}
/// TODO 分机整条曲线数据
HomeVM.prototype.getCurves = function (callback) {
  let param = JSON.parse(JSON.stringify(this.mid))
  param.coding = this.coding

  request.curves(RW.read, param, (state, msg, data) => {
    if (state === State.success) {
      this.coding = data.coding

      for (let i = 0, len = data.curves.length; i < len; i++) {
        let curve = data.curves[i]
        let curveNum = new CurveNum(i)
        this.curves[i] = new Curve(curve.up, curve.wet.toFixed(1), curve.dry.toFixed(0), curve.steady, curveNum)
      }
      this.__dealCurves()
      this.__realtime()
    }
    callback(state, msg)
  })
}
/* TODO 设置分机曲线数据 */
HomeVM.prototype.setCurve = function (curve, callback) {
  let param = JSON.parse(JSON.stringify(this.mid))

  if (!param.bind) {
    this.modal.toast({
      message: '请先在设备编辑页，绑定该设备！',
      duration: 1.0
    })
    return
  }
  let curveNum = CurveNum.num(curve.num)
  param.coding = this.coding
  param.curveNum = curveNum
  param.curve = curve

  request.curve(RW.write, param, (state, msg, data) => {
    if (state === State.success && data.coding === this.coding) {
      if (this.curves.length !== 0) {
        let _curve = this.curves[curve.num.value]
        _curve.dry = data.curve.dry.toFixed(0)
        _curve.wet = data.curve.wet.toFixed(1)
        _curve.up = data.curve.up
        _curve.steady = data.curve.steady
        Vue.set(this.curves, curve.num.value, _curve)
        this.__dealCurves()
      }
    }
    this.__realtime()
    callback(state, msg)
  })
}
/* TODO 切换曲线段号 */
HomeVM.prototype.setCurveNum = function (curveNum, callback) {
  let param = JSON.parse(JSON.stringify(this.mid))

  if (!param.bind) {
    this.modal.toast({
      message: '请先在设备编辑页，绑定该设备！',
      duration: 1.0
    })
    return
  }
  param.curveNum = CurveNum.num(curveNum.num)
  request.curveNum(param, (state, msg, data) => {
    callback(state, msg)
    this.__realtime()
  })
}
/* TODO 分机烘烤曲线 */
HomeVM.prototype.curveCoding = function (coding) {
  let param = JSON.parse(JSON.stringify(this.mid))
  if (!param.bind) {
    this.modal.toast({
      message: '请先在设备编辑页，绑定该设备！',
      duration: 1.0
    })
    return
  }
  param.coding = coding
  request.curveCoding(param, (state, msg, data) => {
    this.coding = data.coding
    this.__realtime()
  })
}
/* TODO 设置分机上/下棚 */
HomeVM.prototype.setShed = function (shed, callback) {
  let param = JSON.parse(JSON.stringify(this.mid))
  param.shed = shed
  if (!param.bind) {
    this.modal.toast({
      message: '请先在设备编辑页，绑定该设备！',
      duration: 1.0
    })
    return
  }
  request.shed(param, (state, msg, data) => {
    if (state === State.success) {
      this.shed = data.shed
      // this.__dealShed()
    }
    if (callback !== undefined) {
      callback(state, msg)
    }
    this.__realtime()
  })
}
/* TODO 分机运行/停止控制 */
HomeVM.prototype.setRun = function (callback) {
  let param = JSON.parse(JSON.stringify(this.mid))
  if (!param.bind) {
    this.modal.toast({
      message: '请先在设备编辑页，绑定该设备！',
      duration: 1.0
    })
    return
  }
  param.run = this.run
  request.run(param, (state, msg, data) => {
    if (state === State.success) {
      this.run = data.run
    }
    callback(state, msg)
    this.__realtime()
  })
}
/* TODO 设备状态 */
HomeVM.prototype.__status = function (callback) {
  let param = JSON.parse(JSON.stringify(this.mid))
  const self = this
  request.status(param, (state, msg, data) => {
    if (state !== State.success) {
      callback(state, msg)
      return
    }
    self.type = data.type
    self.treatyVersions = data.treatyVersions
    self.versions = data.version
    callback(state, msg)
  })
}
/* TODO 实时状态 */
HomeVM.prototype.__realtime = function (callback) {
  let param = JSON.parse(JSON.stringify(this.mid))
  request.realTime(param, (state, msg, data) => {
    if (state !== State.success) {
      if (callback !== undefined) {
        callback(state, msg)
      }
      return
    }
    this.coding = data.coding
    this.run = data.run
    this.shed = data.shed
    this.subAlarm = data.subAlarm
    this.dryT = data.dryT.toFixed(2)
    this.wetT = data.wetT.toFixed(2)
    this.time = data.time
    this.timeTotal = data.timeTotal
    this.dryAim = data.dryAim.toFixed(0)
    this.wetAim = data.wetAim.toFixed(1)
    this.voltage = data.voltage
    this.isAlarm = data.isAlarm
    this.voltageStatus = data.voltageStatus
    this.isFanOn = data.isFanOn
    this.fan = data.fan
    this.warm = data.warm
    this.intakeOn = data.intakeOn
    this.alarmStatus = data.alarmStatus
    this.dryTHelp = data.dryTHelp.toFixed(2)
    this.wetTHelp = data.wetTHelp.toFixed(2)

    let currentCurve = data.currentCurve
    let up = currentCurve.up
    let wet = currentCurve.wet.toFixed(1)
    let dry = currentCurve.dry.toFixed(0)
    let steady = currentCurve.steady
    let curveNum = new CurveNum(data.curveNum, true)

    this.currentCurve = new Curve(up, wet, dry, steady, curveNum)
    this.__dealCurves()
    this.__dealShed()

    if (this.mid.bind !== data.isbind) {
      let param0 = JSON.parse(JSON.stringify(this.mid))
      param0.isbind = data.isbind

      console.log(JSON.stringify(param0))
      request.bindService(param0, (state0, msg0, data0) => {
        if (state0 === State.success) {
          this.mid.bind = data.isbind
          console.log(JSON.stringify(this.mid))
        }
        this.__realtime()
      })
    }
    this.__realtime()
    if (callback !== undefined) {
      callback(state, msg)
    }
  })
}
/* TODO 当前曲线运行名字 */
HomeVM.prototype.getCurTitle = function () {
  return this.currentCurve.num.title
}
/* TODO 当前曲线运行阶段 */
HomeVM.prototype.getCurPhase = function () {
  return this.currentCurve.num.phase
}
/* TODO 警报信息 */
HomeVM.prototype.hasBug = function () {
  return this.alarmStatus.length !== 0 ? '' : '(正常)'
}
/* TODO 日期 烤次 */
HomeVM.prototype.__time = function (callback) {
  let param = JSON.parse(JSON.stringify(this.mid))
  request.time(RW.read, param, (state, msg, data) => {
    if (state !== State.success) {
      callback(state, msg)
      return
    }
    this.bakeTimes = data.bakeTimes
    this.year = data.year
    this.month = data.month
    this.day = data.day
    this.hour = data.hour
    this.minute = data.minute
    callback(state, msg)
  })
}

HomeVM.prototype.setTime = function (param, callback) {
  let param0 = JSON.parse(JSON.stringify(this.mid))
  if (!param0.bind) {
    this.modal.toast({
      message: '请先在设备编辑页，绑定该设备！',
      duration: 1.0
    })
    return
  }
  if (!param.hasOwnProperty('bakeTimes')) {
    param.bakeTimes = this.bakeTimes
  }
  if (!param.hasOwnProperty('year')) {
    param.year = this.year
  }
  if (!param.hasOwnProperty('month')) {
    param.month = this.month
  }
  if (!param.hasOwnProperty('day')) {
    param.day = this.day
  }
  if (!param.hasOwnProperty('hour')) {
    param.hour = this.hour
  }
  if (!param.hasOwnProperty('minute')) {
    param.minute = this.minute
  }
  let assign = Object.assign(param, this.mid)
  request.time(RW.write, assign, (state, msg, data) => {
    if (state !== State.success) {
      callback(state, msg)
      return
    }
    this.bakeTimes = data.bakeTimes
    this.year = data.year
    this.month = data.month
    this.day = data.day
    this.hour = data.hour
    this.minute = data.minute
    callback(state, msg)
    this.__realtime()
  })
}

HomeVM.prototype.__dealCurves = function () {
  if (this.curves === undefined || this.curves === null) {
    return
  }
  let displayCurves = []
  for (let i = 0, len = this.curves.length; i < len; i++) {
    displayCurves.push(this.curves[i])
  }
  this.displayCurves = displayCurves
}

HomeVM.prototype.__dealShed = function () {
  if (this.shed === Shed.up) {
    this.sheds[0].checked = true
    this.sheds[1].checked = false
  } else {
    this.sheds[0].checked = false
    this.sheds[1].checked = true
  }
}
