import {request} from './Request'
import {Shed, Phase} from './Curve'
import {SubOrder, RW} from './Order'

export let recordType = {
  time: 0,
  dry: 1,
  wet: 2,
  dryAim: 3,
  wetAim: 4,
  start: 5,
  run: 6,
  stop: 7,
  status: 8,
  onPower: 9,
  stopPower: 10
}
recordType.names = [
  '1小时时间到记录',
  '温度变化',
  '湿度变化',
  '温度目标变化',
  '湿度目标变化',
  '程序启动',
  '运行',
  '停止',
  '状态变化',
  '来电',
  '停电'
]

export function Record () {
  this.isGet = false

  this.bakeTimes = 0
  this.totalTimes = 0
  this.record = 0
  this.month = 0
  this.times = 0
  this.dry = 0
  this.wet = 0
  this.year = 0
  this.day = 0

  this.dryAim = 0
  this.hour = 0

  this.wetAim = 0
  this.minute = 0

  this.total = 0

  this.shed = 0
  this.events = []
  this.tStatus = 0

  this.type = 0
}

Record.prototype.shedName = function () {
  return Shed.names[this.shed]
}

Record.prototype.tStatusName = function () {
  return Phase.names[this.tStatus]
}

Record.prototype.typeName = function () {
  return recordType.names[this.type]
}

Record.prototype.getRecodDate = function () {
  let year = this.year > 9 ? '20' + this.year : '200' + this.year
  return year + '年 ' + this.month + '月 ' + this.day + '日 ' + this.hour + '时 ' + this.minute + '分'
}

Record.prototype.eventName = function () {
  return this.events.join(',')
}

export function RecordVM () {
  this.currents = []
  this.page = 0
  this.totalPage = 0

  this.bakeTimes = 0
  this.mid = {}
  this.modal = weex.requireModule('modal')
  this.dom = weex.requireModule('dom')
  this.loadmore = false
}
// 初始化
RecordVM.prototype.init = function (bakeTimes) {
  request.interrupt(SubOrder.record, RW.read)
  this.currents = []
  this.bakeTimes = bakeTimes
  this.page = 0
  this.totalPage = -1
  this.loadmore = false

  const self = this

  function recursion () {
    console.log(self.page, 'recursionrecursionrecursionrecursionrecursionrecursion')
    if (self.totalPage !== -1 && self.totalPage <= self.page) {
      self.loadmore = false
      return
    }
    if (self.page === 10) {
      self.loadmore = self.totalPage > self.page
      return
    }

    self.request(self.page, (state, msg, record) => {
      if (self.totalPage === 0) {
        return
      }
      self.currents.push(record)
      self.page++
      recursion()
    })
  }
  recursion()
}
// 更多
RecordVM.prototype.next = function (callback) {
  const page = this.page
  this.page++
  this.loadmore = false

  const self = this

  function recursion () {
    if (self.totalPage !== -1 && self.page >= self.totalPage) {
      self.loadmore = false
      callback()
      return
    }
    if (self.page === page + 10) {
      self.loadmore = self.totalPage > self.page
      callback()
      return
    }

    self.request(self.page, (state, msg, record) => {
      self.currents.push(record)
      self.page++
      recursion()
    })
  }
  recursion()
}

RecordVM.prototype.request = function (num, callback) {
  const self = this

  let param = JSON.parse(JSON.stringify(this.mid))
  param.bakeTimes = this.bakeTimes
  param.num = num

  request.getRecord(param, (state, msg, data) => {
    let record = new Record()
    record.bakeTimes = data.bakeTimes
    record.totalTimes = data.totalTimes
    if (record.totalTimes > 0) {
      record.record = data.record
      record.month = data.month
      record.times = data.times
      record.dry = parseFloat(data.dry.toFixed(2))
      record.wet = parseFloat(data.wet.toFixed(2))
      record.year = data.year
      record.day = data.day
      record.dryAim = parseInt(data.dryAim.toFixed(1))
      record.hour = data.hour
      record.wetAim = parseFloat(data.wetAim.toFixed(2))
      record.minute = data.minute
      record.total = data.total
      record.shed = data.shed
      record.events = data.events
      record.tStatus = data.tStatus

      let atype = data.type
      record.type = atype > 10 ? 0 : atype
    }
    self.totalPage = record.totalTimes
    self.page = num

    if (record.totalTimes === 0) {
      self.modal.toast({
        message: '该烤次没有记录',
        duration: 3
      })
    }
    if (callback !== undefined) {
      callback(state, msg, record)
    }
  })
}
