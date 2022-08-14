import { http } from '@/service/api/config/httpConfig.js'

// 博客列表 分页
export const homeList = (data = { pageNum: 1 }) => {
  return http.get(`/api/posts/${data.pageNum}.json`, { params: {}, custom: { loading: false }})
}
