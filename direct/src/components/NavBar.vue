<template>
    <div dataRole="navbar">
        <div v-if="platform === 'iOS'" class="nav1"
             :style="{backgroundColor: backgroundColor}">
            <text class="leftClass"
                  naviItemPosition="left"
                  :value="left"
                  :style="{color: leftItemColor}"
                  @click="leftButtonClicked"></text>
            <text class="centerClass"
                  naviItemPosition="center"
                  :value="title"
                  :style="{color: titleColor}"></text>
            <text class="rightClass"
                  naviItemPosition="right"
                  :value="right"
                  :style="{color: rightItemColor}"
                  @click="rightButtonClicked"></text>
        </div>
        <div v-if="platform !== 'iOS'" class="nav0"
             :style="{backgroundColor: backgroundColor}">
            <text class="leftClass"
                  naviItemPosition="left"
                  :value="left"
                  :style="{color: leftItemColor}"
                  @click="leftButtonClicked"></text>
            <text class="centerClass"
                  naviItemPosition="center"
                  :value="title"
                  :style="{color: titleColor}"></text>
            <text class="rightClass"
                  naviItemPosition="right"
                  :value="right"
                  :style="{color: rightItemColor}"
                  @click="rightButtonClicked"></text>
        </div>
        <div class="line"></div>
    </div>
</template>

<script>
const navigator = weex.requireModule('navigator')

export default {
  name: 'NavBar',
  data () {
    return {
      platform: weex.config.env.platform
    }
  },
  props: {
    title: {
      type: String,
      default: ''
    },
    left: {
      type: String,
      default: ''
    },
    right: {
      type: String,
      default: ''
    },
    backgroundColor: {
      type: String,
      default: '#ffffff'
    },
    rightItemColor: {
      type: String,
      default: '#000000'
    },
    leftItemColor: {
      type: String,
      default: '#000000'
    },
    titleColor: {
      type: String,
      default: '#000000'
    },
    useDefaultReturn: {
      type: String,
      default: 'true'
    }
  },
  created () {

  },
  methods: {
    leftButtonClicked () {
      const isPop = this.useDefaultReturn === 'true'

      if (isPop) {
        navigator.pop({}, (e) => {
        })
      }
      this.$emit('leftButtonClicked', {})
    },
    rightButtonClicked () {
      this.$emit('rightButtonClicked', {})
    }
  }
}
</script>

<style scoped>
    .nav {
        height: 100px;
        width: 750px;
        z-index: 10000;
    }
    .nav0 {
        flex-direction: row;
        justify-content: center;
        align-items: center;
        height: 88px;
        background-color: white;
        margin-top: 40px;
    }
    .nav1 {
        flex-direction: row;
        height: 1px;
    }
    .leftClass {
        margin-left: 20px;
        margin-right: 20px;
        font-size: 40px;
        text-align: left;
        flex: 1;
    }
    .centerClass {
        margin-left: 20px;
        margin-right: 20px;
        font-size: 40px;
        text-align: center;
        flex: 1;
    }
    .rightClass {
        margin-left: 20px;
        margin-right: 20px;
        font-size: 40px;
        text-align: right;
        flex: 1;
    }
    .line {
        background-color: #dddddd;
        width: 750px;
        height: 1px;
    }
</style>
