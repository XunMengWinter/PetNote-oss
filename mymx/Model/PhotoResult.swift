//
//  PhotoResult.swift
//  mymx
//
//  Created by ice on 2024/6/20.
//

import Foundation

//struct PostResponse: Decodable {
//    let response: PhotoResult
//}

struct PhotoResult: Codable, Hashable{
    var feedList: [PhotoModel]
    var more: Bool
//    var counts: Int
    var next: String
    var result: String
}
