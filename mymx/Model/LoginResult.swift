//
//  LoginResult.swift
//  mymx
//
//  Created by ice on 2024/7/8.
//

import Foundation

struct LoginResult: Codable{
    var code: Int?
    var error: String?
    var user: UserModel?
    var token = "" 
    var tokenExpires = 0
}
