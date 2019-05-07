<template>
    <div>
        <nav-bar title="修改密码" left="返回" right="确认" @rightButtonClicked="toMakeSure"></nav-bar>
        <div class="view">
            <div class="inputSuper">
                <div style="flex-direction: row" v-if="isForget">
                    <text class="inputName">用</text>
                    <text class="inputName" style="padding-left: 19px">户</text>
                    <text class="inputName" style="padding-left: 19px">名：</text>
                    <input class="input" type="text" placeholder="请输入用户名" @input="nameInput" ref="name"/>
                </div>
                <div style="flex-direction: row">
                    <text class="inputName">证</text>
                    <text class="inputName" style="padding-left: 19px">件</text>
                    <text class="inputName" style="padding-left: 19px">号：</text>
                    <input class="input" type="text" placeholder="请输入证件号" @input="cardInput" ref="card"/>
                </div>
                <div style="flex-direction: row">
                    <text class="inputName">新</text>
                    <text class="inputName" style="padding-left: 19px">密</text>
                    <text class="inputName" style="padding-left: 19px">码：</text>
                    <input class="input" type="password" placeholder="请输入密码" @input="pwdInput" ref="pwd"/>
                </div>
                <div style="flex-direction: row">
                    <text class="inputName">确认密码：</text>
                    <input class="input" type="password" placeholder="请再次输入密码" @input="rePwdInput" ref="repwd"/>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
import NavBar from './components/NavBar'
import { changePassword } from './js/Request'

const modal = weex.requireModule('modal')

export default {
  name: 'ChangePasswordViewController',
  components: { NavBar },
  data () {
    return {
      isForget: false
    }
  },
  created () {
    const info = weex.requireModule('UserInfoModule')
    var self = this
    info.getParam(function (param) {
      console.log(param.isForget, '-------------------', typeof param.isForget)
      self.isForget = param.isForget
    })
  },
  methods: {
    toMakeSure () {
      if (!this.isForget) {
        this.$refs.name.blur()
      }
      this.$refs.card.blur()
      this.$refs.pwd.blur()
      this.$refs.repwd.blur()

      if (
        !this.isForget &&
        (this.name === undefined ||
          this.name === null ||
          this.name.length === 0)
      ) {
        modal.toast({
          message: '请输入用户名',
          duration: 0.3
        })
        return
      }
      if (
        this.card === undefined ||
        this.card === null ||
        this.card.length === 0
      ) {
        modal.toast({
          message: '请输入证件号',
          duration: 0.3
        })
        return
      }
      if (
        this.pwd === undefined ||
        this.pwd === null ||
        this.pwd.length === 0
      ) {
        modal.toast({
          message: '请输入新密码',
          duration: 0.3
        })
        return
      }
      if (
        this.pwd1 === undefined ||
        this.pwd1 === null ||
        this.pwd1.length === 0
      ) {
        modal.toast({
          message: '请再次输入新密码',
          duration: 0.3
        })
        return
      }
      if (this.pwd1 !== this.pwd) {
        modal.toast({
          message: '两次输入密码不同',
          duration: 0.3
        })
      }
      changePassword(this.name, this.pwd, this.card, (state, msg, data) => {
        modal.toast({
          message: msg,
          duration: 0.3
        })
      })
    },
    nameInput (e) {
      this.name = e.value
    },
    cardInput (e) {
      this.card = e.value
    },
    pwdInput (e) {
      this.pwd = e.value
    },
    rePwdInput (e) {
      this.pwd1 = e.value
    }
  }
}
</script>

<style scoped>
.view {
  top: 40px;
  align-items: center;
}
.inputName {
  margin-top: 30px;
  font-size: 38px;
  color: #000000;
  height: 50px;
}
.inputSuper {
  margin-top: 40px;
}
.input {
  font-size: 38px;
  margin-top: 30px;
  padding-left: 20px;
  width: 500px;
  height: 50px;
  background-color: whitesmoke;
}
</style>
