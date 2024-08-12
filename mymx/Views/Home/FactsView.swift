//
//  FactsView.swift
//  mymx
//
//  Created by ice on 2024/7/1.
//

import SwiftUI
import NukeUI

struct FactsView: View {
    @ObservedObject var factsVM: FactsVM
    
    var body: some View {
        VStack{
            ZStack{
                LazyImage(url: URL(string: factsVM.nextTempImage)){ image in
                    image.image?
                        .resizable()
                        .scaledToFit()
                }
                .frame(height: 300)
                .opacity(0)
                
                LazyImage(url: URL(string: factsVM.tempImage)){ image in
                    image.image?
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                .frame(height: 300)
            }
            
            if(factsVM.loading){
                ProgressView()
                    .frame(width: 100 ,height: 100)
            }else{
                VStack(spacing: 16){
                    Text(factsVM.factModel!.fact)
                        .font(.title3)
                        .minimumScaleFactor(0.5)

                    Text(factsVM.factModel!.translate[0].dst)
                        .font(.title3)
                        .minimumScaleFactor(0.5)

                }.padding()
            }
            
            Spacer()

            HStack{
                Button("⇦ 上一条", action: {
                    factsVM.lastFact()
                })
                .disabled(factsVM.factIndex < 1)
                
                Spacer()
                Text("\(factsVM.factIndex + 1)")
                    .font(.title2)
                    .foregroundStyle(.gray)
                Spacer()
                Button("下一条 ⇨", action: {
                    factsVM.nextFact()
                })
            }
            .padding()
            .padding(.bottom, 20)
        }
        .onAppear(perform: {
            if(factsVM.factIndex+1 == factsVM.factList.count){
                // 已经显示到最后一个了，需要额外预加载一个
                factsVM.nextFact()
            }
        })
        .navigationTitle("猫咪趣闻")
    }
}

#Preview {
    FactsView(factsVM: FactsVM())
}
