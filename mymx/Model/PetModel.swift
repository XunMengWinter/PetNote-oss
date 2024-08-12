//
//  PetModel.swift
//  mymx
//
//  Created by ice on 2024/7/6.
//

import Foundation
import UIKit

struct PetModel: Codable, Equatable, Identifiable{
    var id: Int = 0
    var name: String = ""
    var gender: String = Gender.unknown.rawValue
    var family: String = Family.cat.rawValue
    var birthTime: Int = 0
    var createTime: Int?
    var avatar: String = ""
    var description: String = ""
    
    // Computed property for birthDate
    var birthDate: Date {
        get {
            if birthTime == 0 {
                return Date()
            } else {
                return Date(timeIntervalSince1970: TimeInterval(birthTime))
            }
        }
        set {
            birthTime = Int(newValue.timeIntervalSince1970)
        }
    }
    
    var familyModel: FamilyModel {
        get{
            FamilyModel.getModel(family)
        }
        set {
            family = newValue.id.rawValue
        }
    }
    
}

struct GenderModel: Codable, Identifiable{
    let id: Gender
    let en: String
    let cn: String
    
    static func getModel(_ gender: Gender) -> GenderModel{
        switch gender{
        case .male:
            return GenderModel(id: gender, en: "male ♂", cn: "雄 ♂")
        case .female:
            return GenderModel(id: gender, en: "female ♀", cn: "雌 ♀")
        case .hermaphroditic:
            return GenderModel(id: gender, en: "hermaphroditic ⚥", cn: "雌雄同体 ⚥")
        case .unknown:
            return GenderModel(id: gender, en: "unknown", cn: "未知")
        }
    }
}

enum Gender: String, CaseIterable, Codable, Identifiable {
    case male
    case female
    case hermaphroditic
    case unknown
    var id: String { self.rawValue }
}

struct FamilyModel: Codable, Identifiable{
    let id: Family
    let en: String
    let cn: String
    let systemName: String
    
    static let `familyDict`: [Family: FamilyModel] = [
        .cat: FamilyModel(id: .cat, en: "Cat 🐱", cn: "猫 🐱", systemName: "cat"),
        .dog : FamilyModel(id: .dog, en: "Dog 🐶", cn: "狗 🐶", systemName: "dog"),
        .rabbit: FamilyModel(id: .rabbit, en: "Rabbit 🐰", cn: "兔 🐰", systemName: "hare"),
        .muridae: FamilyModel(id: .muridae, en: "Muridae 🐁", cn: "鼠 🐁", systemName: "photo.badge.plus"),
        .fish: FamilyModel(id: .fish, en: "Fish 🐟", cn: "鱼 🐟", systemName: "fish"),
        .bird: FamilyModel(id: .bird, en: "Bird 🐦", cn: "鸟 🐦", systemName: "bird"),
        .flower: FamilyModel(id: .bird, en: "Flower 🌷", cn: "花 🌷", systemName: "camera.macro"),
        .tree: FamilyModel(id: .bird, en: "Tree 🌲", cn: "树 🌲", systemName: "tree"),
        .car: FamilyModel(id: .car, en: "Car 🚗", cn: "车 🚗", systemName: "car"),
        .human: FamilyModel(id: .human, en: "Human 👶", cn: "人 👶", systemName: "photo.on.rectangle.angled"),
        .other: FamilyModel(id: .other, en: "Other", cn: "其他", systemName: "photo.badge.plus"),
    ]
    
    static func getModel(_ family: Family) -> FamilyModel{
        FamilyModel.familyDict[family] ?? FamilyModel(id: family, en: family.rawValue, cn: family.rawValue, systemName: "photo.badge.plus")
    }
    
    static func getModel(_ family: String) -> FamilyModel{
        let familyEnum = Family(rawValue: family)!
        return FamilyModel.familyDict[familyEnum] ?? FamilyModel(id: familyEnum, en: family, cn: family, systemName: "photo.badge.plus")
    }
}

enum Family: String, CaseIterable, Codable, Identifiable {
    case cat
    case dog
    case rabbit
    case muridae
    case fish
    case bird
    case flower
    case tree
    case car
    case human
    case other
    var id: String { self.rawValue }
}
