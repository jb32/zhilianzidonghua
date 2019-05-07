<template>
    <div>
        <div v-for="(arr, i) in updateList" :key="i" class="div">
            <text v-for="(item, m) in arr" :key="m" class="text" :style="{fontSize: fontSize}">{{item.title}}</text>
        </div>
    </div>
</template>

<script>
export default {
  name: 'FlexWap',
  data () {
    return {}
  },
  props: {
    list: {
      type: Array,
      default: () => {
      }
    },
    fontSize: {
      type: Number,
      default: 34
    },
    width: {
      type: Number,
      default: 750
    }
  },
  created () {
  },
  computed: {
    updateList () {
      const {list, fontSize, width} = this
      let arr = []
      let rows = []
      let w = 0

      if (list) {
        for (let i = 0, len = list.length; i < len; i++) {
          let str = list[i]
          let size = fontSize * str.length

          w += 20 + size

          if (w >= width) {
            arr.push(JSON.parse(JSON.stringify(rows)))
            w = 0
            rows = []
          }
          let item = {title: str, len: size}
          rows.push(item)
        }
        arr.push(JSON.parse(JSON.stringify(rows)))
      }
      return arr
    }
  }
}
</script>

<style scoped>
    .text {
        margin-top: 5px;
        margin-left: 10px;
        padding: 5px;
        background-color: red;
        border-radius: 10px;
        color: #ffffff;
    }

    .div {
        flex-direction: row;
    }
</style>
