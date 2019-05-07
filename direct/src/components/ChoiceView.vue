<template>
    <div>
        <wxc-mask class="view" :show="show" opacity="0.6" @wxcOverlayBodyClicked="wxcOverlayBodyClicked">
        </wxc-mask>
        <text>{{title}}</text>
        <div class="bg">
        </div>
    </div>
</template>

<script>
import {WxcMask} from 'weex-ui'

export default {
  name: 'ChoiceView',
  components: { WxcMask },
  props: {
    show: {
      type: Boolean,
      default: () => false
    },
    title: {
      type: String,
      default: () => ''
    }
  },
  methods: {
    wxcOverlayBodyClicked () {
      this.$emit('doClick', {show: this.show})
    }
  }
}
</script>

<style scoped>
    .view {
        justify-content: center;
        align-items: center;
    }
    .bg {
        background-color: white;
        margin-left: 50px;
        margin-right: 50px;
        height: 80px;
    }
</style>
