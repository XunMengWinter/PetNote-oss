//
//  NoteView.swift
//  mymx
//
//  Created by ice on 2024/7/6.
//

import SwiftUI

struct NoteView: View {
    @EnvironmentObject var modelData: ModelData
    @ObservedObject var viewModel: NoteVM
    @State private var showAddNote = false
    @State private var selectedPet = 0
    @State private var noteList: [NoteModel] = []
    let petAll = PetModel(id: 0, name: "全部")
    let screenWidth = UIScreen.main.bounds.size.width
    
    func filterNotes(){
        if selectedPet == petAll.id {
            self.noteList = viewModel.noteList
        }else{
            self.noteList = viewModel.noteList.filter({$0.pets.contains(selectedPet)})
        }
    }
    
    var body: some View {
        NavigationStack{
            
            ZStack{
                Text("")
                    .onChange(of: [viewModel.noteList], {
                        filterNotes()
                    })
                List{                    
                    ForEach($noteList) { $note in
                        NoteItem(note: note)
                    }.onDelete { offsets in
                        print("$noteList onDelete: \(offsets.startIndex)")
                        let deletedNote =  noteList[offsets.first!]
                        print(deletedNote)
                        noteList.remove(at: offsets.first!)
                        viewModel.deleteNote(note: deletedNote)
                    }
                }
                .listStyle(.plain)
                
                if(noteList.isEmpty){
                    VStack{
                        Image("bunny")
                        Text(modelData.petList.isEmpty ? "点击右上角  +  可以添加爱宠哈 😜" : "点击下方  +  可以发布爱宠说哈 😜")
                            .font(.title3)
                            .padding()
                    }
                }
            }
            .toolbar{
                ToolbarItemGroup(placement: .topBarLeading, content: {
                    HStack(alignment:.center ,spacing: 10){
                        Text(petAll.name)
                            .font(petAll.id == self.selectedPet ? .title2 : .subheadline)
                            .fontWeight(.medium)
                            .animation(.smooth)
                            .onTapGesture {
                                withAnimation(){
                                    self.selectedPet = petAll.id
                                    filterNotes()
                                }
                            }
                        ForEach(modelData.petList) { pet in
                            Text(pet.name)
                                .font(pet.id == self.selectedPet ? .title2 : .subheadline)
                                .fontWeight(.medium)
                                .animation(.smooth)
                                .onTapGesture {
                                    withAnimation(){
                                        self.selectedPet = pet.id
                                        filterNotes()
                                    }
                                }
                        }
                    } 
                    .padding(.horizontal)
                    .fixedSize(horizontal: true, vertical: false)
 
                })
                
                ToolbarItem(placement: .topBarTrailing, content: {
                    NavigationLink(destination: {
                        AddPetView()
                    }, label: {
                        Image(systemName: "plus.circle")
                    })
                })
            }
            .onAppear(perform: {
                print("NoteView onAppear")
                if(GlobalParams.updateNote || viewModel.noteList.isEmpty){
                    viewModel.getNoteList()
                    GlobalParams.updateNote = false
                }
                if(modelData.petList.isEmpty){
                    modelData.getPetList()
                }
            })
        }
    }
}

#Preview {
    let modelData = ModelData()
    return NoteView(viewModel: NoteVM())
        .environmentObject(modelData)
}
