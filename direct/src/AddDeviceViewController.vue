<template>
    <div>
        <nav-bar
                title="添加设备"
                left="返回"
                @leftButtonClicked="toBack"
                right="确定"
                @rightButtonClicked="toMakeSure"></nav-bar>
        <div class="inputSuper">
            <div style="flex-direction: row">
                <text class="inputName">设备ID：</text>
                <div class="scan" style="width: 500px">
                    <input class="input" type="text" placeholder="请输入设备ID" @input="midInput" :value="mid.id" ref="id" style="width: 420px"/>
                    <image v-if="env.platform !== 'Web'" class="image" resize="contain" src="locall://scan" @click="clickScan"></image>
                    <image v-if="env.platform === 'Web'" class="image" resize="contain" src="../../web/assets/logo.png"></image>
                </div>
            </div>
            <div style="flex-direction: row">
                <text class="inputName">备</text>
                <text class="inputName" style="padding-left: 38px">注：</text>
                <input class="input" type="text" placeholder="请输入备注" @input="remarkInput" :value="mid.remark" ref="remark" style="width: 520px"/>
            </div>
        </div>
    </div>
</template>

<script>
import NavBar from './components/NavBar'
import {request, State} from './js/Request'
import {WxcMask} from 'weex-ui'
import {RW, SubOrder} from './js/Order'
import Vue from 'vue'

const scanCode = weex.requireModule('ScanCode')
const modal = weex.requireModule('modal')
const navigator = weex.requireModule('navigator')

export default {
  name: 'AddDeviceViewController',
  components: {NavBar, WxcMask},
  data () {
    return {
      env: weex.config.env,
      mid: {}
    }
  },
  destroyed () {
    request.interrupt(SubOrder.addDevice, RW.read)
  },
  methods: {
    toBack () {},
    toMakeSure () {
      this.$refs.id.blur()
      this.$refs.remark.blur()
      let id = this.mid.id
      let remark = id

      if (this.mid.remark !== undefined) {
        remark = this.mid.remark
      }
      request.addDevice(id, remark, (state, msg, data) => {
        if (state === State.success) {
          modal.toast({
            message: msg,
            duration: 1
          })
          setTimeout(() => {
            navigator.pop({}, e => {})
          }, 3000)
        } else {
          modal.toast({
            message: msg,
            duration: 1
          })
        }
      })
    },
    midInput (e) {
      Vue.set(this.mid, 'id', e.value)
    },
    remarkInput (e) {
      Vue.set(this.mid, 'remark', e.value)
    },
    clickScan () {
      let self = this
      scanCode.scan(e => {
        Vue.set(self.mid, 'id', e)
      })
    }
  }
}
</script>

<style scoped>
    .inputSuper {
        margin-top: 20px;
        margin-left: 40px;
        margin-right: 40px;
    }
    .inputName {
        margin-top: 30px;
        font-size: 38px;
        color: #000000;
        height: 50px;
    }
    .input {
        font-size: 38px;
        margin-top: 30px;
        padding-left: 20px;
        height: 50px;
        background-color: whitesmoke;
    }

    .image {
        width: 80px;
        height: 40px;
        margin-top: 40px;
    }
    .scan {
        flex-direction: row;
    }
</style>
