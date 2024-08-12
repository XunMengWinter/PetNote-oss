//
//  Photo.swift
//  mymx
//
//  Created by ice on 2024/6/20.
//

import Foundation

struct Photo: Codable, Hashable, Identifiable{
    var id: String
    var author_id: String
    var name: String
    var avatar: String
    var title_image: String
    var images: [Image]
    var title: String
    var content: String
    var published_at: String
    
    struct Image: Codable, Hashable{
        let imageUrl: String
        let width: Int
        let height: Int
    }
    
    func getPublishedTime()->String{
        // 2024-06-21 17:00:25
        return String(published_at.suffix(14).prefix(11))
    }
}
