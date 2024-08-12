//
//  PhotoModel.swift
//  mymx
//
//  Created by ice on 2024/6/20.
//

import Foundation
struct PhotoModel: Hashable, Codable{
    var type: String
    var data_id: String
    var entry: Entry
    struct Entry: Hashable, Codable{
        var post_id: Int
        var author_id: String
        var type: String
        var url: String
        var published_at: String
        var title: String
        var image_count: Int
        var content: String
        var update: Bool
        var images: [ImageModel]
        var title_image: TitleImage
        var site: SiteModel
    }
    
    struct ImageModel: Hashable, Codable {
        var img_id: Int
        var img_id_str: String
        var title: String
        var excerpt: String
        var width: Int
        var height: Int
        var description: String
        var isAuthorTK: Bool
    }
    
    struct TitleImage: Hashable, Codable {
        var width: Int
        var height: Int
        var url: String
        var img_id: Int
    }
    
    struct SiteModel: Hashable, Codable {
//        var site_id: String
        var type: String
        var name: String
        var domain: String?
        var url: String
        var icon: String
        var intro: String
    }
    
}
