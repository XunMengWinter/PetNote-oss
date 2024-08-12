// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let weatherResult = try? JSONDecoder().decode(WeatherResult.self, from: jsonData)

import Foundation

// MARK: - WeatherResult
struct FactModel: Codable {
    let translate: [Translate]
    let length: Int
    let fact: String
    let source: String?
}

// MARK: - Translate
struct Translate: Codable {
    let dst, src: String
}
