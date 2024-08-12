//
//  DeletePetVM.swift
//  mymx
//
//  Created by ice on 2024/8/3.
//

import Foundation
import Alamofire

class DeletePetVM: ObservableObject{

    func deletePet(petId: Int){
        print("deletePet")
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        let parameters: [String: Any] = [
            "petId": petId
        ]
        AF.request(Urls.DELETE_PET, method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: BaseResult<Bool>.self) {response in
                switch response.result{
                case .success(let res):
                    print(res)
                    if(res.data!){
                        print("delete pet succeed: \(petId)")
                    }
                case .failure(let error):
                    print(error)
                }
                // 错误在这里
            }
    }
    
}
