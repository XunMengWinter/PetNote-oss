//
//  AddNoteView.swift
//  mymx
//
//  Created by ice on 2024/7/12.
//

import SwiftUI
import NukeUI
import PhotosUI

struct AddNoteView: View {
    static private var MAX_IMAGE_COUNT = 20
    
    @EnvironmentObject var modelData: ModelData

    @Binding var showAddNote : Bool
    @ObservedObject var viewModel: AddNoteVM
    
    @State private var photoList: [PhotosPickerItem] = []
    
    @State private var isAllSelected = false
    @State private var selectedPets: [Int] = []
    @State private var showBigImage = false
    @State private var imageIndex = 0
    @FocusState private var focusedField: Bool
    
    var dateRange: ClosedRange<Date>{
        let min = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))!
        let max = Date()
        return min...max
    }
    
    var body: some View {
        VStack{
            HStack{
                Button(action: {
                    withAnimation(){
                        self.showAddNote = false
                    }
                }, label: {
                    Text(viewModel.loading ? "返回" : "取消")
                })
                Spacer()
                if viewModel.loading{
                    ProgressView("发布中，请稍候")
                }else{
                    Button(action: {
                        viewModel.publishNote(petIds: selectedPets)
                        withAnimation(){
                            self.showAddNote = false
                        }
                    }, label: {
                        Text("发布")
                            .bold()
                            .foregroundStyle(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(.button)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    })
                }
            }
            .padding(.horizontal)
            
            ScrollView{
                TextField("说点什么吧～", text: $viewModel.note.content, axis: .vertical)
                    .frame(minHeight: 48)
                    .font(.title3)
                    .padding()
                    .padding(.horizontal)
                    .submitLabel(.return)
                    .focused($focusedField)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 15) {
                        ForEach(viewModel.imageList.indices, id: \.self) { index in
                            ZStack(alignment: .topLeading){
                                Image(uiImage: viewModel.imageList[index])
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 120, height: 120)
                                    .background(.homeFactBg)
                                    .onTapGesture {
                                        imageIndex = index
                                        showBigImage = true
                                    }
                                Text("\(index + 1)")
                                    .font(.footnote)
                                    .foregroundStyle(.white)
                                    .frame(width: 20, height: 20)
                                    .background(Color.black.opacity(0.7))
                                    .clipShape(RoundedCornerShape(corners: [.topLeft, .bottomRight], radius: 10))
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .sheet(isPresented: $showBigImage, content: {
                                VStack{
                                    HStack{
                                        Spacer()
                                        Text("")
                                    }
                                    ZoomableContainer{
                                        Image(uiImage: viewModel.imageList[imageIndex])
                                            .resizable()
                                            .scaledToFit()
                                    }
                                }
                            })
                        }
                        
                        PhotosPicker(selection: $photoList,
                                     maxSelectionCount: 20, selectionBehavior: .ordered,
                                     matching: .images){
                            Image(systemName: "plus")
                                .resizable()
                                .padding(40)
                                .frame(width: 120, height: 120)
                                .foregroundStyle(.gray)
                                .background(.homeFactBg)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                                     .frame(width: 120, height: 120)
                                     .onChange(of: photoList, {
                                         fillImages()
                                     })
                    }
                }
                .padding()
                .padding(.horizontal)
                .padding(.bottom)
                
                Divider()
                    .padding()
                    .padding(.horizontal)
                
                DatePicker(selection: $viewModel.note.noteDate, in: dateRange, displayedComponents: .date, label: {
                    Text("日期")
                        .font(.headline)
                })
                .padding(.horizontal)
                .padding(.horizontal)
                
                Divider()
                    .padding()
                    .padding(.horizontal)
                
                VStack{
                    HStack{
                        Text("关联爱宠")
                            .font(.headline)
                        Spacer()
                        HStack {
                            Image(systemName: isAllSelected ? "checkmark.square.fill" : "square")
                                .foregroundStyle(isAllSelected ? .accent : .gray)
                            Text("全选")
                        }
                        .onTapGesture {
                            isAllSelected.toggle()
                            if(isAllSelected){
                                selectedPets = modelData.petList.map{ $0.id }
                            }else{
                                selectedPets.removeAll()
                            }
                        }
                    }
                    .padding(.bottom)
                    
                    ScrollView(.horizontal, showsIndicators: false){
                        HStack(spacing: 15){
                            ForEach(modelData.petList, content: {pet in
                                PetItemView(pet: pet, isSelected: selectedPets.contains(pet.id)) { isSelected in
                                    if selectedPets.contains(pet.id) {
                                        if let index = selectedPets.firstIndex(of: pet.id){
                                            selectedPets.remove(at: index)
                                            isAllSelected = false
                                        }
                                    } else {
                                        selectedPets.append(pet.id)
                                    }
                                }
                            })
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.horizontal)
                
                Divider()
                    .padding()
                    .padding(.horizontal)
                
                Spacer()
            }
            .dismissKeyboardOnScroll()
        }
    }
    
    func fillImages(){
        Task{
            var newImageList: [UIImage] = []
            for eachItem in photoList {
                if let imageData = try? await eachItem.loadTransferable(type: Data.self) {
                    if let image = UIImage(data: imageData) {
                        newImageList.append(image)
                    }
                }
            }
            viewModel.imageList = newImageList
        }
    }
}


struct PetItemView: View {
    let pet: PetModel
    let isSelected: Bool
    let onTap: (_ isSelected: Bool) -> Void
    
    var body: some View {
        VStack {
            LazyImage(url: URL(string: pet.avatar)){ state in
                state.image?
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            
            HStack {
                Image(systemName: isSelected ? "checkmark.square.fill" : "square")
                    .foregroundStyle(isSelected ? .accent : .gray)
                Text(pet.name)
            }
        }
        .onTapGesture {
            onTap(isSelected)
        }
    }
}

#Preview {
AddNoteView(showAddNote: .constant(true), viewModel: AddNoteVM())
    .environmentObject(ModelData())
}
