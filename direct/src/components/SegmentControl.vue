<template>
    <div class="segment">
        <div v-for="(item, index) in items" :key="index"
             :class="[ (index === 0) ? 'tabStart': '',
            (index === items.length -1) ? 'tabEnd': '',
            (index !== items.length -1) && (index !== 0) ? 'tabLine': '',
            (index === activeIndex) ? 'activeBG': 'normalBG' ]" @click="onClick(index)">
            <text :class="[(index === activeIndex) ? 'activeText': 'normalText']">{{item}}</text>
        </div>
    </div>
</template>

<script>
export default {
  name: 'SegmentControl',
  props: {
    items: {
      type: Array,
      default: function () { return ['item1', 'item2'] }
    },
    activeIndex: {
      type: Number,
      default: 0
    }
  },
  data () {

  },
  methods: {
    onClick: function (index) {
      var self = this

      this.$emit('segmentClicked', {
        data: index,
        callback: isChange => {
          if (index !== self.activeIndex && isChange) {
            self.activeIndex = index
          }
        }
      })
    }
  }
}
</script>

<style scoped>
    .segment {
        border-radius: 20px;
        border-color: lightgrey;
        border-width: 2px;
        height: 60px;
        width: 700px;
        flex-direction: row;
        justify-content: space-between;
    }
    .text {
        font-size: 28px;
    }
    .test {
        border-top-right-radius: 20px;
    }
    .tabStart {
        margin: 0px;
        background-color: aquamarine;
        justify-content: center;
        align-items: center;
        flex-direction: row;
        flex: 1;
        border-top-left-radius: 20px;
        border-bottom-left-radius: 20px;
        border-right-width: 2px;
        border-color: rgb(173, 173, 187);
    }
    .tabEnd {
        margin: 0px;
        background-color: aquamarine;
        justify-content: center;
        align-items: center;
        flex-direction: row;
        flex: 1;
        border-top-right-radius: 20px;
        border-bottom-right-radius: 20px;
    }
    .tabLine {
        margin: 0px;
        background-color: aquamarine;
        justify-content: center;
        align-items: center;
        flex-direction: row;
        flex: 1;
        border-right-width: 2px;
        border-color: rgb(173, 173, 187);
    }
    .line {
        width: 10px;
        background-color: black;
    }
    .activeText {
        color: white;
        font-size: 38px;
    }
    .normalText {
        color: black;
        font-size: 38px;
    }
    .activeBG {
        background-color: #717171;
    }
    .normalBG {
        background-color: white;
    }
</style>
