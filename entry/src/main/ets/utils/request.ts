import axios, { InternalAxiosRequestConfig } from '@ohos/axios'
import router from '@ohos.router';


let BASE_URL:string = 'http://127.0.0.1:8080'
AppStorage.SetOrCreate("token","");

axios.defaults.headers['Content-Type'] = 'application/json;charset=utf-8';
// 请求拦截器
export function  request(config){
  const instance =   axios.create({
    baseURL:BASE_URL,
    timeout:5000,
    headers:{
      Authorization:""
    }
  });

  instance.interceptors.request.use((config:InternalAxiosRequestConfig)=>{
    let token:string =  AppStorage.Get("token")
    config.headers.Authorization= token;
    // console.log("token is :" + config.headers.Authorization)
    return config
  },err=>{
    console.log(err)
  })

  instance.interceptors.response.use(res=>{

    if(res.data.status == -1){
      router.pushUrl({url:'pages/Login'})
      let token = res.config.headers.Authorization
      AppStorage.SetOrCreate("token",token)

    }

    return res
  }),
  err=>{
    console.error(err)
  }

  return instance(config)
}