//
//  ModelData.swift
//  mymx
//
//  Created by ice on 2024/6/24.
//

import Foundation
import Alamofire
import WidgetKit

//@Observable
class ModelData: ObservableObject{
    
    @Published var city: CityModel = CityModel.default
    var lastPoetryWeather: PoetryWeather?
    @Published var user: UserModel?
    @Published var petList: [PetModel] = []
    @Published var updatePetList = false
    
    init(){
        if let cityData = UserDefaults.standard.data(forKey: DataKeys.WEATHER_CITY) {
            if let cityModel = try? JSONDecoder().decode(CityModel.self, from: cityData) {
                self.city = cityModel
            }
        }
        
        if let lastPoetryWeatherData = UserDefaults.standard.data(forKey: DataKeys.LAST_POETRY_WEATHER) {
            if let poetryWeather = try? JSONDecoder().decode(PoetryWeather.self, from: lastPoetryWeatherData) {
                self.lastPoetryWeather = poetryWeather
            }
        }
        
        if let loginData = UserDefaults.standard.data(forKey: DataKeys.LOGIN_RESULT) {
            if let loginResult = try? JSONDecoder().decode(LoginResult.self, from: loginData) {
                // 校验token是否过期
                let expires = loginResult.tokenExpires
                let timestampAfter6h = Int(Date().timeIntervalSince1970) +  6 * 60 * 60
                print(timestampAfter6h)
                if(timestampAfter6h < expires){
                    self.user = loginResult.user
                    GlobalParams.token = loginResult.token
                    GlobalParams.tokenExpires = loginResult.tokenExpires
                    shareTokenToGroup(loginResult.token)
                }
            }
        }
    }
    
    private func shareTokenToGroup(_ token: String){
        if let sharedDefaults = UserDefaults(suiteName: "group.pet.zzz.loveoss") {
            sharedDefaults.setValue(token, forKey: "token")
            print("share token" )
        }
    }
    
    func saveLoginData(res: LoginResult){
        self.user = res.user
        shareTokenToGroup(res.token)
        if let encoded = try? JSONEncoder().encode(res) {
            UserDefaults.standard.set(encoded, forKey: DataKeys.LOGIN_RESULT)
        }
        if let encoded = try? JSONEncoder().encode(res.user?.mail) {
            UserDefaults.standard.set(encoded, forKey: DataKeys.LAST_LOGIN_MAIL)
        }
    }
    
    func getPetList(){
        print("getPetList")
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        AF.request(Urls.GET_PET_LIST, headers: headers)
            .validate()
            .responseDecodable(of: BaseResult<[PetModel]>.self) {response in
                switch response.result{
                case .success(let res):
                    if let pets = res.data{
                        self.petList = pets
                        WidgetCenter.shared.reloadAllTimelines()
                        return
                    }
                case .failure(let error):
                    print(error)
                }
                // 错误在这里
                self.petList = []
            }
    }
  
    
}


