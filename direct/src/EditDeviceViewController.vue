<template>
    <div>
        <nav-bar
                title="编辑"
                left="返回"
                @leftButtonClicked="toBack"
                right="确定"
                @rightButtonClicked="toMakeSure"></nav-bar>
        <div class="inputSuper">
            <div style="flex-direction: row">
                <text class="inputName">设备ID：</text>
                <text class="inputText">{{mid.mid}}</text>
            </div>
            <div style="flex-direction: row">
                <text class="inputName">备</text>
                <text class="inputName" style="padding-left: 38px">注：</text>
                <input class="input" type="text" placeholder="请输入备注" @input="remarkInput" :value="mid.remark" ref="remark"/>
            </div>
            <u-i-button class="button" v-if="!mid.bind" title="绑定" @doClick="bind"></u-i-button>
            <u-i-button class="button" v-if="mid.bind" bgColor="red" title="解除绑定" @doClick="unbind"></u-i-button>
        </div>
    </div>
</template>

<script>
import NavBar from './components/NavBar'
import {request, State} from './js/Request'
import {RW, SubOrder} from './js/Order'
import UIButton from './components/UIButton'

const userInfoModule = weex.requireModule('UserInfoModule')
const modal = weex.requireModule('modal')
const navigator = weex.requireModule('navigator')

export default {
  name: 'EditDeviceViewController',
  components: {UIButton, NavBar},
  data () {
    return {
      mid: {}
    }
  },
  created () {
    let self = this
    userInfoModule.getParam(e => {
      self.mid = e.data
    })
  },
  destroyed () {
    request.interrupt(SubOrder.editDevice, RW.read)
  },
  methods: {
    toBack () {},
    toMakeSure () {
      this.$refs.remark.blur()
      let param = JSON.parse(JSON.stringify(this.mid))
      console.log(JSON.stringify(param), '--------------------')
      request.editDevice(param, (state, msg, data) => {
        if (state === State.success) {
          modal.toast({
            message: msg,
            duration: 1
          })
          setTimeout(() => {
            navigator.pop()
          }, 1000)
        }
      })
    },
    remarkInput (e) {
      this.mid.remark = e.value
    },
    bind (e) {
      let id = parseInt(Math.random() * (255 - 100 + 1) + 100, 10)
      // let id = (Math.random() * (1000 - 100)) * 100
      let param = {id: id, mid: this.mid.mid, isbind: true}

      request.bind(param, (state, msg, data) => {
        if (state === State.success) {
          request.bindService(param, (state0, msg0, data0) => {
            if (state0 === State.success) {
              modal.toast({
                message: '绑定成功',
                duration: 1
              })
              this.mid.bind = true
            }
          })
        } else {
          modal.toast({
            message: msg,
            duration: 1
          })
        }
      })
      modal.alert({
        message: '发送命令中……，识别码：' + id,
        okTitle: '确定'
      })
    },
    unbind (e) {
      let id = parseInt(Math.random() * (255 - 100 + 1) + 100, 10)
      let param = {id: id, mid: this.mid.mid, isbind: false}

      modal.confirm({
        message: '是否确认解除（' + this.mid.remark + '）绑定',
        okTitle: '确定',
        cancelTitle: '取消'
      }, result => {
        if (result === '确定') {
          request.bind(param, (state, msg, data) => {
            if (state === State.success) {
              request.bindService(param, (state0, msg0, data0) => {
                if (state0 === State.success) {
                  modal.toast({
                    message: '解除绑定成功',
                    duration: 1
                  })
                  this.mid.bind = false
                }
              })
            } else {
              modal.toast({
                message: msg,
                duration: 1
              })
            }
          })
        }
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
        /*flex-direction: row;*/
    }
    .inputName {
        padding-top: 8px;
        margin-top: 30px;
        font-size: 38px;
        color: #000000;
    }
    .inputText {
        padding-top: 8px;
        font-size: 38px;
        margin-top: 30px;
        width: 500px;
        height: 50px;
    }
    .input {
        font-size: 38px;
        margin-top: 30px;
        padding-left: 20px;
        width: 500px;
        height: 50px;
        background-color: whitesmoke;
    }
    .button {
        margin-top: 40px;
        width: 670px;
        height: 88px;
    }
</style>
