//
//  CardHome.swift
//  mymx
//
//  Created by ice on 2024/6/17.
//

import SwiftUI
import Alamofire

struct CardHome: View{
    @EnvironmentObject var modelData: ModelData
    
    @ObservedObject var weatherVM: WeatherVM
    @ObservedObject var factsVM: FactsVM
    @ObservedObject var photoVM: PhotographVM
    
    @State private var loading = false
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    if(weatherVM.poetryWeathers.count > 0){
                        WeatherPageView(pages: weatherVM.poetryWeathers.map({
                            WeatherItem(poetryWeather: $0)
                                .padding()
                        }))
                        .onAppear(perform: {modelData.lastPoetryWeather = nil})
                        .zIndex(20)
                    } else if ((modelData.lastPoetryWeather) != nil){
                        WeatherPageView(pages: [WeatherItem(poetryWeather: modelData.lastPoetryWeather!)
                            .padding()]
                        )
                        .zIndex(20)
                    }
                    
                    Text("")
                        .onChange(of: [modelData.city.id, modelData.city.bgGroupName], {
                            print("HHHH")
                            weatherVM.poetryWeathers.removeAll()
                            weatherVM.fetchWeather(city: modelData.city)
                        })
                        .frame(width: 0, height: 0)
                    if let factModel = factsVM.factModel {
                        ZStack(alignment: .bottomLeading){
                            Color("homeFactBg")
                                .clipShape(RoundedRectangle(cornerRadius: 16))
                            Text(factModel.translate[0].dst)
                                .padding(10)
                                .lineLimit(/*@START_MENU_TOKEN@*/2/*@END_MENU_TOKEN@*/)
                            HStack{
                                Spacer()
                                
                                NavigationLink {
                                    FactsView(factsVM: factsVM)
                                } label:{
                                    Text("猫咪趣闻")
                                        .padding(.leading, 10)
                                        .foregroundColor(.button2)
                                        .background(Color("homeFactBg"))
                                        .padding(10)
                                        .opacity(0.9)
                                }
                            }
                        }
                        .padding(.leading)
                        .padding(.trailing)
                    }
                    
                    LazyVStack{
                        ForEach(photoVM.photoList, id: \.id, content: {photo in
                            PhotoItem(photo: photo)
                                .onAppear(perform: {
                                    if(photo == photoVM.photoList.last){
                                        loading = true
                                        photoVM.fetchMore()
                                    }
                                })
                                .zIndex(15)
                        })
                    }
                    if(loading){
                        ProgressView()
                            .padding(.bottom)
                    }
                }
            }.onAppear {
                if(weatherVM.poetryWeathers.isEmpty){
                    weatherVM.fetchWeather(city: modelData.city)
                }
                if(photoVM.photoList.isEmpty){
                    photoVM.fetchFirst()
                }
                if(factsVM.factList.isEmpty){
                    factsVM.nextFact()
                }
                factsVM.nextFact()
            }
        }
    }
}

#Preview {
    CardHome(weatherVM: WeatherVM(), factsVM: FactsVM(),  photoVM: PhotographVM())
        .environmentObject(ModelData())
}
