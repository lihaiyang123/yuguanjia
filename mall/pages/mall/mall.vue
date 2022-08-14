<!-- 商城 商品详情 -->
<template>
  <view class="mall-view">
    <u-swiper
      :list="list"
      height="744"
      interval="3000"
      :circular="true"
      mode="number"
      border-radius="0"
      indicator-pos="bottomRight"
      @click="swiperClick"
    />
    <view class="info-view">
      <view class="price-view">
        <text class="mark">￥</text>
        <text class="num">{{ goods.goodPrice || '-' }}</text>
      </view>
      <view class="description-view">{{ goods.goodName || '' + goods.goodPara || '' + goods.goodType || '' }}</view>
    </view>
    <view class="section-view" />
    <view v-if="!isPreview" class="tit-view">
      <view class="left-view">
        <image
          class="img"
          mode="aspectFill"
          :src="goods.serLogo || 'https://static2.51gonggui.com/flutter_project/mine_user_default.png'"
          @click="previewImg"
        />
        <text class="name">{{ goods.serName || '-' }}</text>
      </view>
      <view class="btn" hover-class="btn-hover-class" :hover-stay-time="150" @click="goMerchantHomepage">
        进商户主页
      </view>
    </view>
    <view v-if="!isPreview" class="section-view" />
    <view class="remark">{{ goods.remark }}</view>
    <view class="imgs-view">
      <image
        v-for="(item, idx) in imgs"
        :key="idx"
        class="detail-img"
        mode="aspectFill"
        :src="item"
        @click="clickDetailImgs(idx)"
      />
    </view>
  </view>
</template>

<script>
export default {
  components: {},
  data() {
    return {
      isPreview: true,
      goods: {
        goodPrice: '',
        goodName: '',
        goodPic: '',
        goodType: '',
        remark: '',
        serLogo: '', // 服务商log
        serName: '' // 商户名称
      },
      imgs: [],
      list: []
      // list: [
      //   {
      //     image: 'http://47.96.178.186:8081/d/upload/95832a9ad38241a090bcc859ad9cf753.png',
      //     title: '昨夜星辰昨夜风，画楼西畔桂堂东'
      //   },
      //   {
      //     image: 'http://47.96.178.186:8081/d/upload/95832a9ad38241a090bcc859ad9cf753.png',
      //     title: '身无彩凤双飞翼，心有灵犀一点通'
      //   },
      //   {
      //     image: 'http://47.96.178.186:8081/d/upload/95832a9ad38241a090bcc859ad9cf753.png',
      //     title: '谁念西风独自凉，萧萧黄叶闭疏窗，沉思往事立残阳'
      //   }
      // ]
    }
  },
  computed: {},
  watch: {},
  onLoad(options) {
    this.$jsBridge.registerHandler('initData', data => {
      this.isPreview = data.isPreview
      this.goods = data.goodsVo;
      (data.goodsPicsList || []).map(item => {
        if (item.picType === 0 || item.picType === '0') {
          this.list.push({ image: item.picUrl, title: '' })
        }

        if (item.picType === 1 || item.picType === '1') {
          this.imgs.push(item.picUrl)
        }
      })
    })
  },
  onShow() {},
  onReady() {
    // 页面初次渲染完成
  },
  onHide() {
    // 监听页面隐藏
  },
  onUnload() {
    // 监听页面卸载
  },
  methods: {
    previewImg() {
      uni.previewImage({
        urls: [this.goods.serLogo]
      })
    },
    swiperClick(index) {
      console.log(index)
      uni.previewImage({
        urls: [this.list[index].image]
      })
    },

    clickDetailImgs(idx) {
      uni.previewImage({
        urls: this.imgs,
        indicator: 'number',
        current: idx
      })
    },

    goMerchantHomepage() {
      this.$jsBridge.callHandler('goMerchantHomepage', '', res => {})
    }
  }
}
</script>
<style>
page {
  width: 100%;
  min-height: 100%;
  background-color: #fff;
}
</style>
<style lang="scss" scoped>
.mall-view {
  width: 100%;
  height: 100vh;
  overflow-x: hidden;
  background-color: #fff;

  .info-view {
    padding: 20rpx 25rpx 15rpx;
    .price-view {
      color: #ec5b26;
      .mark {
        font-size: 28rpx;
        font-weight: 400;
      }
      .num {
        font-size: 36rpx;
        font-weight: normal;
      }
    }
    .description-view {
      color: $u-main-color;
      font-size: 28rpx;
      font-weight: 500;
    }
  }

  .section-view {
    background-color: #f2f4f5;
    width: 100%;
    height: 20rpx;
  }

  .tit-view {
    padding: 11rpx 25rpx;
    display: flex;
    justify-content: space-between;
    align-items: center;
    .left-view {
      display: flex;
      align-items: center;
      .img {
        height: 90rpx;
        width: 90rpx;
        border-radius: 50%;
      }
      .name {
        margin-left: 12rpx;
        font-size: 28rpx;
        color: $u-main-color;
      }
    }
    .btn {
      display: flex;
      justify-content: center;
      align-items: center;
      width: 172rpx;
      height: 50rpx;
      background: #4581eb;
      border-radius: 25rpx;

      font-size: 24rpx;
      font-weight: 500;
      color: #ffffff;
    }
    .btn-hover-class {
      background-color: $u-type-primary-dark !important;
    }
  }

  .remark {
    text-align: center;
    color: $u-main-color;
    font-size: 28rpx;
    padding-left: 25rpx;
    padding-right: 25rpx;
  }

  .imgs-view {
    display: flex;
    flex-direction: column;
    align-content: center;
    justify-content: center;
    .detail-img {
      min-width: 100%;
      max-width: 100%;
    }
  }
}
</style>
