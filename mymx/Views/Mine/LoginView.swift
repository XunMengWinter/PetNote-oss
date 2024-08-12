//
//  LoginView.swift
//  mymx
//
//  Created by ice on 2024/7/7.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var modelData: ModelData
    @StateObject var loginVM = LoginVM()
    @State private var mail: String = ""
    @State private var authCode: String = ""
    @State private var countDown = 60
    
    var body: some View {
        ZStack{
            Color.black.opacity(0.3)
                .ignoresSafeArea(edges: .top)
            VStack {
                Text("Welcome 🎉")
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    .padding()
                
                Text("🐈 登录使用喵～")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .padding(.bottom)
                
                HStack{
                    Text(loginVM.errorMsg)
                        .font(.subheadline)
                        .foregroundStyle(.red)
                    Spacer()
                }
                .padding(.horizontal)
                
                HStack(spacing: 8){
                    TextField("电子邮箱", text: $mail)
                        .keyboardType(.emailAddress)
                    
                }
                .padding(8)
                .background(.inputBg)
                .clipShape(.rect(cornerRadius: 6))
                .padding(.horizontal)
                
                HStack{
                    TextField("验证码", text: $authCode)
                        .keyboardType(.asciiCapableNumberPad)
                        .padding(8)
                        .background(.inputBg)
                        .clipShape(.rect(cornerRadius: 6))
                        .padding(.trailing, 8)
                    if loginVM.isSendAuth {
                        Text("已发送 \(countDown)s")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect(), perform: {_ in
                                if(countDown > 0){
                                    countDown -= 1
                                }
                                if(countDown == 0){
                                    loginVM.isSendAuth = false
                                    countDown = 60
                                }
                            })
                    }else if loginVM.smsLoading{
                        ProgressView("发送中...")
                    }else{
                        Button("获取验证码", action: {
                            loginVM.getAuthCode(mail: self.mail)
                        })
                        .font(.subheadline)
                        .foregroundStyle(.button2)
                    }
                }
                .padding()
                
                if(loginVM.loading){
                    ProgressView("登录中...")
                        .padding()
                }else{
                    Button("注册 / 登录", action: {
                        loginVM.login(mail: self.mail, authCode: self.authCode)
                    })
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
                    .background(.button)
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
            .padding()
            .background(.homeFactBg)
            .fontDesign(.rounded)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .padding(32)
            .dismissKeyboardOnScroll()
        }
        .onAppear(perform: {
            loginVM.initData(modelData: modelData)
        })
    }
}

#Preview {
    LoginView(loginVM: LoginVM())
        .environmentObject(ModelData())
}
