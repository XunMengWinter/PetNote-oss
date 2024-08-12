//
//  CatImageModel.swift
//  mymx
//
//  Created by ice on 2024/7/2.
//

import Foundation

struct CatImageModel: Codable, Identifiable{
    let id: String
    let source: String?
    let imageUrl: String
    let username:String
}
