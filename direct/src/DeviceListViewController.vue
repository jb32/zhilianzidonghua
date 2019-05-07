<template>
    <div @viewappear="onViewappear" @viewdisappear="onViewdisappear">
        <nav-bar
                title="设备列表"
                :left="left_title"
                useDefaultReturn=false
                @leftButtonClicked="toMy"
                right="添加"
                @rightButtonClicked="toAdd"></nav-bar>
        <list v-if="!isResult">
            <cell v-for="(item, index) in dataArr" :key="index" @click="toHome(index, $event)">
                <div class="cell">
                    <div>
                        <div class="edit">
                            <text class="alias">{{item.remark}}</text>
                            <text class="online">({{item.online ? '在线': '离线'}})</text>
                        </div>
                        <text style="font-size: 34px">ID：{{item.mid}}</text>
                    </div>
                    <u-i-button class="editButton" title="编辑" @doClick="toEdit(index, $event)"></u-i-button>
                </div>
                <div style="height: 1px; background-color: #dddddd"></div>
            </cell>
        </list>
        <div v-if="isResult" class="result">
            <text style="font-size: 40px">您还没有添加任何设备</text>
            <u-i-button class="editButton" title="刷新" @doClick="netDatas" bgColor="#828282"></u-i-button>
        </div>
    </div>
</template>

<script>
import NavBar from './components/NavBar'
import {request, State} from './js/Request'
import {storage} from './js/Storage'
import UIButton from './components/UIButton'
import {RW, SubOrder} from './js/Order'

const navigator = weex.requireModule('navigator')

export default {
  name: 'DeviceListViewController',
  components: {
    UIButton,
    NavBar
  },
  data () {
    return {
      dataArr: [],
      isResult: true,
      left_title: '登录',
      isDisappear: false
    }
  },
  watch: {
    dataArr (newList) {
      this.isResult = newList.length <= 0
    }
  },
  created () {
    console.log('DeviceListViewController created')
  },
  beforeDestroy () {
    request.interrupt(SubOrder.devices, RW.read)
  },
  methods: {
    onViewappear: function () {
      console.log('DeviceListViewController onViewappear')
      this.isDisappear = false
      const self = this
      storage.token((success, data) => {
        if (success) {
          navigator.setNavBarLeftItem({title: '我的', titleColor: '#000000'})
          self.left_title = '我的'
          self.netDevice()
        } else {
          navigator.setNavBarLeftItem({title: '登录', titleColor: '#000000'})
          self.left_title = '登录'
        }
      })
    },
    onViewdisappear: function () {
      console.log('DeviceListViewController onViewdisappear')
      this.isDisappear = true
      request.interrupt(SubOrder.devices, RW.read)
    },
    netDevice () {
      if (this.isDisappear) {
        return
      }
      const self = this
      request.devices((state, msg, data, ip, port) => {
        self.isRefresh = false
        self.ip = ip
        self.port = port

        if (state === State.success) {
          self.dataArr = data
        }
        self.netDevice()
      })
    },
    toAdd () {
      const url = weex.config.bundleUrl + 'AddDeviceViewController.js'
      navigator.push({
        url: url,
        animated: true
      })
    },
    toMy () {
      storage.token((success, data) => {
        if (success) {
          const url = weex.config.bundleUrl + 'MyViewController.js'
          navigator.push({
            url: url,
            animated: true
          })
        } else {
          const url = weex.config.bundleUrl + 'LoginViewController.js'
          navigator.push({
            url: url,
            animated: true
          })
        }
      })
    },
    toEdit (i, e) {
      const url = weex.config.bundleUrl + 'EditDeviceViewController.js'
      const param = { data: this.dataArr[i] }

      navigator.push({
        url: url,
        animated: true,
        param: param
      })
    },
    toHome (i, e) {
      let mid = this.dataArr[i]
      const url = weex.config.bundleUrl + 'HomeViewController.js'

      console.log(mid.ip, ' ', this.ip)

      if (mid.ip === this.ip) {
        mid.isLocal = true
      } else {
        mid.isLocal = false
      }
      navigator.push({
        url: url,
        animated: true,
        param: mid
      })
    }
  }
}
</script>

<style scoped>
.cell {
  margin: 40px;
  flex-direction: row;
  justify-content: space-between;
  align-items: center;
}
.edit {
  flex-direction: row;
}
.editButton {
  width: 120px;
  height: 70px;
}
.online {
  margin-left: 10px;
  font-size: 40px;
  color: #828282;
}
.alias {
  font-size: 40px;
  font-weight: bold;
}
.result {
  justify-content: center;
  align-items: center;
  height: 1120px;
}
</style>
