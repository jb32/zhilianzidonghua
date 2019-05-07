<template>
    <div @viewappear="viewappear">
        <nav-bar title="无线网络" left="返回" right="连接" @rightButtonClicked="connect"></nav-bar>
        <div class="inputSuper">
            <div style="flex-direction: row">
                <text class="inputText defaultFont">名称：</text>
                <text class="input defaultFont">{{ iphoneSSID }}</text>
            </div>
            <div style="flex-direction: row">
                <text class="inputText defaultFont">密码：</text>
                <input class="input defaultFont" type="password" placeholder="请输入密码" @input="pwdInput" ref="pwd"/>
            </div>
        </div>
    </div>
</template>

<script>
import NavBar from './components/NavBar'

const easyLink = weex.requireModule('WIFILink')
const modal = weex.requireModule('modal')
// const hud = weex.requireModule('HUD')

export default {
  name: 'WIFIViewController',
  components: { NavBar },
  data () {
    return {
      iphoneSSID: '',
      pwd: ''
    }
  },
  created () {
    const self = this
    easyLink.start((e) => {
      self.iphoneSSID = e // 'TP-LINK_E78B'
    })
  },
  destroyed () {
    easyLink.stop()
  },
  methods: {
    pwdInput (e) {
      this.pwd = e.value
    },
    viewappear () {},
    connect () {
      this.$refs.pwd.blur()

      if (this.iphoneSSID.length === 0) {
        modal.toast({
          message: '您的手机尚未连接无线网',
          duration: 1
        })
        return
      }

      if (this.pwd.length === 0) {
        modal.toast({
          message: '请输入密码',
          duration: 1
        })
        return
      }

      const param = { password: this.pwd, _ssid: this.iphoneSSID }
      // hud.show()
      modal.toast({
        message: '连接中请稍等……',
        duration: 1
      })
      easyLink.connect(param, (rsp) => {
        // hud.hide()
        modal.toast({
          message: rsp.msg,
          duration: 0.3
        })
      })
    }
  }
}
</script>

<style scoped>
    .inputSuper {
        margin-top: 40px;
        margin-left: 40px;
        margin-right: 40px;
        /*flex-direction: row*/
    }
    .inputText {
        margin-top: 40px;
    }
    .input {
        margin-top: 40px;
        width: 500px;
        height: 44px;
    }
    .defaultFont {
        font-size: 40px;
        color: #000000;
    }
</style>
