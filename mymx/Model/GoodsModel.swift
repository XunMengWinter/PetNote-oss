//
//  GoodsModel.swift
//  mymx
//
//  Created by ice on 2024/7/28.
//

import Foundation

struct GoodsModel: Codable, Hashable{
    let _id: String
    let type: Int
    let weight: Int?
    let desc: String?
    let price: Int
    let score: Int?
    let images: [String]
    let name: String
    let stock: Int
    let brand: String?
    
    var typeModel: GoodsTypeModel{
        get{
            return GoodsTypeModel.goodsTypeDict[type] ?? GoodsTypeModel(type: type, name: "unknown")
        }
    }
    
    func getUnitStr() -> String?{
        if(type == 100 && weight != nil && weight! > 0){
            let unitPrice: Float = Float(price * 5 * 10 / weight!).rounded() / 10.0
            if floor(unitPrice) == unitPrice{
                return "( ¥ \(Int(unitPrice)) / 斤 )"
            }
            return "( ¥ \(unitPrice) / 斤 )"
        }
        return nil
    }
    
    func getPriceStr() -> String{
        if price % 100 == 0{
            return String(price / 100)
        }
        let priceY: Float = Float(price) / 100.0
        return String(priceY)
    }
    
    func getImageUrl() -> String {
        if images.isEmpty {
            return ""
        }
        
        let link = images[0]
        
        if !link.hasPrefix("cloud"){
            return link
        }
        
        do {
            var arr = link.split(separator: "/")
            arr[0] = "https:/"
            arr[1] = arr[1].split(separator: ".")[1] + ".tcb.qcloud.la"
            let url = arr.joined(separator: "/")
            return url
        } catch{
            return link
        }
    }
}
