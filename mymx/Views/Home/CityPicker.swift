//
//  CityPicker.swift
//  mymx
//
//  Created by ice on 2024/6/23.
//

import SwiftUI
import NukeUI

struct CityPicker: View {
    @StateObject var viewModel = CityPickerVM()
    @State private var searchText: String = ""
    @Binding var showCityPicker: Bool
    @Binding var city: CityModel
    
    
    var body: some View {
        VStack {
            Text("选择城市")
                .font(.title2)
                .padding(.top)
            TextField("输入城市名称，比如 杭州 或 Hangzhou", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("您也可以输入城市区域，比如 西湖")
                .font(.subheadline)
            
            List(viewModel.cityRows, id: \.self) { item in
                Text(viewModel.displayCityRow(cityRow: item))
                    .onTapGesture(perform: {
                        city.changeCityData(newCity: viewModel.getCityModel(cityRow: item))
                        showCityPicker.toggle()
                    })
            }
            .listStyle(GroupedListStyle())
        }
        .onChange(of: searchText, {
            if searchText.isEmpty {
                viewModel.cityRows = []
            } else {
                viewModel.searchRowInCSV(fileName: "China-City-List-latest", searchTerm: searchText)
            }
        })
        .foregroundStyle(.foreground)
    }
}

#Preview {
    CityPicker(showCityPicker: .constant(true),
               city: .constant(ModelData().city))
}
