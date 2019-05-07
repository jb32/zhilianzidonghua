<template>
    <div>
        <div class="cell" v-for="(item, i) in updateList" :key="i" @click="radioItemChecked(i, $event)">
            <div v-if="item.checked" class="selectedDiv">
                <text class="selected">{{item.title}}</text>
            </div>
            <div v-if="!item.checked" class="disselectedDiv">
                <text class="disselected">{{item.title}}</text>
            </div>
        </div>
    </div>
</template>

<script>
export default {
  name: 'Radio',
  data () {
    return {
      checkedIndex: -1
    }
  },
  props: {
    list: {
      Type: Array,
      default: []
    }
  },
  computed: {
    updateList () {
      const { checkedIndex, list } = this
      const updateList = []
      list && list.forEach((item, i) => {
        item.checked = i === checkedIndex
        updateList.push(item)
      })
      return updateList
    }
  },
  watch: {
    list (newList) {
      console.log('list (newList)')
      this.setListChecked(newList)
    }
  },
  created () {
    this.setListChecked(this.list)
  },
  methods: {
    setListChecked (list) {
      if (list && list.length > 0) {
        list.forEach((item, i) => {
          item.checked && (this.checkedIndex = i)
        })
      }
    },
    radioItemChecked (i, e) {
      const oldIndex = this.checkedIndex
      const { title } = this.list[i]

      this.$emit('radioListChecked', {
        title: title,
        oldIndex: oldIndex,
        index: i,
        callback: (isChnage) => {
          if (isChnage) {
            this.checkedIndex = i
          }
        }
      })
    }
  }
}
</script>

<style scoped>
    .selectedDiv {
        background-color: #0088fb;
        justify-content: center;
        flex: 1;
    }
    .selected {
        color: #ffffff;
        font-size: 38px;
        text-align: center;
    }
    .disselectedDiv {
        background-color: #f5f5f5;
        justify-content: center;
        flex: 1;
    }
    .disselected {
        color: #000000;
        font-size: 38px;
        text-align: center;
    }
    .cell {
        flex: 1;
    }
</style>
