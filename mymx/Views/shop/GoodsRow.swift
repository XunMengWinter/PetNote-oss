//
//  GoodsScrollView.swift
//  mymx
//
//  Created by ice on 2024/7/30.
//

import SwiftUI
import NukeUI

struct GoodsRow: View {
    
    var rowHeight: CGFloat = 112
    let goods: GoodsModel
    @Binding var cartDict: [GoodsModel: Int]
    let addToCart: (_ goods: GoodsModel, _ count: Int) -> Void
    
    var body: some View {
        HStack(spacing: 10){
            LazyImage(url: URL(string: goods.getImageUrl())){state in
                state.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: rowHeight, height: rowHeight)
                    .clipped()
            }
            .frame(width: rowHeight, height: rowHeight)
            
            VStack(alignment: .leading){
                Spacer(minLength: 0)
                Text(goods.name)
                    .font(.subheadline)
                    .lineLimit(2)
                    .padding(.bottom, 2)
                
                if goods.desc != nil && !goods.desc!.isEmpty{
                    Text(goods.desc ?? "")
                        .font(.caption)
                        .foregroundStyle(Color(hex: "777"))
                        .lineLimit(3)
                }
                Spacer(minLength: 0)
                Spacer(minLength: 0)
                HStack(spacing: 4){
                    VStack{
                        HStack(alignment: .bottom, spacing: 4){
                            Text("¥")
                                .font(.subheadline)
                            
                            Text(goods.getPriceStr())
                                .font(.headline)
                        }.foregroundStyle(.price)
                        
                    }
                    Spacer(minLength: 0)
                    if(cartDict[goods] != nil && cartDict[goods]! > 0){
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 22, height: 22)
                            .foregroundStyle(.yellow)
                            .onTapGesture {
                                addToCart(goods, -1)
                            }
                        Text("\(cartDict[goods]!)")
                            .font(.subheadline)
                            .frame(minWidth: 24)
                    }
                    Image(systemName: "plus.circle.fill")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.yellow)
                        .onTapGesture {
                            addToCart(goods, 1)
                        }
                }
                if let unitStr: String = goods.getUnitStr(){
                    Text(unitStr)
                        .font(.caption2)
                        .foregroundStyle(.button)
                }
                Spacer(minLength: 0)
            }
        }
        .frame(height: rowHeight)
    }
}
