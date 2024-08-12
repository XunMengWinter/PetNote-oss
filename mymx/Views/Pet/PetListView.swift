//
//  PetList.swift
//  mymx
//
//  Created by ice on 2024/7/14.
//

import SwiftUI
import NukeUI

struct PetListView: View {
    @EnvironmentObject var modelData: ModelData
    
    @StateObject private var viewModel = DeletePetVM()
    @State private var showDelete = false
    @State private var deletePet = PetModel()
    
    var body: some View {
            ScrollView{
                LazyVStack{
                    ForEach(modelData.petList){ pet in
                        HStack(spacing: 0){
                            LazyImage(url: URL(string: pet.avatar)){ state in
                                state.image?
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 100, height: 100)
                                    .clipShape(.rect(cornerRadius: 10))
                            }
                            .padding(.trailing)
                            VStack(alignment: .leading){
                                HStack{
                                    Text(pet.name)
                                        .font(.title)
                                        .foregroundStyle(.primary)
                                    
                                    Text(FamilyModel.getModel(pet.family).cn)
                                    
                                    Text(GenderModel.getModel(Gender(rawValue: pet.gender) ?? .unknown).cn)
                                }
                                Text(pet.birthDate, format: .dateTime.day().month().year())
                                Text(pet.description)
                            }
                            .foregroundStyle(.secondary)
                            Spacer(minLength: 0)
                            VStack(spacing: 16){
                                
                                Button(action: {
                                    deletePet = pet
                                    showDelete = true
                                }, label: {
                                    Label("删除", systemImage: "trash")
                                })
                                .foregroundStyle(.red)
                                .alert("是否删除 \(deletePet.name) ?", isPresented: $showDelete, actions: {
                                    Button("取消", role: .cancel, action: {
                                        self.deletePet = PetModel()
                                    })
                                    Button("删除", role: .destructive, action: {
                                        showDelete = false
                                        print("delete \(self.deletePet)")
                                        self.viewModel.deletePet(petId: self.deletePet.id)
                                        if let index = modelData.petList.firstIndex(of: deletePet){
                                            withAnimation{
                                                modelData.petList.remove(at: index)
                                            }
                                        }
                                        self.deletePet = PetModel()
                                    })
                                }, message: {
                                    Text("本操作仅删除  \(deletePet.name)（\(FamilyModel.getModel(deletePet.family).cn)），不会删除与\(deletePet.name)相关联的爱宠说。")
                                })
                                
                                NavigationLink(destination: EditPetView(petInfo: pet), label:{
                                    Label("编辑", systemImage: "pencil")
                                        .foregroundStyle(.blue)
                                })
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top)
                    }
                }
            }
            .onAppear(perform: modelData.getPetList)
    }
}

#Preview {
    PetListView()
        .environmentObject(ModelData())
}
