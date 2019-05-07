<template>
    <div @viewappear="onViewappear" @viewdisappear="onViewdisappear">
        <nav-bar title="登录" left="返回" right="注册" @rightButtonClicked="toRegister"></nav-bar>
        <div class="view">
            <image v-if="env.platform !== 'Web'" src="locall://logo" class="logo"></image>
            <image v-if="env.platform === 'Web'" src="../web/assets/logo.png" class="logo"></image>

            <div class="inputSuper">
                <div style="flex-direction: row">
                    <text class="inputText">用户名：</text>
                    <input class="input" type="text" :value="name" placeholder="请输入用户名" @input="nameInput" ref="name"/>
                </div>
                <div style="flex-direction: row">
                    <text class="inputText">密</text>
                    <text class="inputText" style="padding-left: 38px">码：</text>
                    <input class="input" type="password" :value="pwd" placeholder="请输入密码" @input="pwdInput" ref="pwd"/>
                </div>
                <div style="flex-direction: row" v-if="isHaveCard">
                    <text class="inputText">证件号：</text>
                    <input v-if="isHaveCard" class="input" type="password" placeholder="请输入证件号" @input="cardInput" ref="card"/>
                </div>
            </div>
            <u-i-button class="button" :title="isHaveCard ? '登录并绑定设备': '登录'" @doClick="login"></u-i-button>
        </div>
        <text class="forgetPwd" @click="toForgetPwd">忘记密码</text>
    </div>
</template>

<script>
import NavBar from './components/NavBar'
import UIButton from './components/UIButton'

import {request, State} from './js/Request'
import {storage} from './js/Storage'
import {RW, SubOrder} from './js/Order'

const navigator = weex.requireModule('navigator')
const modal = weex.requireModule('modal')

export default {
  name: 'LoginViewController',
  components: {
    NavBar,
    UIButton
  },
  data () {
    return {
      env: weex.config.env,
      isHaveCard: false,
      btnTitle: '登录',
      name: '',
      pwd: '',
      card: ''
    }
  },
  created () {},
  beforeDestroy () {
    request.interrupt(SubOrder.login, RW.read)
  },
  methods: {
    onViewappear () {
      let self = this

      storage.name((suess, data) => {
        if (suess) {
          self.name = data
        }
      })
      storage.password((suess, data) => {
        if (suess) {
          self.pwd = data
        }
      })
    },
    onViewdisappear () {},
    pwdInput (e) {
      this.pwd = e.value
    },
    nameInput (e) {
      this.name = e.value
    },
    cardInput (e) {
      this.card = e.value
    },
    login (e) {
      this.$refs.name.blur()
      this.$refs.pwd.blur()

      if (this.name === undefined ||
          this.name === null ||
          this.name.length === 0
      ) {
        modal.toast({
          message: '请输入用户名',
          duration: 0.3
        })
        return
      }

      if (this.pwd === undefined ||
          this.pwd === null ||
          this.pwd.length === 0
      ) {
        modal.toast({
          message: '请输入密码',
          duration: 0.3
        })
        return
      }

      if (this.isHaveCard) {
        this.$refs.card.blur()

        if (this.card === undefined ||
            this.card === null ||
            this.card.length === 0
        ) {
          modal.toast({
            message: '请输入证件号',
            duration: 1
          })
          return
        }
      }
      let self = this
      request.login(this.name, this.pwd, this.card, function (state, msg, data) {
        if (state === State.loginCard) {
          modal.alert(
            {
              message: msg,
              duration: 0.3
            },
            e => {
              self.isHaveCard = true
            }
          )
        } else if (state === State.failure) {
          modal.toast({
            message: msg,
            duration: 0.3
          })
        } else if (state === State.success) {
          storage.setToken(data.token)
          storage.setName(self.name)
          storage.setPassword(self.pwd)
          navigator.pop()
        }
      })
    },
    toRegister (e) {
      const url = `${weex.config.bundleUrl}RegisterViewController.js`

      navigator.push(
        {
          url: url,
          animated: 'true'
        },
        function (e) {
          console.log(e)
        }
      )
    },
    toForgetPwd (e) {
      const url = `${weex.config.bundleUrl}ChangePasswordViewController.js`

      navigator.push(
        {
          url: url,
          animated: 'true',
          param: {isForget: true}
        },
        function (e) {
          console.log(e)
        }
      )
    }
  }
}
</script>

<style scoped>
    .view {
        margin-top: 120px;
        align-items: center;
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
        font-size: 40px;
        height: 50px;
        color: #000000;
    }

    .input {
        font-size: 40px;
        margin-top: 40px;
        width: 500px;
        height: 50px;
        /*flex: 1;*/
    }

    .forgetPwd {
        margin-top: 20px;
        margin-right: 20px;
        margin-left: 500px;
        text-align: center;
        font-size: 40px;
        height: 88px;
        padding-top: 17px;
    }

    .button {
        margin-top: 40px;
        width: 710px;
        height: 88px;
    }
</style>
