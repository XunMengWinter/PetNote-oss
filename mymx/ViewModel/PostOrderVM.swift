//
//  PostOrderVM.swift
//  mymx
//
//  Created by ice on 2024/8/6.
//

import Foundation
import Alamofire

class PostOrderVM: ObservableObject{
    @Published var loading = false
    @Published var errorMsg = ""
    @Published var showAlert = false
    
    func showAlertMsg(_ msg : String){
        errorMsg = msg
        showAlert = true
    }
    
}
