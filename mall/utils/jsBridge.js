// #ifdef H5
const u = navigator.userAgent
// Android终端
const isAndroid = u.indexOf('Android') > -1 || u.indexOf('Adr') > -1
// iOS 终端
const isiOS = !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/)

function setupWebViewJavascriptBridge(callback) {
  // Android使用
  if (isAndroid) {
    if (window.WebViewJavascriptBridge) {
      callback(window.WebViewJavascriptBridge)
    } else {
      document.addEventListener(
        'WebViewJavascriptBridgeReady',
        function() {
          callback(window.WebViewJavascriptBridge)
        },
        false
      )
    }
    // sessionStorage.phoneType = 'android'
  }
  if (isiOS) {
    if (window.WebViewJavascriptBridge) return callback(window.WebViewJavascriptBridge)
    if (window.WVJBCallbacks) return window.WVJBCallbacks.push(callback)
    window.WVJBCallbacks = [callback]
    var WVJBIframe = document.createElement('iframe')
    WVJBIframe.style.display = 'none'
    WVJBIframe.src = 'wvjbscheme://__BRIDGE_LOADED__'
    document.documentElement.appendChild(WVJBIframe)
    setTimeout(function() {
      document.documentElement.removeChild(WVJBIframe)
    }, 0)
    // sessionStorage.phoneType = 'ios'
  }
}

// 注册回调函数，第一次连接时调用 初始化函数(android需要初始化,ios不用)
setupWebViewJavascriptBridge(bridge => {
  if (isAndroid) {
    // 初始化
    bridge.init((message, responseCallback) => {
      var data = {
        'Javascript Responds': 'Wee!'
      }
      responseCallback(data)
    })
  }
})
// #endif

export default {
  // js调APP方法 （参数分别为:app提供的方法名  传给app的数据  回调）
  callHandler(name, data, callback) {
    // #ifdef H5
    setupWebViewJavascriptBridge(bridge => {
      bridge.callHandler(name, data, callback)
    })
    // #endif
  },
  // APP调js方法 （参数分别为:js提供的方法名  回调）
  registerHandler(name, callback) {
    // #ifdef H5
    setupWebViewJavascriptBridge(bridge => {
      bridge.registerHandler(name, (data, responseCallback) => {
        callback(data, responseCallback)
      })
    })
    // #endif
  }
}
