# [luch-request](https://www.quanzhan.co/luch-request/)

- `main.js`

```js
import { http } from '@/service/api/config/httpConfig.js'
import api from '@/service/api/index'

Vue.prototype.$api = api
Vue.prototype.$http = http
```

- @/service/api/config/index.js 文件内配置环境
- @/service/api/config/httpConfig.js 文件内配置请求

- `httpConfig.js`

(注意 hideLoading() 和 showToast() 冲突问题)

```js
// 新增配置在这里
http.setConfig((config) => {
  config.baseURL = networkConfig.setEnvApiBaseURL()
  // (自定义参数)可添加更多自定义参数
  config.custom = {
    isPrompt: true, // 默认 true 说明：本接口抛出的错误是否提示
    loading: true, // 默认 true 说明：本接口是否提示加载动画
    loadTitle: '加载中...' // 加载提示语
  }
  return config
})

// 在页面或者其它地方可以调用 this.$http.config.baseURL 获取或者设置新的base url
console.log(this.$http.config.baseURL)

// 在下面方法内配置适合项目的处理请求参数和响应数据
http.interceptors.request.use((config) => {}
http.interceptors.response.use(async(response) => {}
```

- 项目内不同模块的请求,定义在 `@/service/api/index.js` 文件内

(针对单个请求,依然可以做一些自定义的事情, 具体参照`@/service/api/home.js`)

```js
// 首页列表
export const homeList = (data = {}, callBack) => {
  return http.post('/bx/app/index/leader_index', data, {
    params: {},
    custom: { loading: false },
    getTask: (task, options) => {
      if (callBack) callBack(task)
    }
  })
}
```

- 页面内使用请求

```js
  onLoad(options) {
    this.$api.homeList().then(data => {})
  }
```
