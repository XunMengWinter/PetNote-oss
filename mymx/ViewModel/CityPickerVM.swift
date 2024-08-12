//
//  CityPickerVM.swift
//  mymx
//
//  Created by ice on 2024/6/23.
//

import Foundation

class CityPickerVM: ObservableObject {
    @Published var cityRows: [String] = []
    
    func searchRowInCSV(fileName: String, searchTerm: String) {
        guard let csvURL = Bundle.main.url(forResource: fileName, withExtension: "csv") else {
            print("CSV file not found")
            return
        }
        
        do {
            let csvData = try String(contentsOf: csvURL)
            let rows = csvData.components(separatedBy: "\n")
            self.cityRows.removeAll()
            for row in rows {
                let columns = row.components(separatedBy: ",")
                if columns.contains(searchTerm) {
                    self.cityRows.append(row)
//                    print("Found row: \(row)")
                }
            }
            
//            print("Row not found for search term: \(searchTerm)")
        } catch {
            print("Error reading CSV file:", error.localizedDescription)
        }
    }
    
    func displayCityRow(cityRow: String) -> String{
        let str = cityRow.replacingOccurrences(of: ", ", with: " - ")
        let sps = str.split(separator: ",")
        let text = sps[1] + sps[2] + ", " + sps[6] + sps[7] + ", " + sps[8] + sps[9]
        return text
    }
    
    func getCityModel(cityRow: String) -> CityModel{
        let str = cityRow.replacingOccurrences(of: ", ", with: " - ")
        let sps = str.split(separator: ",")
        return CityModel(id: String(sps[0]), city: String(sps[8]), cityCN: String(sps[9]), district: String(sps[1]), districtCN: String(sps[2]), adcode: String(sps[13].trimmingCharacters(in: .whitespacesAndNewlines)), bgGroupName: ""
)
    }
}
