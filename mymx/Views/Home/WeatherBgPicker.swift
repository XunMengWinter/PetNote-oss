//
//  WeatherBgPicker.swift
//  mymx
//
//  Created by ice on 2024/6/25.
//

import SwiftUI
import NukeUI

struct WeatherBgPicker: View {
    @StateObject var viewModel = WeatherBgPickerVM()
    @Binding var showBgPicker: Bool
    @Binding var city: CityModel
    
    var body: some View {
        ScrollView(.vertical) {
            Text("选择卡片背景")
                .font(.title2)
                .padding()
            // Access the decoded images dictionary
            Text("当前为 \(city.bgGroupName) 系列")
                .padding(.bottom)
            
            ForEach(viewModel.imagesKeys, id: \.self, content: {key in
                VStack{
                    Text("\(key)")
                        .font(.headline)
                    
                    ScrollView(.horizontal){
                        HStack{
                            ForEach(viewModel.bgImageDict[key] ?? [], id: \.self, content: {imageUrl in
                                LazyImage(url: URL(string: imageUrl)){ image in
                                    image.image?
                                        .resizable()
                                        .scaledToFit()
                                }
                                .frame(height: 180)
                                
                            })
                        }
                    }
                    .padding(.bottom)
                }
                .onTapGesture {
                    print("Tap \(key)")
                    city.bgGroupName = key
                    showBgPicker.toggle()
                }
            })
        }
        .onAppear(perform: {
            viewModel.fetchImageDict()
        })
        .foregroundStyle(.foreground)
    }
}

#Preview {
    WeatherBgPicker(showBgPicker: .constant(true), city: .constant(ModelData().city))
}
