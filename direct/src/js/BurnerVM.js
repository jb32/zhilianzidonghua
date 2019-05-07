import {request, State} from './Request'

const status = ['空闲', '预进料', '点火', '加热缓冲', '正常燃烧', '关机阶段']

export function BurnerVM () {
  this.status = 0
  this.alarm = []
  this.fire = 0
  this.times = 0
  this.thermocouple = 0
  this.mid = {}

  this.modal = weex.requireModule('modal')
}

BurnerVM.prototype.statusName = function () {
  return status[this.status]
}

BurnerVM.prototype.alarmName = function () {
  if (this.alarm.length === 0) {
    return '正常'
  }
  return this.alarm.join(',')
}

BurnerVM.prototype.isOn = function () {
  return this.status !== 0 || this.status !== 5
}

BurnerVM.prototype.toStatus = function () {
  const mid = JSON.parse(JSON.stringify(this.mid))
  request.burner_args(mid, (state, msg, data) => {
    if (state === State.success) {
      this.status = data.status
      this.alarm = data.alarm
      this.fire = data.fire
      this.times = data.times
      this.thermocouple = data.thermocouple
    }
    this.toStatus()
  })
}

BurnerVM.prototype.toFire = function () {
  const mid = JSON.parse(JSON.stringify(this.mid))
  request.burner_fire(mid, (state, msg, data) => {
    if (state === State.success) {
      this.status = data.status
      this.toStatus()
    }
  })
}

BurnerVM.prototype.toOff = function () {
  const mid = JSON.parse(JSON.stringify(this.mid))
  request.burner_off(mid, (state, msg, data) => {
    if (state === State.success) {
      this.status = data.status
      this.toStatus()
    }
  })
}

BurnerVM.prototype.interrupt = function (sub, rw) {
  request.interrupt(sub, rw)
}
