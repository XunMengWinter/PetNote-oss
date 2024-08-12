//
//  GoodsTypeModel.swift
//  mymx
//
//  Created by ice on 2024/7/29.
//

import Foundation

struct GoodsTypeModel: Codable, Equatable, Identifiable, Hashable{
    var id: Int{
        get{
            return self.type
        }
    }
    var type: Int
    var name: String
    
    static var goodsTypes: [GoodsTypeModel] = [
        GoodsTypeModel(type: 100, name: "猫粮"),
        GoodsTypeModel(type: 150, name: "零食"),
        GoodsTypeModel(type: 200, name: "营养品"),
        GoodsTypeModel(type: 300, name: "护理"),
        GoodsTypeModel(type: 400, name: "智能"),
        GoodsTypeModel(type: 450, name: "用品"),
        GoodsTypeModel(type: 500, name: "猫砂"),
        GoodsTypeModel(type: 550, name: "狗粮"),
        GoodsTypeModel(type: 600, name: "周边"),
        ]
    
    static var goodsTypeDict: [Int: GoodsTypeModel] = [
        100: GoodsTypeModel(type: 100, name: "猫粮"),
        150: GoodsTypeModel(type: 150, name: "零食"),
        200: GoodsTypeModel(type: 200, name: "营养品"),
        300: GoodsTypeModel(type: 300, name: "护理"),
        400: GoodsTypeModel(type: 400, name: "智能"),
        450: GoodsTypeModel(type: 450, name: "用品"),
        500: GoodsTypeModel(type: 500, name: "猫砂"),
        550: GoodsTypeModel(type: 550, name: "狗粮"),
        600: GoodsTypeModel(type: 600, name: "周边"),
        ]
}
