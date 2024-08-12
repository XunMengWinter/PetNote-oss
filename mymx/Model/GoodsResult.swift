//
//  GoodsResult.swift
//  mymx
//
//  Created by ice on 2024/7/28.
//

import Foundation

struct GoodsResult: Codable{
    let data: [GoodsModel]
    let banner: [Banner]
    let searchHints: [SearchHint]
    let updateTime: Int64?
}

struct Banner: Codable{
    let title: String
    let imageUrl: String
    let url: String
}

struct SearchHint: Codable{
    let key: String
    let value: String
}
