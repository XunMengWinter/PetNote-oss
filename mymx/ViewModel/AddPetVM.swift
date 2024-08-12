//
//  AddPetVM.swift
//  mymx
//
//  Created by ice on 2024/7/8.
//

import Foundation
import Combine
import Alamofire
import UIKit

class AddPetVM: ObservableObject {
    private var isUpdate = false
    @Published var error: AFError?
    @Published var errorMsg = ""
    @Published var loading = false
    @Published var pet = PetModel()
    @Published var success = false
    
    init(isUpdate: Bool){
        self.isUpdate = isUpdate
    }
    
    func updatePet(pet: PetModel, image: UIImage?){
        errorMsg = ""
        if pet.name.isEmpty {
            errorMsg = "请输入爱宠的昵称～"
            return
        }
        if !isUpdate && image == nil {
            errorMsg = "请为爱宠挑选头像～"
            return
        }
        if pet.description.count < 5 {
            errorMsg = "描述需多于 5 字～"
            return
        }
        
        print("addPet: \(pet)")
        self.loading = true
        self.pet = pet
        if let img = image{
            self.getStsTokenThenUploadImage(image: img)
        }else{
            addPetToServer()
        }
    }
    
    private func addPetToServer(){
        print("addPetToServer")
        print("is update: \(isUpdate)")
        pet.birthTime = Int(pet.birthDate.timeIntervalSince1970)
        // 使用 Alamofire 进行 GET 请求
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        AF.request(self.isUpdate ? Urls.UPDATE_PET : Urls.ADD_PET, method: .post, parameters: ["pet": pet], encoder: JSONParameterEncoder.default, headers: headers)
            .validate()
            .responseDecodable(of: BaseResult<PetModel>.self) { response in
                print(response)
                self.loading = false
                switch response.result {
                case .success(let res):
                    // Handle the decoded object
                    if  let pet = res.data {
                        self.pet = pet
                        print(pet)
                        self.success = true
                    }else{
                        self.errorMsg = res.error ?? ""
                    }
                case .failure(let error):
                    // Handle any errors
                    self.error = error
                    self.errorMsg = error.errorDescription ?? "提交遇到了一点小问题，请重试。"
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    private func uploadImage(tokenData: StsModel, image: UIImage){
        let resizedImage = image.aspectFittedToHeight(1024)
        let imageData = resizedImage.jpegData(compressionQuality: 0.5)!

        print("\(image) size: \(imageData.count)")

        let headers: HTTPHeaders = [
            "Content-Type": "multipart/form-data",
        ]
        
        let imageName="\(Int(Date().timeIntervalSince1970)).jpg"
        AF.upload(multipartFormData: { multipartFormData in
            //            multipartFormData.append("200".data(using: .utf8)!, withName: "success_action_status")  // 默认返回204
            multipartFormData.append(tokenData.policy.data(using: .utf8)!, withName: "policy")
            multipartFormData.append(tokenData.signature.data(using: .utf8)!, withName: "signature")
            multipartFormData.append(tokenData.accessid.data(using: .utf8)!, withName: "OSSAccessKeyId")
            multipartFormData.append(tokenData.stsToken.data(using: .utf8)!, withName: "x-oss-security-token")
            multipartFormData.append("\(tokenData.dir)\(imageName)".data(using: .utf8)!, withName: "key")
            multipartFormData.append(imageData, withName: "file",fileName: imageName, mimeType: "image/jpeg")
        }, to: tokenData.host, method: .post, headers: headers)
        .uploadProgress { progress in
            print("Upload Progress: \(progress.fractionCompleted)")
        }
        .responseString(emptyResponseCodes: [204], completionHandler: {response in
            switch(response.result){
            case .success(let res):
                if(res.isEmpty){
                    // 上传成功返回空
                    print("uploadImage success!")
                    // imageUrl
                    let imageUrl = tokenData.host + "/" + tokenData.dir + imageName
                    self.pet.avatar = imageUrl
                    self.addPetToServer()
                    return
                }
                self.errorMsg = "图片上传失败"
                print("uploadImage res: \(res)")
            case .failure(let error):
                print(error)
                self.errorMsg = error.errorDescription ?? "图片上传失败"
                print("uploadImage error: \(error)")
            }
            self.loading = false
        })
    }
    
    private func getStsTokenThenUploadImage(image: UIImage) {
        print("getStsTokenThenUploadImage")
        // 使用 Alamofire 进行 GET 请求
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        AF.request(Urls.STS_PET_AVATAR, headers: headers)
            .validate()
            .responseDecodable(of: StsResult.self) { response in
                print(response)
                switch response.result {
                case .success(let res):
                    // Handle the decoded object
                    if let sts = res.sts {
                        self.uploadImage(tokenData: sts, image: image)
                    }else{
                        self.loading = false
                        self.errorMsg = "STS获取失败"
                    }
                case .failure(let error):
                    // Handle any errors
                    self.error = error
                    self.errorMsg = error.errorDescription ?? "STS获取失败"
                    print("Request failed with error: \(error)")
                    self.loading = false
                }
            }
    }
    
}


