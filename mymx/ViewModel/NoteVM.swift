//
//  NoteVM.swift
//  mymx
//
//  Created by ice on 2024/7/13.
//

import Foundation
import Alamofire

@MainActor
class NoteVM: ObservableObject{
    @Published var petError: AFError?
    @Published var noteList: [NoteModel] = []
    @Published var noteError: AFError?
    @Published var loading = false
  
    func getNoteList(){
        print("getNoteList")
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        AF.request(Urls.GET_NOTE_LIST, headers: headers)
            .validate()
            .responseDecodable(of: BaseResult<[NoteModel]>.self) {response in
                switch response.result{
                case .success(let res):
                    if let notes = res.data{
                        self.noteList = notes
                        return
                    }
                case .failure(let error):
                    print(error)
                }
                // 错误在这里
                self.noteList = []
            }
    }
    
    func deleteNote(note: NoteModel){
        noteList.removeAll(where: {$0 == note})
        let noteId = note.id
        print("deleteNode")
        let headers: HTTPHeaders = [
            "Authentication": "Bearer " + GlobalParams.token
        ]
        let parameters: [String: Any] = [
            "noteId": noteId
        ]
        AF.request(Urls.DELETE_NOTE, method: .post, parameters: parameters, headers: headers)
            .validate()
            .responseDecodable(of: BaseResult<Bool>.self) {response in
                switch response.result{
                case .success(let res):
                    print(res)
                    if(res.data!){
                        print("delete note succeed: \(noteId)")
                    }
                case .failure(let error):
                    print(error)
                }
                // 错误在这里
            }
    }
}
