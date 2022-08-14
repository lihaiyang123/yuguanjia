// jsapi文档地址: https://www.yuque.com/ico-fe/gny34o/wefsia
const jsapi = {
  GZAPP_TOKEN: 'gzAppToken',
  GZNAVIGATE_TO: 'gzNavigateTo',
  GZNATIVE_TO_TINY_APP_OPEN_WEBVIEW: 'gzNativeToTinyAppOpenWebview',
  GZ_WX_PAY: 'gzwxPay'
}

const jsBridge = {
  GZH5_TO_NATIVE_NAVIGATE_TO: 'gzH5ToNativeNavigateTo',
  GZH5_TO_NATIVE_OPEN_WINDOW: 'gzH5ToNativeOpenWindow',
  GZH5_TO_NATIVE_WX_PAY: 'gzH5ToNativeWxPay'
}

const apiCloud = {
  GZAPI_TO_NATIVE_OPEN_WINDOW: 'gzAPIToNativeOpenWindow'
}

const aes = {
  // #ifdef H5
  AES_KEY_H5: 'abcdefghijt65442',
  // #endif
  // #ifdef MP-ALIPAY || MP-WEIXIN
  AES_KEY_MINI: 'abcdefghijt6cv21'
  // #endif
}

const nativeRouter = {
  GZ_NATIVE_MALL: 'decoder://router?page_key=index&from_key=applet&to_key=android&params_key=pageIndex=3',
  GZ_NATIVE_HOME: 'decoder://router?page_key=index&from_key=applet&to_key=android',
  GZ_NATIVE_LOGIN: 'decoder://router?page_key=login&from_key=applet&to_key=android',
  GZ_NATIVE_POST: 'decoder://router?page_key=post&from_key=applet&to_key=android',
  GZ_H5BRIDGE_LOGIN: 'decoder://router?page_key=login&from_key=h5&to_key=android',
  GZ_H5BRIDGE_SEARCH2: 'decoder://router?page_key=search&from_key=h5&to_key=android&params_key=source=2&is_need_check_session=false',
  GZ_H5BRIDGE_SEARCH3: 'decoder://router?page_key=search&from_key=h5&to_key=android&params_key=source=3&is_need_check_session=false'
}

// storage存储key
const storage = {
  APP_TOKEN: 'app-token',
  UNION_ID: 'unionid',
  OPEN_ID: 'openid',
  CURRENT_PATH: 'currentPath',
  USER_INFO: 'userInfo',
  USER_ID: 'userId',
  WXMINI_APP_TOKEN: 'wxMiniAppToken',
  SESSION_KEY: 'session_key'
}

export default {
  AES_KEY: aes.AES_KEY_MINI || aes.AES_KEY_H5,
  ...jsapi,
  ...jsBridge,
  ...apiCloud,
  ...nativeRouter,
  ...storage
}
