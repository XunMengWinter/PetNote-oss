//
//  LoginVM.swift
//  mymx
//
//  Created by ice on 2024/7/7.
//

import Foundation
import Combine
import Alamofire

class LoginVM: ObservableObject {
    private var modelData: ModelData?
    @Published var error: AFError?
    @Published var loading = false
    @Published var smsLoading = false
    @Published var isSendAuth = false
    @Published var errorMsg = ""
    
    func initData(modelData: ModelData) {
        if(self.modelData == nil){
            self.modelData = modelData
        }
    }
    
    func getAuthCode(mail: String) {
        print("getAuthCode: \(mail)")
        if(mail.count < 5){
            // 请输入正确的手机号码
            errorMsg = "请输入邮箱"
            return
        }
        smsLoading = true
        isSendAuth = false
        errorMsg = ""
        // 使用 Alamofire 进行 GET 请求
        let parameters: [String: Any] = [
            "mail": mail,
        ]

        AF.request(Urls.GET_AUTH_CODE, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: SmsResult.self) { response in
                print(response)
                self.smsLoading = false
                switch response.result{
                case .success(let res):
                    if(res.success){
                        self.isSendAuth = true
                    }else if let msg = res.data?.message{
                        self.errorMsg = msg
                    }else if let errorMsg = res.error{
                        self.errorMsg = errorMsg
                    }
                case .failure(let error):
                    self.error = error
                    self.errorMsg = error.errorDescription ?? "获取验证码遇到了一点小问题，请重试。"
                    print("Request failed with error: \(error)")
                    break
                }
            }
    }
    
    
    func login(mail: String, authCode: String) {
        print("login: \(mail)")
        // 使用 Alamofire 进行 GET 请求
        loading = true
        self.errorMsg = ""
        let parameters: [String: Any] = [
            "mail": mail,
            "authCode": authCode
        ]

        AF.request(Urls.LOGIN, method: .post, parameters: parameters)
            .validate()
            .responseDecodable(of: LoginResult.self) { response in
                print(response)
                self.loading = false
                switch response.result {
                case .success(let res):
                    // 将token与token有效期保存至静态常量
                    if !res.token.isEmpty{
                        GlobalParams.token = res.token
                        GlobalParams.tokenExpires = res.tokenExpires
                        
                        self.modelData!.user = res.user
                        if let encoded = try? JSONEncoder().encode(res) {
                            UserDefaults.standard.set(encoded, forKey: DataKeys.LOGIN_RESULT)
                        }
                        if let encoded = try? JSONEncoder().encode(res.user?.mail) {
                            UserDefaults.standard.set(encoded, forKey: DataKeys.LAST_LOGIN_MAIL)
                        }
                    }else if let errorMsg = res.error{
                        self.errorMsg = errorMsg
                    }
                case .failure(let error):
                    self.error = error
                    self.errorMsg = error.errorDescription ?? "登录遇到了一点小问题，请重试。"
                    print("Request failed with error: \(error)")
                }
                
            }
    }
    
}

