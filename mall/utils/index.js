import * as pjson from '../package.json'

/**
 * 日期格式化
 * @param {string} fmt 格式化时间 eg：YYYY-MM-DD
 * @param {string} str 时间字符串
 * @return: {string}
 */
export const dateFormat = (fmt = '', str = '') => {
  const fn = function(d) {
    return ('0' + d).slice(-2)
  }

  if (typeof str === 'number') {
    const d = new Date(str)
    const formats = {
      YYYY: d.getFullYear(),
      MM: fn(d.getMonth() + 1),
      DD: fn(d.getDate()),
      HH: fn(d.getHours()),
      mm: fn(d.getMinutes()),
      ss: fn(d.getSeconds())
    }

    return fmt.replace(/([a-z])\1+/ig, function(a) {
      return formats[a] || a
    })
  }

  return str.replace(/-/g, '/').replace('T', ' ').replace(/\.[\d]{3}Z/, '')
}

/**
 * 获取软件名字
 * @return: {string}
 */
export const appName = () => {
  return pjson.name
}

/**
 * 获取软件版本号
 * @return: {string}
 */
export const appVersion = () => {
  return pjson.version
}

/**
 * 字符串处理为十个字
 * @param {string} s 要处理的字符串
 * @return: {string} 处理后的字符串
 */
export const trimShowString = (s = '') => {
  if (typeof (s) === 'undefined' || s === null || s.length === 0) return '-'
  if (s.length > 10) {
    return s.substring(0, 10).concat('...')
  }
  return s.substring(0, 10)
}

/**
 * 返回上级页面并刷新
 * @param {number} delta 返回层级
 * @param {any} args 回传参数
 * @return {any}
 */
export const navBackArguments = ({
  delta = 1,
  args = []
}) => {
  // eslint-disable-next-line no-undef
  const pages = getCurrentPages()
  if (pages.length > 1) {
    const prePage = pages[pages.length - delta - 1]
    // #ifdef APP-PLUS || MP-WEIXIN || MP-ALIPAY
    prePage.$vm.changeData(args) // 触发父页面中的方法
    // #endif

    // #ifdef H5
    prePage.changeData(args) // 触发父页面中的方法
    // #endif
  }
  uni.navigateBack({ delta: 1 })
}

/**
 * 通用弹窗
 * @param {string} title 弹窗标题
 * @param {string} content 弹窗内容
 * @param {string} cancelText 取消按钮文案
 * @param {string} confirmText 确定按钮文案
 * @param {BOOL} showCancel 是否展示取消按钮
 * @returns {Promise}
 */
export const showDelAlert = (param) => {
  param = { title: '', content: '', cancelText: '取消', confirmText: '确认', showCancel: true, ...param }
  return new Promise((resolve, reject) => {
    uni.showModal({
      ...param,
      cancelColor: '#666666',
      confirmColor: '#246DF1',
      success: res => {
        if (res.confirm) {
          resolve()
        } else if (res.cancel || (!res.cancel && !res.confirm)) {
          reject()
        }
      },
      fail: () => {
        reject()
      }
    })
  })
}

/**
 * 获取用户的定位信息
 * @return: Promise
 */
export const getLocationInfo = () => {
  return new Promise((resolve, reject) => {
    uni.getLocation({
      type: 'gcj02', // 'wgs84'
      geocode: true,
      success: res => {
        getAddress(res.longitude, res.latitude).then(address => {
          resolve(address)
        }).catch(() => {
          reject('')
        })
      },
      fail: () => {
        reject('')
      }
    })
  })
}

/**
 * 根据经纬度，逆地理编码出用户的中文地址
 * @param {number} longitude 经度
 * @param {number} latitude  纬度
 * @return: Promise
 */
export const getAddress = (longitude, latitude) => {
  return new Promise((resolve, reject) => {
    uni.request({
      url: `https://restapi.amap.com/v3/geocode/regeo`,
      method: 'GET',
      data: {
        key: 'f7ddefce1ff0128529450ada5ce1a64c',
        location: longitude + ',' + latitude,
        radius: '100',
        extensions: 'base',
        batch: false,
        roadlevel: 0
      },
      header: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      success: res => {
        if (res.data.status !== '1') {
          resolve('')
          return
        }
        const regeocode = res.data.regeocode
        if (regeocode.formatted_address && regeocode.formatted_address.length < 25) {
          resolve(regeocode.formatted_address)
          return
        }

        let info = ''
        const addressComponent = regeocode.addressComponent
        info = `${info}${addressComponent.province}${addressComponent.district}${addressComponent.township}`
        if (addressComponent.streetNumber) {
          const streetNumber = addressComponent.streetNumber
          info = `${info}${streetNumber.street}${streetNumber.number}`
        }
        resolve(info)
      },
      fail: () => {
        reject('')
      }
    })
  })
}

/**
 * 根据经纬度，逆地理编码出用户的中文地址
 * @param {number} longitude 经度
 * @param {number} latitude  纬度
 * @return: Promise
 */
export const getQQMapWSGeocoder = (longitude, latitude) => {
  return new Promise((resolve, reject) => {
    uni.request({
      url: `https://apis.map.qq.com/ws/geocoder/v1/`,
      method: 'GET',
      data: {
        key: 'B4IBZ-N5EAR-G4YWT-WJJJ3-HDZY6-P3BPB',
        location: latitude + ',' + longitude,
        get_poi: '0',
        // coord_type: '5',
        output: 'json'
      },
      header: {
        'content-type': 'application/x-www-form-urlencoded'
      },
      success: res => {
        if (res.data.status !== 0) {
          reject('')
          return
        }
        resolve(res.data.result)
      },
      fail: () => {
        reject('')
      }
    })
  })
}

export const SystemInfo = uni.getSystemInfoSync()
// export const reject = Promise.reject.bind(Promise)
// export const resolve = Promise.resolve.bind(Promise)
