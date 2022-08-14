# uniapp 运行区分环境

## template 内区分

```vue
<template>
  <view>
    <!-- #ifdef MP-ALIPAY -->
    <view
      :class="{
        'uni-collapse-cell__title-arrow-active': isOpen,
        'uni-collapse-cell--animation': showAnimation === true
      }"
      class="uni-collapse-cell__title-arrow"
    >
      <uni-icons color="#bbb" size="20" type="arrowdown" />
    </view>
    <!-- #endif -->
    <!-- #ifndef MP-ALIPAY -->
    <uni-icons
      :class="{
        'uni-collapse-cell__title-arrow-active': isOpen,
        'uni-collapse-cell--animation': showAnimation === true
      }"
      class="uni-collapse-cell__title-arrow"
      color="#bbb"
      size="20"
      type="arrowdown"
    />
    <!-- #endif -->
  </view>
</template>
```

## script 内区分

```vue
// #ifdef APP-PLUS ...判断内容，当运行环境为 app时候 // #endif // #ifndef APP-PLUS|| MP-WEIXIN || MP-ALIPAY || H5
...判断内容, 当运行环境为 非App、微信小程序、支付宝小程序、h5时候 // #endif
```

## style

```vue
.uni-swipe_button-group { /* #ifndef APP-VUE|| MP-WEIXIN||H5 */ position: absolute; top: 0; right: 0; bottom: 0;
z-index: 0; /* #endif */ /* #ifndef APP-NVUE */ display: flex; flex-shrink: 0; /* #endif */ flex-direction: row; }
```
