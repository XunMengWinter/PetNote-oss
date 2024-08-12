//
//  FactsVM.swift
//  mymx
//
//  Created by ice on 2024/7/1.
//

import Foundation
import Alamofire

class FactsVM: ObservableObject{
    var factList: [FactModel] = []
    @Published var loading = true
    @Published var factIndex = -1
    @Published var factModel: FactModel?
    @Published var error: AFError?
    
    var tempImages: [String] = []
    @Published var tempImage = ""
    @Published var nextTempImage = ""
    
    private func fetchRandomFact() {
        // 使用 Alamofire 进行 GET 请求
        print("fetchRandomFact")
        fetchRandomImage()
        AF.request(Urls.CAT_FACT)
            .responseDecodable(of: FactModel.self) { response in
                switch response.result {
                case .success(let factModel):
                    self.factList.append(factModel)
                    if(self.loading){
                        self.loading = false
                        self.factIndex += 1
                        self.factModel = self.factList[self.factIndex]
                        self.refreshImage()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    struct ImageUrlModel: Codable{
        var imageUrl: String?
    }
    
    private func fetchRandomImage() {
        print("fetchRandomImage")
        AF.request(Urls.GET_RANDOM_IMAGE)
            .validate()
            .responseDecodable(of: ImageUrlModel.self) { response in
                switch response.result {
                case .success(let data):
                    if let imageUrl = data.imageUrl{
                        self.tempImages.append(imageUrl)
                        self.refreshImage()
                    }
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    private func refreshImage(){
        if(factIndex < 0){
            return
        }
        if(factIndex < tempImages.count){
            self.tempImage = tempImages[factIndex]
            if(factIndex+1 < tempImages.count){
                self.nextTempImage = tempImages[factIndex+1]
            }
        }
    }
    
    func lastFact(){
        let lastIndex = self.factIndex - 1
        if(lastIndex >= 0){
            self.factIndex = lastIndex
            self.factModel = factList[lastIndex]
            self.refreshImage()
        }
    }
    
    func nextFact(){
        let nextIndex = self.factIndex + 1
        if(nextIndex < factList.count){
            self.factIndex = nextIndex
            self.factModel = factList[nextIndex]
            self.refreshImage()
        }else{
            self.loading = true
        }
        
        // [a,a,a] nextIndex = 1
        if(nextIndex + 3 > factList.count){
            fetchRandomFact()
        }
    }
    
}
