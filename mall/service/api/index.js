// import * as home from './home.js'
// import * as mine from './mine.js'

// export default {
//   ...home,
//   ...mine
// }

const files = require.context('./apis', true, /\.js/)
let modules = {}

files.keys().forEach(key => {
  if (key === './index.js') return
  modules = Object.assign(modules, files(key))
})

export default modules
