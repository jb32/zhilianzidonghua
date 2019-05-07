<template>
    <div @viewdisappear="onviewdisappear">
        <nav-bar title="记录数据" left="返回"></nav-bar>
        <wxc-searchbar placeholder="请输入烤次"
                       input-type="tel"
                       return-key-type="search"
                       @wxcSearchbarInputOnBlur="toSearch" ref="searchBar"></wxc-searchbar>
        <text class="title maxFont">第{{baketimeNames[recordVM.bakeTimes]}}烤 (记录总数:{{recordVM.totalPage}})</text>
        <list ref="record_list">
            <cell v-for="(item, i) in recordVM.currents" :key="i" class="cell0">
                <div class="content">
                    <text class="middleFont">{{item.getRecodDate()}}</text>
                    <div class="cell_base">
                        <text class="minFont">编号：{{item.record}}</text>
                        <text class="minFont">{{item.shedName()}}</text>
                        <text class="minFont">{{item.tStatusName()}}</text>
                    </div>
                    <div class="cell_base">
                        <text class="minFont">干球温度：{{item.dry}}℃</text>
                        <text class="minFont">目标：{{item.dryAim}}℃</text>
                    </div>
                    <div class="cell_base">
                        <text class="minFont">湿球温度：{{item.wet}}℃</text>
                        <text class="minFont">目标：{{item.wetAim}}℃</text>
                    </div>
                    <div class="cell_base">
                        <text class="minFont">记录类型</text>
                        <text class="minFont">{{item.typeName()}}</text>
                    </div>
                    <div class="cell_base">
                        <text class="minFont">总时间:{{item.total}}h</text>
                    </div>
                    <div class="cell_base">
                        <text class="minFont">{{item.eventName()}}</text>
                    </div>
                </div>
            </cell>
            <cell v-if="recordVM.loadmore" style="padding-left: 20px; padding-right: 20px">
                <div class="loading" @click="to_loading">
                    <text style="font-size: 34px">加载更多</text>
                </div>
            </cell>
        </list>
    </div>
</template>

<script>
import NavBar from './components/NavBar'
import {RecordVM} from './js/RecordVM'
import UILine from './components/UILine'
import FlexWap from './components/FlexWap'
import {WxcTabPage, WxcSearchbar} from 'weex-ui'
import {Shed} from './js/Curve'
import {RW, SubOrder} from './js/Order'
import {request} from './js/Request'

const userInfoModule = weex.requireModule('UserInfoModule')

export default {
  name: 'RecordViewController',
  components: {FlexWap, UILine, NavBar, WxcTabPage, WxcSearchbar},
  data: function () {
    return {
      sheds: {},
      baketimeNames: ['零', '一', '二', '三', '四', '五', '六', '七', '八', '九'],
      is_loading: false,
      recordVM: new RecordVM(),
      bakeTimeArr: [{title: '第一烤'}, {title: '第二烤'}, {title: '第三烤'}, {title: '第四烤'}, {title: '第五烤'}, {title: '第六烤'}, {title: '第七烤'}, {title: '第八烤'}, {title: '第九烤'}],
      tabStyles: {
        bgColor: '#f5f5f5',
        titleColor: '#666666',
        activeTitleColor: '#3D3D3D',
        activeBgColor: '#f5f5f5',
        isActiveTitleBold: true,
        width: 160,
        height: 88,
        fontSize: 34,
        hasActiveBottom: true,
        activeBottomColor: '#0088fb',
        activeBottomHeight: 6,
        activeBottomWidth: 120,
        textPaddingLeft: 10,
        textPaddingRight: 10,
        normalBottomColor: '#ffffff',
        normalBottomHeight: 1,
        rightOffset: 100
      },
      currentRecords: []
    }
  },
  created () {
    this.sheds = Shed.names
    const self = this
    userInfoModule.getParam(e => {
      self.recordVM.mid = JSON.parse(JSON.stringify(e.mid))

      self.recordVM.init(e.bakeTimes, () => {
        self.currentRecords = self.recordVM.currents
      })
    })
  },
  methods: {
    onviewdisappear () {
      request.interrupt(SubOrder.record, RW.read)
    },
    toPage (e) {
      this.recordVM.getRecord(e.page)
    },
    to_loading (e) {
      // const self = this
      this.recordVM.next(() => {
      })
    },
    toSearch (e) {
      const times = parseInt(e.value)
      console.log(times, '--------------------------')
      this.$refs.searchBar.autoBlur()
      console.log(times, '------------autoBlur--------------')
      // 重新
      this.recordVM.init(times, () => {

      })
    }
  }
}
</script>

<style scoped>
    .minFont {
        font-size: 38px;
    }
    .middleFont {
        font-size: 40px;
    }
    .maxFont {
        font-size: 70px;
    }
    .title {
        margin: 20px;
    }
    .cell0 {
        padding: 20px;
    }
    .content {
        padding: 10px;
        background-color: whitesmoke;
        border-radius: 10px;
    }
    .cell_base {
        flex-direction: row;
        justify-content: space-between;
    }
    .loading {
        height: 88px;
        margin-bottom: 40px;
        justify-content: center;
        align-items: center;
        background-color: whitesmoke;
    }
</style>
