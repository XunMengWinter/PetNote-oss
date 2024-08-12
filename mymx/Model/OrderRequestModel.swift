//
//  OrderRequestModel.swift
//  mymx
//
//  Created by ice on 2024/8/6.
//

import Foundation

struct OrderRequestModel: Codable{
    var orderId: Int?
    var goodsIds: [GoodsId]
    let goodsAmount: Int
    var takeWay: Int
//    var address: AddressModel
    var note: String
    var payWay: String
    
}

struct GoodsId: Codable{
    let _id: String
    let count: Int
}
