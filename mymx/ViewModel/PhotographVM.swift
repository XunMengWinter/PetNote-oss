//
//  PhotoViewModel.swift
//  mymx
//
//  Created by ice on 2024/6/20.
//

import Foundation
import Alamofire

class PhotographVM: ObservableObject {
    @Published var photoList = [Photo]()
    @Published var error: AFError?
    private var page = 1
    let pageCount = 10
    private let tagId = 501
    private var next = ""
    
    func fetchFirst(){
        self.page = 1
        self.next = ""
        self.photoList = []
        self.error = nil
        fetchPhoto()
    }
    
    func fetchMore(){
        self.error = nil
        self.page += 1
        fetchPhoto()
    }
    
    private func fetchPhoto() {
//        let url: String = "https://api.tuchong.com/tags/501/works?count=10&page=1&order=new&tag_type=id"
        let url = "https://api.tuchong.com/tags/\(tagId)/works?count=\(pageCount)&order=new&page=\(page)&tag_type=id&next=\(next)"
        print("fetchPhoto: page \(page)" )
        // 使用 Alamofire 进行 GET 请求
        AF.request(url)
            .validate()
            .responseDecodable(of: PhotoResult.self) { response in
                switch response.result {
                case .success(let photoResult):
                    // Handle the decoded object
                    let newList = photoResult.feedList.map{self.feed2Photo(feed:$0)}
                    if(photoResult.more){
                        self.next = photoResult.next
                    }
                    self.photoList.append(contentsOf: newList)
                case .failure(let error):
                    // Handle any errors
                    self.error = error
                    self.page -= 1
                    print("Request failed with error: \(error)")
                }
                
            }
    }

    
    private func feed2Photo(feed: PhotoModel) -> Photo{
        Photo(
            id: feed.data_id,
            author_id: feed.entry.author_id,
            name: feed.entry.site.name,
            avatar: feed.entry.site.icon,
            title_image: feed.entry.title_image.url,
            images: feed.entry.images.map{
                let prefix = "https://photo.tuchong.com/" + feed.entry.author_id + "/f/"
                let url = prefix + $0.img_id_str + ".jpg"
                return Photo.Image(imageUrl: url, width: $0.width, height: $0.height)
            },
            title: feed.entry.title,
            content: feed.entry.content,
            published_at: feed.entry.published_at
        )
    }
}

