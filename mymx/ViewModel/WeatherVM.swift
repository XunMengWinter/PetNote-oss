//
//  WeatherViewModel.swift
//  mymx
//
//  Created by ice on 2024/6/21.
//

import Foundation
import Combine
import Alamofire

class WeatherVM: ObservableObject {
    
    @Published var poetryWeathers = [PoetryWeather]()
    @Published var error: AFError?
    
    func fetchWeather(city: CityModel) {
        print("fetchWeather: \(city)")
        // 使用 Alamofire 进行 GET 请求
        let parameters: [String: Any] = [
            "methodType": "getWeeks",
            "cityId": city.id,
            "bgGroupName": city.bgGroupName
        ]
        AF.request(Urls.POETRY_WAETHER, parameters: parameters)
            .validate()
            .responseDecodable(of: PoetryWeatherResult.self) { response in
//                print(response)
                switch response.result {
                case .success(let weatherResult):
                    // Handle the decoded object
                    self.poetryWeathers = weatherResult.poetryWeatherList
                    if let encoded = try? JSONEncoder().encode(self.poetryWeathers.first) {
                        UserDefaults.standard.set(encoded, forKey: DataKeys.LAST_POETRY_WEATHER)
                    }
                case .failure(let error):
                    // Handle any errors
                    self.error = error
                    print("Request failed with error: \(error)")
                }
                
            }
    }
    
}

