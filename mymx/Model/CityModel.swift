//
//  CityModel.swift
//  mymx
//
//  Created by ice on 2024/6/24.
//

import Foundation

struct CityModel: Codable, Hashable, Identifiable{
    var id: String
    var city: String
    var cityCN: String
    var district: String
    var districtCN: String
    var adcode: String
    // 注意数据转换时别忘了这个
    var bgGroupName: String
    
    static let `default` = CityModel(id: "101210113", city: "Hangzhou", cityCN: "杭州市", district: "Xihu", districtCN: "西湖", adcode: "330106", bgGroupName: "")
    
    mutating func changeCityData(newCity: CityModel){
        self.id = newCity.id
        self.city = newCity.city
        self.cityCN = newCity.cityCN
        self.district = newCity.district
        self.districtCN = newCity.districtCN
        self.adcode = newCity.adcode
    }
    
    func equal(_ otherCity: CityModel) -> Bool{
        if self.id == otherCity.id &&
            self.city == otherCity.city &&
            self.district == otherCity.district &&
            self.bgGroupName == otherCity.bgGroupName{
            return true
        }
        return false
    }
}
