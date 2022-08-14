/**
 * 设置API接口地址
 * @param {String} env 环境变量 默认为null
 * setEnvApiBaseURL('test') 自定义环境
 * @return {*}
 */
export const setEnvApiBaseURL = (env) => {
  if (!env) env = 'production'
  const URLMAP = {
    development: 'https://www.cqzhong.cn',
    test: 'https://www.cqzhong.cn',
    production: 'https://www.cqzhong.cn'
  }
  if (!URLMAP[env]) env = 'production'
  return URLMAP[env]
}
