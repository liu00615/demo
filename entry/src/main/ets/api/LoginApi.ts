import {http} from  '../utils/http';
import type {UserModule} from '../modules/UserModule'

export const LoginApi = () => {
  return http.post<UserModule>('/user/login')
}