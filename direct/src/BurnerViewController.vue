<template>
    <div @viewappear="onViewAppear" @viewdisappear="onViewDisAppear">
        <nav-bar title="燃烧机" left="返回"></nav-bar>
        <list class="view">
           <cell class="cell">
               <div class="cell_div">
                   <text class="font">状态</text>
                   <text class="font">{{burnerVM.statusName()}}</text>
               </div>
               <u-i-line class="line"></u-i-line>
           </cell>
           <cell class="cell">
               <div class="cell_div">
                   <text class="cell_title font">报警</text>
                   <text class="cell_detail font">{{burnerVM.alarmName()}}</text>
               </div>
               <u-i-line class="line"></u-i-line>
           </cell>
           <cell class="cell">
               <div class="cell_div">
                   <text class="cell_title font">输出火力</text>
                   <text class="cell_detail font">{{burnerVM.fire}}%</text>
               </div>
               <u-i-line class="line"></u-i-line>
           </cell>
           <cell class="cell">
               <div class="cell_div">
                   <text class="cell_title font">已进料</text>
                   <text class="cell_detail font">{{burnerVM.times}}秒</text>
               </div>
               <u-i-line class="line"></u-i-line>
           </cell>
           <cell class="cell">
               <div class="cell_div">
                   <text class="cell_title font">热电偶温度</text>
                   <text class="cell_detail font">{{burnerVM.thermocouple}}度</text>
               </div>
           </cell>
        </list>
        <div class="bottom">
            <u-i-button class="bottom_btn" title="点火" bgColor="red" @doClick="toFire"></u-i-button>
            <u-i-button class="bottom_btn" :title="switchTitle" style="margin-left: 10px" @doClick="toOff"></u-i-button>
        </div>
    </div>
</template>

<script>
import NavBar from './components/NavBar'
import UILine from './components/UILine'
import UIButton from './components/UIButton'
import {BurnerVM} from './js/BurnerVM'
import {SubOrder, RW} from './js/Order'

const userInfoModule = weex.requireModule('UserInfoModule')

export default {
  name: 'BurnerViewController',
  components: {UIButton, UILine, NavBar},
  data () {
    return {
      burnerVM: new BurnerVM(),
      switchTitle: '关闭'
    }
  },
  methods: {
    onViewAppear () {
      const self = this
      userInfoModule.getParam(mid => {
        self.burnerVM.mid = mid
        self.toStatus()
      })
    },
    onViewDisAppear () {
      this.burnerVM.interrupt(SubOrder.burner_args, RW.read)
      this.burnerVM.interrupt(SubOrder.burner_fire, RW.write)
      this.burnerVM.interrupt(SubOrder.burner_off, RW.write)
    },
    toFire () {
      this.burnerVM.toFire()
    },
    toOff () {
      this.burnerVM.toOff()
    },
    toStatus () {
      this.burnerVM.toStatus()
    }
  }
}
</script>

<style scoped>
    .font {
        font-size: 38px;
    }
    .view {
        margin-top: 20px;
    }
    .line {
        margin-top: 20px;
    }
    .cell {
        padding-left: 20px;
        padding-right: 20px;
        padding-top: 20px;
    }
    .cell_div {
        flex-direction: row;
        justify-content: space-between;
    }
    .cell_title {
        justify-content: center;
    }
    .cell_detail {
        width: 300px;
        text-align: right;
    }
    .bottom {
        flex-direction: row;
        padding: 30px;
    }
    .bottom_btn {
        flex: 1;
        height: 70px;
    }
</style>
