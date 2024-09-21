//
//  Constants.swift
//  mymx
//
//  Created by ice on 2024/7/8.
//

import Foundation
class GlobalParams{
    static var token = ""
    // 有效期时间戳
    static var tokenExpires = 0
    
    static var updateNote = false
    
    static func logout(){
        GlobalParams.token = ""
        GlobalParams.tokenExpires = 0
        GlobalParams.updateNote = true
    }
    
    static var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yMMMd", options: 0, locale: Locale.current)
        return formatter
    }
    
    static var shopOpenTime = "周二至周日 13:00~22:00"
}
