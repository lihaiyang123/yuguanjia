// 设置和清理本地存储登录账号
export const storageLoginAccount = (param = {}) => {
  if (param && param.phone) {
    uni.setStorageSync('login_account', param)
  } else {
    uni.removeStorageSync('login_account')
  }
}
// 获取本地存储登录账号
export const getStorageLoginAccount = () => uni.getStorageSync('login_account')

// 登录个人信息
export const storageUserInfo = (param = {}) => {
  if (param && param.sid) {
    uni.setStorageSync('userInfo', param)
  } else {
    uni.removeStorageSync('userInfo')
  }
}

// 获取本地存储个人信息
export const getStorageUserInfo = () => uni.getStorageSync('userInfo')
