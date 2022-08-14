import Vue from 'vue'
import App from './App'

import { http } from '@/service/api/config/httpConfig.js'
import store from '@/service/store'
import * as utils from '@/utils/index'
import jsBridge from '@/utils/jsBridge'

import api from '@/service/api/index'
import * as storage from '@/service/storage/index'

import uView from '@/components/uview-ui'
Vue.use(uView)

Vue.config.productionTip = false

App.mpType = 'app'

Vue.prototype.$http = http
Vue.prototype.$api = api
Vue.prototype.$storage = storage

Vue.prototype.$store = store
Vue.prototype.$utils = utils
Vue.prototype.$jsBridge = jsBridge

const app = new Vue({
  store,
  ...App
})
app.$mount()
