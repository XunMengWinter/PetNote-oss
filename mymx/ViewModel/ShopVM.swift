//
//  ShopVM.swift
//  mymx
//
//  Created by ice on 2024/7/28.
//

import Foundation
import Alamofire

@MainActor
class ShopVM: ObservableObject{
    
    @Published var goodsList: [GoodsModel] = []
    @Published var banners: [Banner] = []
    @Published var searchHints: [SearchHint] = []
    
    @Published var typeFirstDict: [Int: GoodsModel] = [:]
    
    @Published var goodsTypes = GoodsTypeModel.goodsTypes
    @Published var typeCountDict: [GoodsTypeModel: Int] = [:]
    
    @Published var cartDict: [GoodsModel: Int] = [:]
    @Published var goodsCount: Int = 0
    @Published var goodsAmount: Int = 0
    
    func getGoodsList(){
        let res = MockData().goodsResult
        self.goodsList = res.data
        self.banners = res.banner
        self.searchHints = res.searchHints
        if(res.data.count > 1){
            var currentType = -1
            var index = 0
            for goods in res.data{
                let type = goods.type
                if(type != currentType){
                    currentType = type
                    self.typeFirstDict[type] = goods
                }
                index += 1
            }
        }
    }
    
    func clearCart(){
        cartDict.removeAll()
        typeCountDict.removeAll()
        goodsAmount = 0
        goodsCount = 0
    }
    
    func addToCart(goods: GoodsModel, count: Int){
        if(cartDict[goods] == nil){
            cartDict[goods] = 0
        }
        let nextCount:Int = cartDict[goods]! + count
        if(nextCount >= 0 && nextCount <= goods.stock){
            cartDict[goods] = nextCount
            goodsAmount += (count * goods.price)
            goodsCount += count
            if let goodsType = GoodsTypeModel.goodsTypeDict[goods.type]{
                if(typeCountDict[goodsType] == nil){
                    typeCountDict[goodsType] = 0
                }
                typeCountDict[goodsType]! += count
            }
        }
    }
    
    func cartToGoodsIds() -> [GoodsId]{
        var goodsIds: [GoodsId] = []
        cartDict.forEach({ goods, count in
            if(count > 0){
                goodsIds.append(GoodsId(_id: goods._id, count: count))
            }
        })
        return goodsIds
    }

}
