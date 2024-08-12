//
//  WeatherBgPickerVM.swift
//  mymx
//
//  Created by ice on 2024/6/25.
//

import Foundation
import Alamofire

class WeatherBgPickerVM: ObservableObject {
    @Published var bgImageDict = [String: [String]]()
    @Published var error: AFError?
    @Published var imagesKeys = [String]()
    func fetchImageDict() {
        // 使用 Alamofire 进行 GET 请求
        let parameters: [String: Any] = [
            "methodType": "getBgImages",
            // Add any additional parameters as needed
        ]
        // 使用 Alamofire 进行 GET 请求
        AF.request(Urls.POETRY_WAETHER, parameters: parameters)
            .responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let decoder = JSONDecoder()
                        let bgImageDict = try decoder.decode([String: [String]].self, from: data)
                        self.bgImageDict = bgImageDict
                        for(key, _) in bgImageDict{
                            self.imagesKeys.append(key)
                        }
                    } catch {
                        print("Error decoding JSON: \(error)")
                    }
                    
                case .failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
    }
}
