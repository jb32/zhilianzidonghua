<template>
    <div class="button" :style="{backgroundColor: bgColor, borderRadius: borderRadius}" @click="doClick">
        <text class="buttonTxt" :style="{color: color, fontSize: fontSize}">{{title}}</text>
    </div>
</template>

<script>
export default {
  name: 'UIButton',
  props: {
    color: {
      type: String,
      default: '#FFFFFF'
    },
    fontSize: {
      type: Number,
      default: 40
    },
    bgColor: {
      type: String,
      default: '#0088fb'
    },
    borderRadius: {
      type: Number,
      default: 10
    },
    title: {
      type: String,
      default: ''
    }
  },
  methods: {
    doClick (e) {
      this.$emit('doClick', e)
    }
  }
}
</script>

<style scoped>
    .button {
        justify-content: center;
    }
    .buttonTxt {
        text-align: center;
        color: white;
        font-size: 40px;
    }
</style>
