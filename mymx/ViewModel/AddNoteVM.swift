//
//  AddNoteVM.swift
//  mymx
//
//  Created by ice on 2024/7/16.
//

import Foundation
import UIKit
import Alamofire

@MainActor
class AddNoteVM: ObservableObject{
    @Published var note = NoteModel()
    private var error: AFError?
    @Published var errorMsg = ""
    
    @Published var imageList: [UIImage] = []
    @Published var loading = false
    @Published var progress = 0.0
    
    private var imageUrlDict: [UIImage: String] = [:]
    
    func publishNote(petIds:[Int]){
        cancel()
        note.pets = petIds
        print(note)
        loading = true
        if imageList.count > 0{
            getStsTokenThenUploadImages()
        }else{
            uploadNote()
        }
    }
    
    private func uploadNote(){
        print("uploadNote")
        self.progress = 0.9
        note.noteTime = Int(note.noteDate.timeIntervalSince1970)
        let parameters: [String: Any] = [
            "note": self.note.toDict()
        ]
        print(parameters)
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        AF.request(Urls.ADD_NOTE, method: .post, parameters: parameters,encoding: JSONEncoding.default, headers: headers)
            .validate()
            .responseDecodable(of: BaseResult<NoteModel>.self) { response in
                print(response)
                self.loading = false
                switch response.result {
                case .success(let res):
                    // Handle the decoded object
                    if  let note = res.data {
                        self.note = note
                        print(note)
                        self.progress = 1.0
                        self.clear()
                    }else{
                        self.errorMsg = res.error ?? "发布遇到了一点小问题，请重试。"
                    }
                case .failure(let error):
                    // Handle any errors
                    self.error = error
                    self.errorMsg = error.errorDescription ?? "发布遇到了一点小问题，请重试。"
                    print("Request failed with error: \(error)")
                }
            }
    }
    
    func cancel(){
        progress = 0.0
        error = nil
        errorMsg = ""
        loading = false
    }
    
    // 重置数据
    private func clear(){
        note = NoteModel()
        error = nil
        errorMsg = ""
        imageList = []
        loading = false
        imageUrlDict = [:]
    }
    
    
    private func uploadImages(tokenData: StsModel, completion: @escaping ([String]) -> Void){
        let dispatchGroup = DispatchGroup()
        var index = 0
        let timeStamp = Int(Date().timeIntervalSince1970)
        var imageUrls: [String] = []
        for image in imageList{
            let imageIndex = index
            index += 1
            imageUrls.append("")
            if let url = imageUrlDict[image]{
                print("Image \(imageIndex) has uploaded: \(url)")
                continue
            }
            dispatchGroup.enter()
            let resizedImage = image.aspectFittedToHeight(1440) // 1440 ->   1440 * 3 = 
            let imageData = resizedImage.jpegData(compressionQuality: 0.3)!
            print("\(image) size: \(imageData.count)")
            // upload imageData
            
            let headers: HTTPHeaders = [
                "Content-Type": "multipart/form-data",
            ]
            
            let imageName="\(timeStamp)_\(imageIndex).jpg"
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
                if(self.imageList.count == 1){
                    self.progress = 0.1 + progress.fractionCompleted * 0.8
                }
            }
            .responseString(emptyResponseCodes: [204], completionHandler: {response in
                switch(response.result){
                case .success(let res):
                    if(res.isEmpty){
                        // 上传成功返回空
                        print("uploadImage success! \(imageIndex)")
                        // imageUrl
                        let imageUrl = tokenData.host + "/" + tokenData.dir + imageName
                        imageUrls[imageIndex] = imageUrl
                        self.imageUrlDict[image] = imageUrl
                        if(self.imageList.count > 1){
                            self.progress += (0.8 / Double(self.imageList.count))
                        }
                    }
                    print("uploadImage res: \(res)")
                case .failure(let error):
                    print(error)
                    print("uploadImage error: \(error)")
                }
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main) {
            completion(imageUrls)
        }
    }
    
    private func getStsTokenThenUploadImages() {
        print("getStsTokenThenUploadImage")
        // 使用 Alamofire 进行 GET 请求
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        AF.request(Urls.STS_PET_NOTE, headers: headers)
            .validate()
            .responseDecodable(of: StsResult.self) { response in
                print(response)
                switch response.result {
                case .success(let res):
                    // Handle the decoded object
                    if let sts = res.sts {
                        self.progress = 0.1
                        self.uploadImages(tokenData: sts) { imageUrls in
                            print("Uploaded image URLs: \(imageUrls)")
                            // Use the imageUrls as needed
                            var allImageUrls: [String] = []
                            for image in self.imageList{
                                if let imageUrl = self.imageUrlDict[image]{
                                    allImageUrls.append(imageUrl)
                                } else {
                                    print("\(image) upload fail.")
                                    self.loading = false
                                    self.errorMsg = "图片上传失败，请重试"
                                    return
                                }
                            }
                            self.note.images = allImageUrls
                            self.uploadNote()
                            return
                        }
                    }else{
                        self.loading = false
                        self.errorMsg = "登录信息已过期，请重新登录"
                    }
                case .failure(let error):
                    // Handle any errors
                    self.error = error
                    print("Request failed with error: \(error)")
                    self.loading = false
                    self.errorMsg = error.errorDescription ?? "获取STS失败"
                }
            }
    }
    
    
}
