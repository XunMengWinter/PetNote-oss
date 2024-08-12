//
//  StsResult.swift
//  mymx
//
//  Created by ice on 2024/7/10.
//

import Foundation

struct StsResult: Codable{
    let sts: StsModel?
}

//   let stsModel = try? JSONDecoder().decode(StsModel.self, from: jsonData)
// MARK: - StsModel
struct StsModel: Codable {
    let expire, policy, signature, accessid: String
    let stsToken: String
    let host: String
    let dir: String
}
