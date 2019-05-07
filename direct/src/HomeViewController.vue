<template>
    <div @viewappear="onViewAppear" @viewdisappear="onViewDisappear">
        <nav-bar
                title="实时监控"
                left="返回"
                :right="rightTitle"
                @rightButtonClicked="toRight"></nav-bar>
        <list>
            <cell>
                <text style="text-align: center; margin-top: 20px; font-size: 34px">{{homeVM.mid.remark}}</text>
            </cell>
            <cell>
                <div class="layout">
                    <div class="layout0">
                        <radio v-if="env.platform === 'android'" class="radio" style="height: 120px" :list="homeVM.sheds" @radioListChecked="toShed"></radio>
                        <radio v-if="env.platform !== 'android'" class="radio" :list="homeVM.sheds" @radioListChecked="toShed"></radio>
                        <div class="temperature">
                            <text class="tName minFont">干球温度℃</text>
                            <text class="tValue0 maxFont">{{homeVM.dryT}}</text>
                        </div>
                        <div class="temperature">
                            <text class="tName minFont">湿球温度℃</text>
                            <text class="tValue1 maxFont">{{homeVM.wetT}}</text>
                        </div>
                    </div>
                    <div class="layout1">
                        <div :class="[homeVM.run ? 'rundiv' : 'rundiv0']">
                            <text :class="[homeVM.run ? 'runText': 'runText0']">{{homeVM.run ? '运行' : '停止'}}</text>
                        </div>
                        <div class="targetdiv">
                            <text class="targetText minFont">目标：{{homeVM.dryAim}}</text>
                        </div>
                        <div class="targetdiv">
                            <text class="targetText minFont">目标：{{homeVM.wetAim}}</text>
                        </div>
                    </div>
                </div>
            </cell>
            <cell>
                <div class="layout2">
                    <text class="tName minFont">阶段时间：{{homeVM.time}}</text>
                    <text class="tName minFont">总时间: {{homeVM.timeTotal}}</text>
                </div>
            </cell>
            <cell style="flex-direction: row">
                <div class="layout2">
                    <text class="minFont">报警状态: {{homeVM.hasBug()}}</text>
                    <flex-wap :list="homeVM.alarmStatus" :width="510"></flex-wap>
                </div>
            </cell>
            <cell>
                <div class="layout4">
                    <segment-control :activeIndex="homeVM.coding" :items="homeVM.codings" @segmentClicked="doSegment"></segment-control>
                </div>
            </cell>
            <cell>
                <div v-if="!isShowDetail && homeVM.currentCurve.hasOwnProperty('num')" class="layout5_1">
                    <div>
                        <div class="cuverTitle">
                            <text class="cuverTitleText minFont">{{homeVM.getCurTitle()}}</text>
                            <text class="cuverTitleText0 minFont">(当前{{homeVM.getCurPhase()}})</text>
                        </div>
                        <div class="cuverContent">
                            <div class="cuverContent0">
                                <text class="cuverContentText minFont" @click="toChangeDry(homeVM.currentCurve)">干球温度：{{homeVM.currentCurve.dry}}℃</text>
                                <text class="cuverContentText minFont" @click="toChangeUp(homeVM.currentCurve)">升温时间：{{homeVM.currentCurve.up}}h</text>
                                <!--<text class="cuverContentText minFont" @click="toChangeWind">风机转速：{{item.wind}}%</text>-->
                            </div>
                            <div class="cuverContent1">
                                <text class="cuverContentText0 minFont" @click="toChangeWet(homeVM.currentCurve)">湿球温度：{{homeVM.currentCurve.wet}}℃</text>
                                <text class="cuverContentText0 minFont" @click="toChangeSteady(homeVM.currentCurve)">恒温时间：{{homeVM.currentCurve.steady}}h</text>
                            </div>
                        </div>
                    </div>
                    <u-i-line></u-i-line>
                    <div class="cellButton">
                        <text class="cellButtonTxt_left" @click="doDetail">更多……</text>
                        <text v-if="homeVM.currentCurve.num.value !== 0" class="cellButtonTxt_right" @click="doCurveNum(homeVM.currentCurve)">切换到{{ homeVM.currentCurve.num.reversePhase }}</text>
                    </div>
                </div>
                <div v-if="isShowDetail && homeVM.currentCurve.hasOwnProperty('num')" class="layout5_2">
                    <div>
                        <div class="cuverTitle">
                            <text class="cuverTitleText_1 minFont">{{homeVM.getCurTitle()}}</text>
                            <text class="cuverTitleText0_1 minFont">(当前{{homeVM.getCurPhase()}})</text>
                        </div>
                        <div class="cuverContent">
                            <div class="cuverContent0">
                                <text class="cuverContentText_1 minFont" @click="toChangeDry(homeVM.currentCurve)">干球温度：{{homeVM.currentCurve.dry}}℃</text>
                                <text class="cuverContentText_1 minFont" @click="toChangeUp(homeVM.currentCurve)">升温时间：{{homeVM.currentCurve.up}}h</text>
                            </div>
                            <div class="cuverContent1">
                                <text class="cuverContentText0_1 minFont" @click="toChangeWet(homeVM.currentCurve)">湿球温度：{{homeVM.currentCurve.wet}}℃</text>
                                <text class="cuverContentText0_1 minFont" @click="toChangeSteady(homeVM.currentCurve)">恒温时间：{{homeVM.currentCurve.steady}}h</text>
                            </div>
                        </div>
                    </div>
                    <u-i-line></u-i-line>
                    <div class="cellButton">
                        <text class="cellButtonTxt_left_selected" @click="doDetail">收起</text>
                        <text v-if="homeVM.currentCurve.num.value !== 0" class="cellButtonTxt_right_selected" @click="doCurveNum(homeVM.currentCurve)">切换到{{ homeVM.currentCurve.num.reversePhase }}</text>
                    </div>
                </div>
            </cell>
            <cell v-if="isShowDetail" v-for="(item, i) in homeVM.displayCurves" :key="i" style="padding: 10px">
                <div class="layout6">
                    <text class="cuverTitleText1 minFont">{{item.num.title}}</text>
                    <div class="cuverContent">
                        <div class="cuverContent0">
                            <text class="cuverContentText minFont" @click="toChangeDry(item)">干球温度：{{item.dry}}℃</text>
                            <text class="cuverContentText minFont" @click="toChangeUp(item)">升温时间：{{item.up}}h</text>
                        </div>
                        <div class="cuverContent1">
                            <text class="cuverContentText0 minFont" @click="toChangeWet(item)">湿球温度：{{item.wet}}℃</text>
                            <text class="cuverContentText0 minFont" @click="toChangeSteady(item)">恒温时间：{{item.steady}}h</text>
                        </div>
                    </div>
                    <u-i-line></u-i-line>
                    <div class="cellButton">
                        <text v-if="item.num.value !== 0" class="cellButtonTxt_left" @click="doCurveNum(item, Phase.up)">切换到升温</text>
                        <text class="cellButtonTxt_right" @click="doCurveNum(item, Phase.steady)">切换到恒温</text>
                    </div>
                </div>
            </cell>
            <cell>
                <div  class="layout7">
                    <text :class="[homeVM.warm ? 'statusOn': 'statusOff']">助燃</text>
                    <text :class="[homeVM.intakeOn ? 'statusOn': 'statusOff']">排湿</text>
                    <text class="minFont">电压 {{homeVM.voltage}} V</text>
                    <text :class="[homeVM.isFanOn ? 'statusOn': 'statusOff']">循环机风速 {{homeVM.fan}}</text>
                </div>
            </cell>
            <cell>
                <div class="layout7">
                    <text class="minFont" @click="toRoast">第{{homeVM.bakeTimes}}烤</text>
                    <text class="minFont" @click="toDate">20{{homeVM.year > 9 ? homeVM.year : ('0' + homeVM.year)}}年{{homeVM.month}}月{{homeVM.day}}日</text>
                    <text class="minFont" @click="toTime">{{homeVM.hour}}:{{homeVM.minute}}</text>
                </div>
            </cell>
        </list>
        <div class="layout8">
            <u-i-button class="bottomBtn"
                        :title="homeVM.run ? '停止' : '运行'"
                        bgColor="white"
                        color="black"
                        :borderRadius="0"
                        @doClick="toRun"></u-i-button>
            <u-i-button class="bottomBtnMiddle"
                        title="查询记录"
                        bgColor="gray"
                        color="white"
                        :borderRadius="0"
                        @doClick="toRecord"></u-i-button>
            <u-i-button class="bottomBtn"
                        :borderRadius="0"
                        title="设置"
                        bgColor="white"
                        color="black"
                        @doClick="toSet"></u-i-button>
        </div>
        <wxc-mask height="450" width="650" border-radius="10"
                  duration="200" mask-bg-color="#FFFFFF"
                  :has-animation="true" :has-overlay="true"
                  :show-close="flase" :show="isShowShed"
                  @wxcMaskSetHidden="toHiddenShed">
            <div class="alert">
                <text class="middleFont alertTitle">{{targetTitle}}</text>
                <div class="layout">
                    <div class="layout0">
                        <div class="temperature">
                            <text class="tName minFont">干球温度℃</text>
                            <text class="tValue0 maxFont">{{homeVM.dryTHelp}}</text>
                        </div>
                        <div class="temperature">
                            <text class="tName minFont">湿球温度℃</text>
                            <text class="tValue1 maxFont">{{homeVM.wetTHelp}}</text>
                        </div>
                    </div>
                </div>
                <div class="alertBtttonDiv">
                    <text class="alertBttton0 minFont" @click="toHiddenShed">取消</text>
                    <text class="alertBttton2 minFont" @click="doShed">切换到{{target}}</text>
                </div>
            </div>
        </wxc-mask>
    </div>
