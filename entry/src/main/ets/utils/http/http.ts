//封装HTTP
import axios from '@ohos/axios'
import { promptAction } from '@kit.ArkUI'
import type {AnyObject} from '../../modules/HttpModule'

const request = axios.create({
  //后端服务器的ip地址
  baseURL: 'http://127.0.0.1:8080'
})

request.interceptors.request.use(
  (config) => {

    //token待添加
    return config
  }
)

request.interceptors.response.use(
  (response) => {
    if(response.data.code === 1){//后端返回1成功，返回0表示失败
      return response.data.data
    } else {
      //错误提示
      promptAction.showToast(response.data.message)
      return Promise.reject(response.data.message)
    }
  },
  (error) => {
    promptAction.showToast(error.message)
    return Promise.reject(error.message)
  }
)

export default class Http {

  get<T>(url: string, params?: AnyObject){
    return request.get<any, T>(url, { params })
  }

  post<T>(url: string, data?: AnyObject){
    return request.post<any,T>(url,data)
  }

  put<T>(url: string, data?: AnyObject){
    return request.put<any,T>(url,data)
  }

  delete<T>(url: string, params?: AnyObject){
    return request.delete<any, T>(url, { params })
  }
}