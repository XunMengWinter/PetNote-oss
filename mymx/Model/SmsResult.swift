//
//  SmsResult.swift
//  mymx
//
//  Created by ice on 2024/7/26.
//

import Foundation

struct SmsResult: Codable{
    var success: Bool = false
    var data: ResponseBody?
    var error: String?
    var code: Int?
}

struct ResponseBody: Codable{
    var bizId: String?
    var code: String?
    var message: String?
    var requestId: String?
}
