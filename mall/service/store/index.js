import Vue from 'vue'
import Vuex from 'vuex'
// import Api from '@/service/api/index'

Vue.use(Vuex)

const store = new Vuex.Store({
  state: {
    token: uni.getStorageSync('token') || ''
  },
  mutations: {
    // 更新token
    SET_TOKEN(state, token) {
      state.token = token
      if (token) {
        uni.setStorageSync('token', token)
      } else {
        // 退出时清除token
        uni.removeStorage({ key: 'token' })
      }
    },
    SET_QINIU_TOKEN(state, data) {
      state.qiniu.token = data.token
      state.qiniu.baseUrl = data.bucketUrl
    }
  },
  getters: {},
  actions: {
    qiniuTokenAsync({ commit }) {
      // Api.getQiniuToken().then((res) => {
      //   commit('SET_QINIU_TOKEN', res)
      // })
    }
  },
  modules: {}
})
export default store
