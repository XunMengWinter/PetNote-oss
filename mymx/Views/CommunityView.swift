//
//  CommunityView.swift
//  mymx
//
//  Created by ice on 2024/7/23.
//

import SwiftUI

struct CommunityView: View {
    @ObservedObject var shopVM: ShopVM
    
//    let screenWidth = UIScreen.main.bounds.size.width
    var body: some View {
        NavigationStack{
            GeometryReader { geometry in
                let screenWidth = geometry.size.width
                LazyHGrid(rows: Array(repeating: GridItem(.flexible(), spacing: 0), count: 3), spacing: 0){
                    
                    NavigationLink(destination: LibraryView()){
                        Rectangle()
                            .foregroundStyle(Color("libraryColor"))
                            .frame(width: screenWidth)
                            .overlay(content: {
                                HStack{
                                    Image("library")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 128, height: 128)
                                        .padding(.leading, 64)
                                    Text("图书馆")
                                        .font(.largeTitle)
                                        .padding()
                                    Spacer(minLength: 0)
                                }
                            })
                    }
                    
                    NavigationLink(destination: ShopView(viewModel: shopVM)){
                        Rectangle()
                            .foregroundStyle(Color("shopColor"))
                            .frame(width: screenWidth)
                            .overlay(content: {
                                HStack{
                                    Image("shops")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 128, height: 128)
                                        .padding(.leading, 64)
                                    Text("猫寻小店")
                                        .font(.largeTitle)
                                        .padding()
                                    Spacer(minLength: 0)
                                }
                            })
                    }
                    
                    NavigationLink(destination: ForumView()){
                        Rectangle()
                            .foregroundStyle(Color("forumColor"))
                            .frame(width: screenWidth)
                            .overlay(content: {
                                HStack{
                                    Image("zoo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 128, height: 128)
                                        .padding(.leading, 64)
                                    Text("爱宠圈")
                                        .font(.largeTitle)
                                        .padding()
                                    Spacer(minLength: 0)
                                }
                            })
                    }
                }
                .frame(maxWidth: .infinity)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .topBarLeading) {
                    Text("社区")
                        .font(.title)
                        .bold()
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                    } label: {
                        Label("Message", systemImage: "message")
                    }
                }
            }
            .toolbarBackground(Color("communityColor"), for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .ignoresSafeArea(.keyboard)
        }

    }
}

#Preview {
    CommunityView(shopVM: ShopVM())
}
