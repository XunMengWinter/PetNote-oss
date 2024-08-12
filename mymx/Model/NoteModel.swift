//
//  NoteModel.swift
//  mymx
//
//  Created by ice on 2024/7/6.
//

import Foundation

struct NoteModel: Codable, Equatable, Identifiable{
    var id: Int = 0
    var content: String = ""
    var type = 0
    var images: [String] = []
    var pets: [Int] = []
    var createTime: Int?
    var noteTime = 0
    
    // Computed property for birthDate
    var noteDate: Date {
        get {
            if noteTime == 0 {
                return Date()
            } else {
                return Date(timeIntervalSince1970: TimeInterval(noteTime))
            }
        }
        set {
            noteTime = Int(newValue.timeIntervalSince1970)
        }
    }
    
    func toDict() -> [String: Any]{
        let petDict: [String: Any] = [
            "content": content,
            "type": type,
            "images": images,
            "pets": pets,
            "noteTime": noteTime,
        ]
        return petDict
    }
    
    func getPets(allPets: [PetModel]) -> [PetModel]{
        var petModels:[PetModel] = []
        pets.forEach({petId in
            for petModel in allPets{
                if(petModel.id == petId){
                    petModels.append(petModel)
                    break
                }
            }
        })
        return petModels
    }
}
