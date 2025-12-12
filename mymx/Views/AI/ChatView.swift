//
//  ChatView.swift
//  mymx-oss
//
//  Created by ice on 2025/3/11.
//
import SwiftUI

struct ChatView: View {
    @State private var inputText: String = ""
    @StateObject private var viewModel = ChatVM()
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        VStack(spacing: 0){
            ScrollViewReader { scrollProxy in
                ScrollView{
                    VStack(alignment: .leading, spacing: 16) {
                        Text("🤖 Instruction (即AI的人设，以下为interview模式)：")
                            .font(.title2)
                        Text("""
          你是一名经验丰富的宠物医生，专精于宠物疾病诊断与治疗。用户会向你咨询宠物健康问题，你的目标是提供准确、专业的建议。
          
          请按照以下步骤进行：
          1️⃣ **收集关键信息**：
             - 询问宠物的 **品种、年龄、性别、体重**
             - 了解 **症状的持续时间、严重程度**
             - 是否有 **饮食变化、精神状态异常**
             - 近期是否 **接触过其他生病的动物**
             - 是否有 **疫苗接种和驱虫记录**
          
          2️⃣ **分析症状**：
             - 根据用户提供的信息，评估可能的健康问题
             - 考虑 **常见疾病**（如肠胃炎、皮肤病、寄生虫感染）或 **潜在严重问题**
          
          3️⃣ **提供建议**：
             - 若可能是 **轻微疾病**，提供 **家庭护理建议**（如饮食调整、补充水分）
             - 若症状 **严重或持续恶化**，建议 **及时就医**，并提供需要关注的症状警示
          
          请确保你的回答 **简洁清晰**，并在信息不足时 **优先收集必要信息**，而不是直接给出诊断。
        """)
                        .padding()
                        
                        ForEach(viewModel.messageList) { message in
                            HStack {
                                if message.isUser {
                                    Spacer()
                                    Text(message.content)
                                        .textSelection(.enabled)
                                        .padding()
                                        .background(.blue.opacity(0.2))
                                        .cornerRadius(16)
                                        .padding(.leading, 80)
                                } else {
                                    Text(.init(message.content))
                                        .textSelection(.enabled)
                                        .padding()
                                        .background(.searchBg)
                                        .cornerRadius(16)
                                    Spacer()
                                }
                            }
                        }
                        
                        if viewModel.loading{
                            HStack{
                                Text("思考中 💭")
                                ProgressView()
                                    .padding()
                                Spacer()
                            }
                            .id("loadingView")
                        }
                    }
                    .padding()
                }
                .scrollDismissesKeyboard(.immediately)
                .onChange(of: viewModel.loading, {
                    withAnimation {
                        scrollProxy.scrollTo("loadingView", anchor: .bottom)
                    }
                })
            }
            HStack{
                TextField("描述一下宠物症状", text: $inputText)
                    .padding()
                    .submitLabel(.send)
                    .onSubmit {
                        if viewModel.chatWithDoctor(chatContent: inputText){
                            inputText = ""
                        }
                    }
                Image(systemName: "paperplane.fill")
                    .foregroundStyle(.blue)
                    .padding()
                    .onTapGesture {
                        if viewModel.chatWithDoctor(chatContent: inputText){
                            inputText = ""
                        }
                    }
            }
            .font(.title3)
            .border(.green)
        }
        .dismissKeyboardOnScroll()
        .navigationTitle("AI宠医生")
    }
}
