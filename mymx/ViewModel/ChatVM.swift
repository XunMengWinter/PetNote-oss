//
//  ChatVM.swift
//  mymx-oss
//
//  Created by ice on 2025/3/12.
//


import Foundation
import Alamofire

@MainActor
class ChatVM: ObservableObject{
    
    @Published var messageList: [ChatMessage] = []
    @Published var loading = false
    
    func chatWithDoctor(chatContent: String) -> Bool{
        if(loading){
            return false
        }
        let content = chatContent.trimmingCharacters(in: .whitespacesAndNewlines)
        if content.isEmpty{
            return false
        }
        let message = ChatMessage(content: content, isUser: true, createTime: Int(Date().timeIntervalSince1970))
        messageList.append(message)
        print("chatWithDoctor")
        loading = true
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        let parameters: [String: Sendable] = [
            "chatContent": content
        ]
        AF.request(Urls.AI_CHAT_DOCTOR, method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: BaseResult<String>.self) {response in
                Task{ @MainActor in
                    self.loading = false
                    switch response.result{
                    case .success(let res):
                        print(res)
                        if let chat = res.data{
                            let resMessage = ChatMessage(content: chat, isUser: false, createTime: Int(Date().timeIntervalSince1970))
                            self.messageList.append(resMessage)
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        return true
    }
}

