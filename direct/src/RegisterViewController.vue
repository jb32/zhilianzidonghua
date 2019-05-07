<template>
    <div>
        <nav-bar title="注册" left="返回" @leftButtonClicked="toBack"></nav-bar>
        <div class="view">
            <image v-if="env.platform !== 'Web'" src="locall://logo" class="logo"></image>
            <image v-if="env.platform === 'Web'" src="../web/assets/logo.png" class="logo"></image>

            <div class="inputSuper">
                <div style="flex-direction: row">
                    <text class="inputText defaultFont">用户名：</text>
                    <input class="input defaultFont" type="text" placeholder="请输入用户名" @input="nameInput" ref="name"/>
                </div>
                <div style="flex-direction: row">
                    <text class="inputText defaultFont">密</text>
                    <text class="inputText defaultFont" style="padding-left: 38px">码：</text>
                    <input class="input defaultFont" type="password" placeholder="请输入密码" @input="pwdInput" ref="password"/>
                </div>
                <div style="flex-direction: row">
                    <text class="inputText defaultFont">证件号：</text>
                    <input class="input defaultFont" type="text" placeholder="请输入任意证件号" @input="cardInput" ref="card"/>
                </div>
            </div>
            <wxc-button class="button" text="注册" type="blue" @wxcButtonClicked="register"></wxc-button>
        </div>
        <!--<wxc-checkbox title="完成后自动登录" checked="true" :config="config" @wxcCheckBoxListChecked="checkBox"></wxc-checkbox>-->
    </div>
</template>

<script>
import {WxcButton, WxcCheckbox} from 'weex-ui'
import NavBar from './components/NavBar'
import {request, State} from './js/Request'
import {RW, SubOrder} from './js/Order'

const navigator = weex.requireModule('navigator')
const modal = weex.requireModule('modal')

export default {
  name: 'RegisterViewController',
  data () {
    return {
      env: weex.config.env,
      isLoading: false,
      config: {
        checkedIcon: 'locall://checkbox_s',
        unCheckedIcon: 'locall://checkbox',
        checkedColor: '#000000'
      },
      isAutoLogin: '1'
    }
  },
  components: {
    WxcButton, NavBar, WxcCheckbox
  },
  destroyed () {
    request.interrupt(SubOrder.register, RW.read)
  },
  methods: {
    toBack () {},
    pwdInput (e) {
      this.pwd = e.value
    },
    nameInput (e) {
      this.name = e.value
    },
    cardInput (e) {
      this.card = e.value
    },
    checkBox (e) {
      this.isAutoLogin = e.value ? '1' : '0'
    },
    register () {
      this.$refs.name.blur()
      this.$refs.password.blur()
      this.$refs.card.blur()

      if (this.name === undefined || this.name === null || this.name.length === 0) {
        modal.toast({
          message: '请输入用户名',
          duration: 0.3
        })
        return
      }

      if (this.pwd === undefined || this.pwd === null || this.pwd.length === 0) {
        modal.toast({
          message: '请输入密码',
          duration: 0.3
        })
        return
      }

      if (this.card === undefined || this.card === null || this.card.length === 0) {
        modal.toast({
          message: '请输入证件号',
          duration: 0.3
        })
        return
      }
      request.register(this.name, this.pwd, this.card, (state, msg, data) => {
        modal.toast({
          message: msg,
          duration: 1
        })
        if (state === State.success) {
          setTimeout(e => {
            navigator.pop({})
          }, 1000)
        }
      })
    }
  }
}
</script>

<style scoped>
    .view {
        margin-top: 120px;
        align-items: center;
    }
    .defaultFont {
        font-size: 38px;
        color: #000000;
    }
    .logo {
        width: 300px;
        height: 300px;
    }
    .inputSuper {
        margin-top: 40px;
        flex-direction: column;
    }
    .inputText {
        margin-top: 40px;
        height: 44px;
    }
    .input {
        margin-top: 40px;
        width: 500px;
        height: 44px;
    }
    .button {
        margin-top: 40px;
    }
</style>
