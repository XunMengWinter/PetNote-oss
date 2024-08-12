//
//  JoinRankingView.swift
//  mymx
//
//  Created by ice on 2024/8/11.
//

import SwiftUI

struct JoinRankingView: View {

    // 设置小于等于0，会dismiss。
    @Binding var joinRanking: Int

    var body: some View {
        NavigationStack{
            ZStack{
                Image("pearlescent")
                    .resizable()
                    .scaledToFill()
                VStack {
                    Image("zoo")
                        .padding()
                    
                    Text("欢迎加入爱宠社OSS！")
                        .font(.title)
                        .padding()
                    
                    Text("🏆 恭喜成为第 \(joinRanking)  位社员  🎊  🎉")
                        .font(.title2)
                        .padding()
                    
                    Button(action: {
                        withAnimation{
                            self.joinRanking = 0
                        }
                    }, label: {
                        Text("进入爱宠社")
                            .padding(.horizontal, 6)
                            .padding()
                            .font(.headline)
                            .foregroundStyle(.white)
                            .background(.button)
                            .clipShape(.rect(cornerRadius: 10))
                            .padding()
                    })
                }
            }
        }
    }
}

#Preview {
    JoinRankingView(joinRanking: .constant(2))
}
