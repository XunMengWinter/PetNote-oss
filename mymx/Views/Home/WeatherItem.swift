//
//  WeatherItem.swift
//  mymx
//
//  Created by ice on 2024/6/21.
//

import SwiftUI
import UIKit
import NukeUI

struct WeatherItem: View {
    @EnvironmentObject var modelData: ModelData
    
    var poetryWeather: PoetryWeather
    let screenWidth = UIScreen.main.bounds.size.width
    
    var body: some View {
        GeometryReader{ geo in
            let imageUrl = poetryWeather.bgImage
            LazyImage(url: URL(string: imageUrl)){ image in
                image.image?
                    .resizable()
                    .scaledToFill()
            }
            .overlay{
                TextOverlay(poetryWeather: poetryWeather)
                    .frame(width:geo.size.width, height: 220)
            }
            .frame(width:geo.size.width, height: 220)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }
}

struct TextOverlay: View{
    @EnvironmentObject var modelData: ModelData
    
    var poetryWeather: PoetryWeather
    @State private var showCityPicker = false
    @State private var city = CityModel.default
    @State private var loading = false
    @State private var showBgPicker = false
    
    var body: some View{
        HStack {
            VStack(alignment: .leading){
                Spacer()
                Text(poetryWeather.weather.dateStr)
                    .font(.title)
                    .bold()
                    .padding(.bottom, 20)
                Spacer()
                Text("\(poetryWeather.weather.textDay)  \(poetryWeather.weather.dayEmoji)")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 4)
                
                Text("\(poetryWeather.weather.tempMax)°  /   \(poetryWeather.weather.tempMin)°")
                    .font(.title3)
                    .bold()
                    .padding(.bottom, 8)
                HStack{
                    Image(systemName: "location.fill")
                        .frame(width: 10, height: 10)
                        .scaleEffect(0.8)
                    Text(city.city)
                        .font(.subheadline)
                        .bold()
                        .padding(.trailing, 6)
                    if(loading){
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: Color.white))
                    }
                }
                .onTapGesture{
                    showCityPicker.toggle()
                    print("tap city")
                }
                .sheet(isPresented: $showCityPicker,onDismiss: {
                    print(city)
                    // TODO: 更改天气城市
                    if(!modelData.city.equal(city)){
                        loading = true
                        if let encoded = try? JSONEncoder().encode(city) {
                            UserDefaults.standard.set(encoded, forKey: DataKeys.WEATHER_CITY)
                        }
                        modelData.lastPoetryWeather = poetryWeather
                        modelData.city = city
                    }
                },content: {
                    CityPicker(showCityPicker: $showCityPicker, city: $city)
                })
                
                Spacer()
            }
            .onTapGesture {
                print("tap Weather")
            }
            
            Spacer()
            let poes = poetryWeather.poem.replacingOccurrences(of: "\n", with: " ").split(separator: " ")
            let reversePoe = poes.reversed()
            
            HStack(alignment:.top){
                ForEach(reversePoe ,id: \.self){ poe in
                    let chars = Array(poe)
                    VStack(){
                        ForEach(chars.indices, id: \.self){ index in
                            Text(String(chars[index]))
                                .font(.headline)
                        }
                    }
                }
            }
            .onTapGesture {
                print("tap poetry: \(poes)")
            }
        }.foregroundColor(.white)
            .padding(.leading, 20)
            .padding(.trailing, 20)
            .background(.black.opacity(0.1))
            .onAppear(perform: {
                city = modelData.city
                if(modelData.lastPoetryWeather != nil){
                    loading = true
                }
            })
            .onTapGesture {
                print("tap card")
                showBgPicker.toggle()
            }
            .sheet(isPresented: $showBgPicker,onDismiss: {
                print(city)
                // TODO: 更改背景组
                if(!modelData.city.equal(city)){
                    loading = true
                    if let encoded = try? JSONEncoder().encode(city) {
                        UserDefaults.standard.set(encoded, forKey: DataKeys.WEATHER_CITY)
                    }
                    modelData.lastPoetryWeather = poetryWeather
                    modelData.city = city
                }
            },content: {
                WeatherBgPicker(showBgPicker: $showBgPicker, city: $city)
            })
    }
}

#Preview {
    WeatherItem(poetryWeather: MockData().poetryWeatherResult.poetryWeatherList[6])
        .environmentObject(ModelData())
}
