# One Team, One goal

## **本项目基于** [uni-app 官网](https://uniapp.dcloud.io)

### **一、开发工具(注意事项)**

- 推荐官方 IDE [HBuilderX](https://www.dcloud.io/hbuilderx.html)
- [Visual Studio Code](https://code.visualstudio.com/Download/)
- 建议不要直接使用 cnpm 安装以来，会有各种诡异的 bug。可以通过如下操作解决 npm 下载速度慢的问题
- 图片等媒体资源统一放置于七牛云，并注意按功能区分文件夹，如:`https://picture.cqzhong.cn/wx-blog/mine/folder.png`,
- wx-blog 代表该项目，mine 代表功能

### Project setup

```Bash
npm install --registry=https://registry.npm.taobao.org

# 或者
yarn install

# Compiles and hot-reloads for development
yarn serve

# Compiles and minifies for production
yarn build
```

### **二、组织结构**

```bash
.
├── App.vue                         应用配置，用来配置App全局样式以及监听
├── README.md                       项目框架介绍
├── main.js                         Vue初始化入口文件
├── manifest.json                   配置应用名称、appid、logo、版本等打包信息
├── pages.json                      配置页面路由、导航条、选项卡等页面类信息
├── platforms                       存放各平台专用页面的目录
├── pages                           页面文件src
├── wxcomponents                    微信小程序自定义组件存放目录
├── mycomponents                    支付宝小程序自定义组件存放目录
├── swancomponents                  百度小程序自定义组件存放目录
├── components                      全局组件库
│   ├── luch-request                第三方请求基础库
│   ├── mescroll-uni                第三方下拉刷新组件
│   ├── polygon                     自定义组件
│   └── uview-ui                    UI组件
├── service                        服务(api、存储)
│   ├── api                        接口服务
│   │   ├── config                 接口请求配置
│   │   │   ├── httpConfig.js      请求配置
│   │   │   └── index.js           环境配置
│   │   ├── home.js
│   │   ├── index.js               接口服务
│   │   └── mine.js
│   ├── storage                    本地存储
│   │   └── index.js
│   └── store                      vuex
│       └── index.js
├── static                         存放应用引用静态资源（如图片、视频等）的目录，注意：静态资源只能存放于此
│   ├── assets                     图片目录
│   │   ├── common
│   │   │   └── tabBar
│   │   └── home
│   │       └── home_slogan.png
│   ├── iconfont.css               项目iconfont
│   └── pgImages.js                图片资源管理类
├── uni.scss                       全局css主题
├── utils                          公用工具
|   ├── base64.js                  base64加解密工具
│   ├── global.scss                页面全局样式
│   ├── index.js
```

### 三、组件按需引入配置

`pages.json` 文件 [参考 easycom](https://uniapp.dcloud.io/collocation/pages?id=easycom)

```json
"easycom": {
 "autoscan": true,
 "custom": {
  "u-(.*)": "@/components/uview-ui/u-$1/u-$1.vue",
  "pg-(.*)": "@/components/polygon/pg-$1/pg-$1.vue"
 }
}
```

### **四、全局对象**

```js
Vue.prototype.$http = http // http请求库
Vue.prototype.$store = store // vuex store
Vue.prototype.$utils = utils // 工具库

Vue.prototype.$api = api
Vue.prototype.$storage = storage
Vue.prototype.$pgImages = pgImages
```

### 五、项目主题配置 具体参考 uni.scss 注释

- 一像素边框和切圆角使用方法

```scss
border-radius: 20rpx;
position: relative;
&::before {
  content: '';
  border-radius: 40rpx;
  @include retina-one-px-border(all);
}
```

或者 class 直接命名为以下名字

```js
<div class="u-border-top" />
<div class="u-border-bottom" />
<div class="u-border-right" />
<div class="u-border-bottom" />
<div class="u-border-top-bottom" />
<div class="u-border" />
```

### **[六、requst 使用说明](./documents/request.md)**

### 七、[命名规范](https://www.yuque.com/docs/share/533fb2b0-bed6-4319-9589-a9190c2d9b32)

### **八、打包注意事项**

- [uniapp 运行区分环境](./documents/uniapp运行区分环境.md)

```js
此项目基于uniapp框架，统一开发多端打包，分别生成h5网页，微信小程序及支付宝小程序。对于平台的不同，统一按照uniapp给出的
#ifdef H5 做判断
```

### 九、版权信息

| 名称                                                             | 是否修改 |
| ---------------------------------------------------------------- | -------- |
| [uViewUI 组件库](https://www.uviewui.com)                        | 是       |
| [mescroll](http://www.mescroll.com/uni.html?v=20200218)          | 是       |
| [luch-request 请求](https://www.quanzhan.co/luch-request/)       | 无       |
| ~~[sentry-miniapp](https://github.com/lizhiyao/sentry-miniapp)~~ | ~~无~~   |
| ~~[raven-weapp](https://github.com/youzan/raven-weapp)~~         | ~~无~~   |
| ~~[jsencrypt](https://www.npmjs.com/package/jsencrypt)~~         | ~~无~~   |
