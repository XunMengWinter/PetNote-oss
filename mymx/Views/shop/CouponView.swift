//
//  CouponCenterView.swift
//  mymx
//
//  Created by ice on 2024/8/8.
//

import SwiftUI
import NukeUI

struct CouponView: View {
    
    let imageUrl = "https://pet-note.oss-cn-hangzhou.aliyuncs.com/doc/kiska-cm.png"
    
    let screenSize = UIScreen.main.bounds.size
        
    var body: some View {
        ScrollView{
            VStack{
                LazyImage(url: URL(string: imageUrl)){ state in
                    state.image?
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: .infinity)
                }
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                
                ForEach([1,2], id: \.self){ item in
                    ZStack {
                        Image("bg_gift_card")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 360, height: 210)
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 0) {
                                Text("\(2000 / 100.0, specifier: "%g")元优惠券")
                                    .font(.title)
                                    .foregroundStyle(Color(hex: "000"))
                                    .padding(.top, 40)
                                
                                Text("满\(18800 / 100.0, specifier: "%g")元即可使用")
                                    .fontWeight(.light)
                                    .foregroundColor(.gray)
                                    .padding(.top, 16)
                                
                                Spacer()
                                
                                Text("有效期至2025年3月28日")
                                    .font(.callout)
                                    .fontWeight(.light)
                                    .foregroundColor(Color(hex: "333"))
                                    .padding(.bottom, 26)
                            }
                            .padding(.leading, 32)
                            Spacer()
                        }
                        .frame(width: 360, height: 210)
                    }
                    .frame(width: 360, height: 210)
                    .padding(.top, 20)
                    .scaleEffect(0.9)
                }
                Spacer().frame(height: 120)
                Spacer()
            }
            .frame(minHeight: screenSize.height)
            .background(Color(red: 0.737, green: 0.886, blue: 0.827))
        }
        .background(.lightBg)
        .navigationTitle("我的优惠券")
        .onAppear(perform: {
            
        })
    }
}

#Preview {
    CouponView()
}
