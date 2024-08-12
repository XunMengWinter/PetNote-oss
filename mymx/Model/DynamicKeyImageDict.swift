import Foundation

struct DynamicKeyImagesDict: Codable {
    let bgImageDict: [String: [String]]  // Assuming bgImageDict contains dynamic keys and arrays of strings
    
    private enum CodingKeys: String, CodingKey {
        case bgImageDict
    }
}
