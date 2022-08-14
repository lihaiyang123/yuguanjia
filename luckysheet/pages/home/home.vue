<template>
  <view class="content" />
</template>

<script>
// import LuckyExcel from 'luckyexcel'
import ExcelMixin from '@/utils/mixins/excel.js'

export default {
  components: {},
  mixins: [ExcelMixin],
  data() {
    return {
      // 是否是模版 false 不是模版、true是模版
      isTemplate: false,
      cellSelected: {},
      attachment: {}
    }
  },
  onLoad() {
    this.registerInitData()
    this.registerUploadAttachment()
    this.registerHandleUploadFileSuccess()
    this.registerHandlerSave()
  },
  methods: {
    /**
     * jsbridge监听native传递数据
     */
    registerInitData() {
      this.$jsBridge.registerHandler('initData', (data, responseCallback) => {
        const excelJSON = JSON.parse(data.tempContent)
        const exportJson = excelJSON.excel
        this.attachment = { ...excelJSON.attachment }
        this.createExcel(exportJson, data.allowEdit)
      })
    },

    // jsbridge监听上传附件事件
    registerUploadAttachment() {
      this.$jsBridge.registerHandler('uploadAttachment', (data, responseCallback) => {
        if (this.cellSelected.r === null) {
          alert('请先选择要显示图片的单元格')
          return
        }
        if (responseCallback) responseCallback()
      })
    },

    // jsbridge监听附件上传成功
    registerHandleUploadFileSuccess() {
      this.$jsBridge.registerHandler('handleUploadFileSuccess', (data, responseCallback) => {
        const url = data
        const { luckysheet } = window
        const { cellSelected, attachment } = this
        // console.log(cellSelected)
        const key = `${cellSelected.r}_${cellSelected.c}_${this.uuid()}`
        luckysheet.setCellValue(cellSelected.r, cellSelected.c, {
          ct: {
            fa: '@',
            t: 's'
          },
          comment: {
            isshow: false,
            value: key
          },
          v: '附件',
          m: '附件',
          bg: '#f6b26b',
          bl: 1,
          ht: 0
        })
        // attachment[`${cellSelected.r}_${cellSelected.c}`] = url
        attachment[key] = url
      })
    },

    // 保存excel内容
    registerHandlerSave() {
      const { luckysheet } = window
      luckysheet.exitEditMode()
      this.$jsBridge.registerHandler('saveFile', (data, responseCallback) => {
        const base64 = this.getExcelScreenshot()
        const content = {
          attachment: this.attachment,
          excel: window.luckysheet.getAllSheets()
        }
        responseCallback({ base64: base64, tempContent: JSON.stringify(content) })
      })
    },

    uuid() {
      const s = []
      const hexDigits = '0123456789abcdef'
      for (let i = 0; i < 36; i++) {
        s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1)
      }
      s[14] = '4'
      s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1)
      s[8] = s[13] = s[18] = s[23] = '-'

      const uuid = s.join('')
      return uuid
    }
  }
}
</script>

<style lang="scss" scoped>
h3 {
  margin: 40rpx 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10rpx;
}
a {
  color: #42b983;
}

.content {
  width: 100%;
  height: 100%;
}
</style>
