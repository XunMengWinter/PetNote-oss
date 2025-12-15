//
//  TabooVM.swift
//  mymx-oss
//
//  Created by ice on 2025/3/12.
//

import Foundation
import Alamofire

@MainActor
class TabooVM: ObservableObject{
    
    @Published var foodTaboo: TabooModel?
    @Published var isSearching = false
    
    func searchTaboo(foodName: String){
        if(isSearching){
            return
        }
        isSearching = true
        print("searchTaboo: \(foodName)")
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        let parameters = ["chatContent": foodName]
        AF.request(Urls.SEARCH_TABOO, method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: BaseResult<TabooModel>.self){ response in
                Task{ @MainActor in
                    self.isSearching = false
                    switch response.result {
                    case .success(let res):
                        self.foodTaboo = res.data
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
    }
    
}
