<template>
    <div @viewdisappear="onViewdisappear">
        <nav-bar title="我的" left="返回"></nav-bar>
        <list>
            <cell>
                <div class="cellDetail">
                    <text style="font-size: 40px">账号</text>
                    <text style="font-size: 40px">{{name}}</text>
                </div>
                <div class="line"></div>
            </cell>
            <cell>
                <div class="cellDetail" @click="pushModifyPwd">
                    <text style="font-size: 40px">修改密码</text>
                    <text style="font-size: 40px">></text>
                </div>
                <div class="line"></div>
            </cell>
            <cell>
                <div class="cellDetail" @click="pushWIFI">
                    <text style="font-size: 40px">配置设备无线网</text>
                    <text style="font-size: 40px">></text>
                </div>
                <div class="line"></div>
            </cell>
            <cell>
                <div class="button">
                    <text class="buttonText" @click="logout">退出登录</text>
                </div>
            </cell>
        </list>
    </div>
</template>

<script>
import NavBar from './components/NavBar'
import {request, State} from './js/Request'
import {RW, SubOrder} from './js/Order'

const modal = weex.requireModule('modal')
const navigator = weex.requireModule('navigator')

export default {
  name: 'MyViewController',
  components: {NavBar},
  data () {
    return {
      name: ''
    }
  },
  created () {
    var self = this
    request.userInfo((state, msg, data) => {
      if (state === State.success) {
        self.name = data.name
      } else {
        modal.toast({
          message: msg,
          duration: 0.3
        })
      }
    })
  },
  destroyed () {
    console.log(this, ' destroyed')
    request.interrupt(SubOrder.userInfo, RW.read)
  },
  methods: {
    onViewdisappear () {
      console.log('MyViewController onViewdisappear')
      request.interrupt(SubOrder.userInfo, RW.read)
    },
    pushModifyPwd () {
      const url = weex.config.bundleUrl + 'ChangePasswordViewController.js'
      navigator.push({
        url: url,
        param: {isForget: true}
      })
    },
    pushWIFI () {
      const url = weex.config.bundleUrl + 'WIFIViewController.js'
      navigator.push({
        url: url
      })
    },
    logout () {
      request.logout((state, msg, data) => {
        if (state === State.success) {
          navigator.pop({
            root: true
          })
        } else {
          modal.toast({
            message: msg,
            duration: 0.3
          })
        }
      })
    }
  }
}
</script>

<style scoped>
    .cellDetail {
        flex-direction: row;
        justify-content: space-between;
        margin: 20px;
        /*height: 60px;*/
    }
    .line {
        background-color: #dddddd;
        height: 1px;
    }
    .button {
        margin-top: 40px;
        margin-left: 20px;
        margin-right: 20px;
        border-radius: 5px;
        background-color: #0088fb;
        height: 88px;
    }
    .buttonText {
        text-align: center;
        margin-top: 19px;
        font-size: 40px;
        color: #ffffff;
    }
</style>
