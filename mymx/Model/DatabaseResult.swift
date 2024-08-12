//
//  DatabaseResult.swift
//  mymx
//
//  Created by ice on 2024/7/8.
//

import Foundation

struct DatabaseResult: Codable{
    var code: Int?
    var success: Bool
    var error: String?
}
