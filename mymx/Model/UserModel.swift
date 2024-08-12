//
//  UserModel.swift
//  mymx
//
//  Created by ice on 2024/7/7.
//

import Foundation

struct UserModel: Identifiable, Codable{
    let id: Int
    let joinRanking: Int?
    var name: String?
    var avatar: String?
//    let phone: String
    let mail: String
}
