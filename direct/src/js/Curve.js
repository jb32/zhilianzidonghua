
export let Coding = { self: 0, down: 1, middle: 2, up: 3 }
Coding.names = ['自设', '下部叶', '中部叶', '上部叶']

export let Phase = { up: 0, steady: 1 }
Phase.names = ['升温', '恒温']

export let Shed = { down: 0, up: 1 }
Shed.names = ['下棚', '上棚']
Shed.reverseNames = ['上棚', '下棚']

export function CurveNum (value, isPhase = false) {
  if (!isPhase) {
    this.value = value
    if (value === 0) {
      this.phaseValue = 1
    } else {
      this.phaseValue = 0
    }
  } else {
    const aIndex = value % 2
    this.phase = Phase.names[aIndex]
    this.phaseValue = aIndex
    this.reverseValue = aIndex === 0 ? 1 : 0
    this.reversePhase = Phase.names[this.reverseValue]
    this.value = Math.floor(value / 2)
  }
  this.title = curveNumEnum[this.value]
}

CurveNum.num = function (num) {
  return num.value * 2 + num.phaseValue
}

export const curveNumEnum = ['一阶段', '二阶段', '三阶段', '四阶段', '五阶段',
  '六阶段', '七阶段', '八阶段', '九阶段', '十阶段']

export function Curve (up, wet, dry, steady, curveNum) {
  this.up = up
  this.wet = wet
  this.dry = dry
  this.steady = steady
  this.num = curveNum
}
