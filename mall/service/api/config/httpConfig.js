import Request from '@/components/luch-request/index.js'
// import $store from '@/service/store'
import * as networkConfig from '@/service/api/config/index'

const http = new Request()

/**
 * 设置全局配置
 */
// http.config.baseURL = ''
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

/**
 * 请求之前拦截器。可以使用async await 做异步操作
 */
// 当前接口请求数
let requestNum = 0
http.interceptors.request.use((config) => {
  if (config.custom.loading) {
    if (requestNum <= 0) {
      uni.showLoading({
        title: config.custom.loadTitle
      })
    }
    requestNum += 1
  }
  /**
   * return Promise.reject(config) 会取消本次请求
   */
  return config
}, (config) => {
  return Promise.reject(config)
})

/**
 * 请求之后拦截器。可以使用async await 做异步操作
 */
http.interceptors.response.use(async(response) => {
  hideLoading(response.config.custom.loading)
  const statusCode = Number(response.statusCode)
  if (statusCode !== 200) {
    return Promise.reject(response)
  }
  return Promise.resolve(response.data)
}, (response) => {
  // 请求错误做点什么。可以使用async await 做异步操作
  hideLoading(response.config.custom.loading)
  showPrompt(response.config.custom.isPrompt)
  return Promise.reject(response)
})

/**
 * 隐藏加载框
 */
const hideLoading = (loading) => {
  if (!loading) return
  requestNum = requestNum - 1
  if (requestNum <= 0) {
    uni.hideLoading()
  }
}

/**
 * 弹出错误提示语
 */
const showPrompt = (isPrompt, title = '网络错误，请检查一下网络') => {
  if (!isPrompt) return
  setTimeout(() => {
    uni.showToast({
      title,
      icon: 'none',
      duration: 2000
    })
  }, 300)
}

export {
  http
}