</template>

<script>
import { WxcButton, WxcMask, WxcPopup } from 'weex-ui'
import Radio from './components/Radio'
import NavBar from './components/NavBar'
import SegmentControl from './components/SegmentControl'
import { request, State } from './js/Request'
import UILine from './components/UILine'
import { RW, SubOrder } from './js/Order'
import { HomeVM } from './js/HomeVM'
import { Shed, Coding, Phase } from './js/Curve'
import FlexWap from './components/FlexWap'
import UIButton from './components/UIButton'

const modal = weex.requireModule('modal')
const userInfoModule = weex.requireModule('UserInfoModule')
const navigator = weex.requireModule('navigator')
const picker = weex.requireModule('picker')

export default {
  name: 'HomeViewController',
  components: {
    UIButton,
    FlexWap,
    UILine,
    NavBar,
    Radio,
    SegmentControl,
    WxcButton,
    WxcMask,
    WxcPopup
  },
  data () {
    return {
      Phase: Phase,
      env: weex.config.env,
      rightTitle: '',
      roastNum: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
      isShowDetail: false,
      isShowConfrom: false,
      isCuverModel: false,
      isCuver: false,
      isShowShed: false,
      homeVM: new HomeVM(),
      intakeOn: true,
      isFanOn: false,
      warm: false
    }
  },
  created: function () {
  },
  beforeDestroy () {
  },
  destroyed () {
  },
  methods: {
    onViewAppear () {
      let self = this

      userInfoModule.getParam(mid => {
        self.homeVM.mid = mid
        self.homeVM.created((state, msg) => {
          if (self.homeVM.type[1] === 'S') {
            navigator.setNavBarRightItem(
              { title: '燃烧机', titleColor: '#000000' },
              () => {}
            )
            self.rightTitle = '燃烧机'
          } else {
            navigator.setNavBarRightItem(
              { title: '', titleColor: '#000000' },
              () => {}
            )
            self.rightTitle = ''
          }
        })
      })
    },
    onViewDisappear () {
      request.interrupt(SubOrder.status, RW.read)
      request.interrupt(SubOrder.realTime, RW.read)
      request.interrupt(SubOrder.time, RW.read)
      request.interrupt(SubOrder.curves, RW.read)
    },
    // TODO 显示全部曲线数据
    doDetail () {
      this.isShowDetail = !this.isShowDetail
      let self = this

      if (this.isShowDetail) {
        this.homeVM.getCurves((state, msg) => {
          if (state !== State.success) {
            self.isShowDetail = false
          }
        })
      } else {
        request.interrupt(SubOrder.curves, RW.read)
      }
    },
    /* TODO 切换曲线段号 */
    doCurveNum (item, phase) {
      if (phase !== undefined) {
        item.num.phaseValue = phase
        item.num.reversePhase = Phase.names[phase]
      } else {
        item.num.phaseValue = item.num.reverseValue
      }
      const message = '是否切换到' + item.num.title + item.num.reversePhase
      modal.confirm(
        {
          message: message,
          okTitle: '确定',
          cancelTitle: '取消'
        },
        result => {
          if (result === '确定') {
            this.isShowDetail = false
            this.homeVM.setCurveNum(item, (state, msg) => {})
          }
        }
      )
    },
    // TODO 切换曲线模式
    doSegment (e) {
      if (!this.homeVM.handler) {
        modal.toast({
          message: '请稍等……',
          duration: 1
        })
        return
      }
      const coding = e.data
      const name = Coding.names[coding]

      modal.confirm({
        message: '是否切换到' + name + '曲线',
        cancelTitle: '否',
        okTitle: '是'
      }, result => {
        if (result === '否') {
          e.callback(false)
        } else {
          e.callback(false)
          this.homeVM.curveCoding(coding)
        }
      })
    },
    // TODO 干球温度
    toChangeDry (item) {
      modal.prompt({
        message: item.num.title + '干球温度',
        cancelTitle: '否',
        okTitle: '是'
      }, res => {
        if (res.result === '否') {} else {
          let curve = JSON.parse(JSON.stringify(item))
          curve.dry = res.data
          this.homeVM.setCurve(curve)
        }
      })
    },
    /// TODO 湿球温度
    toChangeWet (item) {
      modal.prompt({
        message: item.num.title + '湿球温度',
        cancelTitle: '否',
        okTitle: '是'
      }, res => {
        if (res.result === '否') {} else {
          let curve = JSON.parse(JSON.stringify(item))
          curve.wet = parseFloat(res.data).toFixed(1)
          this.homeVM.setCurve(curve)
        }
      })
    },
    /// TODO 升温时间
    toChangeUp (item) {
      modal.prompt({
        message: item.num.title + '升温时间',
        cancelTitle: '否',
        okTitle: '是'
      }, res => {
        if (res.result === '否') {} else {
          let curve = JSON.parse(JSON.stringify(item))
          curve.up = res.data
          this.homeVM.setCurve(curve)
        }
      })
    },
    /// TODO 恒温时间
    toChangeSteady (item) {
      modal.prompt({
        message: item.num.title + '恒温时间',
        cancelTitle: '否',
        okTitle: '是'
      }, res => {
        if (res.result === '否') {} else {
          let curve = JSON.parse(JSON.stringify(item))
          curve.steady = res.data
          this.homeVM.setCurve(curve)
        }
      })
    },
    /// TODO 上下棚
    toHiddenShed (e) {
      this.isShowShed = false
      this.changeShed(0)
    },
    toShed (e) {
      if (!this.homeVM.handler) {
        modal.toast({
          message: '请稍等……',
          duration: 1
        })
        return
      }
      const shed = e.index === 0 ? Shed.up : Shed.down
      this.targetTitle = e.title
      this.target = e.title
      this.isShowShed = true
      this.changeShed = index => {
        this.isShowShed = false

        if (index === 0) {
          e.callback(false)
        } else if (index === 1) {
          e.callback(false)
          this.homeVM.setShed(shed)
        }
      }
    },
    doShed () {
      this.changeShed(1)
    },
    toRoast () {
      if (!this.homeVM.handler) {
        modal.toast({
          message: '请稍等……',
          duration: 1
        })
        return
      }
      const times = this.homeVM.bakeTimes
      picker.pick(
        {
          title: '修改烤次',
          confirmTitle: '确认',
          cancelTitle: '取消',
          index: times,
          items: this.roastNum
        },
        event => {
          if (event.result === 'success') {
            const bakeTimes = event.data
            this.homeVM.setTime({ bakeTimes }, () => {})
          }
        }
      )
    },
    // TODO 分机烤次及日期时间
    toTime () {
      if (!this.homeVM.handler) {
        modal.toast({
          message: '请稍等……',
          duration: 1
        })
        return
      }
      const aDate = this.homeVM.hour + ':' + this.homeVM.minute
      picker.pickTime(
        {
          value: aDate
        },
        event => {
          if (event.result === 'success') {
            const arr = event.data.split(':')
            const hour = parseInt(arr[0])
            const minute = parseInt(arr[1])
            this.homeVM.setTime({ hour, minute }, () => {})
          }
        }
      )
    },
    toDate () {
      if (!this.homeVM.handler) {
        modal.toast({
          message: '请稍等……',
          duration: 1
        })
        return
      }
      const aDate = '20' + (this.homeVM.year > 9 ? this.homeVM.year : ('0' + this.homeVM.year)) + '-' + this.homeVM.month + '-' + this.homeVM.day
      console.log(aDate, '--------------------------------------')
      picker.pickDate({
        value: aDate,
        min: '2000-01-01',
        max: '2099-12-31'
      },
      event => {
        if (event.result === 'success') {
          const arr = event.data.split('-')
          const year = parseInt(arr[0]) - 2000
          const month = parseInt(arr[1])
          const day = parseInt(arr[2])
          this.homeVM.setTime({ year, month, day }, () => {})
        }
      })
    },
    /// TODO 分机运行/停止控制
    toRun () {
      if (!this.homeVM.handler) {
        modal.toast({
          message: '请稍等……',
          duration: 1
        })
        return
      }
      let okTitle = this.homeVM.run ? '停止' : '开启'
      let cancelTitle = '取消'
      let message = this.homeVM.run ? '是否停止运行?' : '是否开启设备?'
      modal.confirm({ message, okTitle, cancelTitle }, e => {
        if (e === okTitle) {
          this.homeVM.run = this.homeVM.run === 0 ? 1 : 0
          this.homeVM.setRun(() => {})
        }
      })
    },
    /// TODO 记录
    toRecord () {
      if (!this.homeVM.handler) {
        modal.toast({
          message: '请稍等……',
          duration: 1
        })
        return
      }
      const url = `${weex.config.bundleUrl}RecordViewController.js`
      let param = { mid: JSON.parse(JSON.stringify(this.homeVM.mid)) }
      param.bakeTimes = this.homeVM.bakeTimes

      navigator.push(
        {
          url: url,
          animated: 'true',
          param: param
        },
        function (e) {
          console.log(e)
        }
      )
    },
    toSet () {
      const url = `${weex.config.bundleUrl}SetHomeViewController.js`
      navigator.push({
        url: url,
        animated: 'true'
      })
    },
    toRight () {
      console.log('toRight----------')
      const url = `${weex.config.bundleUrl}BurnerViewController.js`
      const param = JSON.parse(JSON.stringify(this.homeVM.mid))
      if (this.homeVM.type[1] === 'S') {
        navigator.push({
          url: url,
          animated: 'true',
          param: param
        })
      }
    }
  }
}
</script>

<style scoped src="./css/Home.css">
</style>
