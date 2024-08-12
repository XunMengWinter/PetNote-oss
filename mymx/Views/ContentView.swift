//
//  ContentView.swift
//  mymx
//
//  Created by ice on 2024/6/17.
//

import SwiftUI
import NukeUI

enum Tab {
    case home
    case note
    case add
    case community
    case mine
}

struct ContentView: View {
    @EnvironmentObject var modelData: ModelData
    @Environment(NetworkMonitor.self) private var networkMonitor
    
    @StateObject private var photoVM = PhotographVM()
    @StateObject private var weatherVM = WeatherVM()
    @StateObject private var factsVM = FactsVM()
    @StateObject private var noteVM = NoteVM()
    @StateObject private var addNoteVM = AddNoteVM()
    @StateObject private var shopVM = ShopVM()
    
    @State private var isLoggedIn: Bool = false
    @State private var selection: Tab = .home
    @State private var showAddNote = false
    @State private var joinRanking = 0
    
    var body: some View {
        ZStack{
            Text("")
                .onChange(of: [networkMonitor.isConnected], {
                    print("network is connected: \(networkMonitor.isConnected)")
                    if(networkMonitor.isConnected){
                        factsVM.nextFact()
                        modelData.getPetList()

                        if(photoVM.photoList.isEmpty){
                            photoVM.fetchFirst()
                        }
                        if weatherVM.poetryWeathers.isEmpty{
                            weatherVM.fetchWeather(city: modelData.city)
                        }
                    }
                })
            
            TabView(selection: $selection, content: {
                CardHome(weatherVM: weatherVM, factsVM: factsVM, photoVM: photoVM)
                    .tag(Tab.home)
                NoteView(viewModel: noteVM)
                    .tag(Tab.note)
                EmptyView()
                    .tag(Tab.add)
                CommunityView(shopVM: shopVM)
                    .tag(Tab.community)
                MineView()
                    .tag(Tab.mine)
            })
            
            VStack{
                if addNoteVM.loading || addNoteVM.progress == 1 || !addNoteVM.errorMsg.isEmpty{
                    VStack{
                        HStack{
                            if(addNoteVM.imageList.count > 0){
                                Image(uiImage: addNoteVM.imageList[0])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 48, height: 48)
                                    .clipped()
                            }
                            if addNoteVM.progress == 1{
                                Text("发布成功！🎉 ")
                                Spacer()
                                Button("好的", action: {
                                    withAnimation{
                                        addNoteVM.cancel()
                                    }
                                    if(selection == .note){
                                        noteVM.getNoteList()
                                    }else{
                                        GlobalParams.updateNote = true
                                    }
                                })
                            }else if !addNoteVM.errorMsg.isEmpty{
                                Text(addNoteVM.errorMsg)
                                    .foregroundStyle(.red)
                                Spacer()
                                Button("取消", action: {
                                    withAnimation{
                                        addNoteVM.cancel()
                                    }
                                })
                                .padding(.trailing)
                                Button("重试", action: {
                                    showAddNote = true
                                })
                            } else {
                                Text(addNoteVM.imageList.count > 0 ? "图片上传中，请稍作等待..." : "动态发布中...")
                                Spacer()
                            }
                        }
                        .padding(.horizontal)
                        ProgressView(value: addNoteVM.progress)
                            .progressViewStyle(.linear)
                            .tint(Color(hex: "B4E380"))
                    }
                    .padding(.top)
                    .background(.regularMaterial)
                    .transition(.offset(x:0, y: -128))
                }
                
                if modelData.user == nil && selection != .home{
                    LoginView()
                        .onDisappear{
                            if(modelData.user != nil){
                                // 登录成功的逻辑
                                print("Login success")
                                if let rank = modelData.user?.joinRanking{
                                    self.joinRanking = rank
                                }
                                modelData.getPetList()
                                if(selection == .note){
                                    noteVM.getNoteList()
                                }
                            }
                        }
                }
                Spacer()
                MyTabView(active: $selection, showAddNote: $showAddNote)
                    .background(.white.opacity(0.0001))
                    .onTapGesture {
                        print("tap tab view")
                    }
            }
            .ignoresSafeArea(.keyboard)
            if joinRanking > 0 {
                JoinRankingView(joinRanking: $joinRanking)
                    .transition(.opacity)
            }
        }
        .fullScreenCover(isPresented: $showAddNote, content: {
            AddNoteView(showAddNote:$showAddNote, viewModel: addNoteVM)
        })
        .onAppear(perform: {
            print("ContentView onAppear")
            if(modelData.petList.isEmpty){
                modelData.getPetList()
            }
        })
    }
}

struct MyTabView: View {
    @EnvironmentObject var modelData: ModelData
    
    @Binding var active: Tab
    @Binding var showAddNote: Bool
    
    var body: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 5), spacing: 0) {
            Rectangle()
                .foregroundStyle(.white.opacity(0.0001))
                .overlay{
                    Text("首页")
                        .font(active == .home ? .title3 : .body)
                        .fontWeight(.black)
                        .foregroundStyle(active == .home ? .primary : .secondary)
                        .padding(.vertical, 4)
                }
                .onTapGesture {
                    withAnimation{
                        active = .home
                    }
                }
            Rectangle()
                .foregroundStyle(.white.opacity(0.0001))
                .overlay{
                    Text("爱宠说")
                        .font(active == .note ? .title3 : .body)
                        .fontWeight(.black)
                        .foregroundStyle(active == .note ? .primary : .secondary)
                        .padding(.vertical, 4)
                }
                .onTapGesture {
                    withAnimation{
                        active = .note
                    }
                }
            Rectangle()
                .foregroundStyle(.white.opacity(0.0001))
                .overlay{
                    Button(action: {
                        print("add Note")
                        if(modelData.user == nil){
                            withAnimation{
                                active = .note
                            }
                        }else{
                            self.showAddNote = true
                        }
                    }){
                        Image(systemName: "plus")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 20)
                            .padding(12)
                            .foregroundStyle(.white)
                            .bold()
                            .background(.button)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .shadow(color: Color(UIColor(white: 0.8, alpha: 0.8)), radius: 8, x: 0, y: 4)
                        
                    }
                }
                .frame(minHeight: 42)
                .onTapGesture {
                    
                }
            Rectangle()
                .foregroundStyle(.white.opacity(0.0001))
                .overlay{
                    Text("社区")
                        .font(active == .community ? .title3 : .body)
                        .fontWeight(.black)
                        .foregroundStyle(active == .community ? .primary : .secondary)
                        .padding(.vertical, 4)
                }
                .onTapGesture {
                    withAnimation{
                        active = .community
                    }
                }
            Rectangle()
                .foregroundStyle(.white.opacity(0.0001))
                .overlay{
                    Text("我")
                        .font(active == .mine ? .title3 : .body)
                        .fontWeight(.black)
                        .foregroundStyle(active == .mine ? .primary : .secondary)
                }
                .padding(.vertical, 4)
                .onTapGesture {
                    withAnimation{
                        active = .mine
                    }
                }
        }
    }
}


#Preview {
    let modelData = ModelData()
    return ContentView()
        .environmentObject(modelData)
        .environment(NetworkMonitor())
}
