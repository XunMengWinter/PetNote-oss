//
//  AddPetView.swift
//  mymx
//
//  Created by ice on 2024/7/6.
//

import SwiftUI
import Mantis
import PhotosUI

struct AddPetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var modelData: ModelData
    
    @State private var petInfo = PetModel()
    @State private var selectedAvatar: UIImage? = nil
    @State private var croppedAvatar: UIImage? = nil
    @State private var photoList: [PhotosPickerItem] = []
    
    @State private var showingImageCropper = false
    @State private var presetFixedRatioType: Mantis.PresetFixedRatioType = .canUseMultiplePresetFixedRatio(defaultRatio: 1)
    @State private var cropperType: ImageCropperType = .normal
    @State private var cropShapeType: Mantis.CropShapeType = .circle(maskOnly: true)
    
    @StateObject var addPetVM = AddPetVM(isUpdate: false)
    @State private var showAlert = false

    var dateRange: ClosedRange<Date>{
        let min = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: Date())!
        return min...max
    }
    
    var body: some View {
        
        Form{
            Section(content: {
                HStack{
                    Text("名称")
                    Spacer()
                    TextField("请输入爱宠名称", text: $petInfo.name)
                        .multilineTextAlignment(.trailing)
                        .submitLabel(.done)
                        .foregroundStyle(.secondary)
                }
                .frame(minHeight: 40)
                
                Picker("类目", selection: $petInfo.family) {
                    ForEach(Family.allCases) { family in
                        Text(FamilyModel.getModel(family).cn).tag(family)
                    }
                }.frame(minHeight: 40)
                
                Picker("性别", selection: $petInfo.gender) {
                    ForEach(Gender.allCases) { gender in
                        Text(GenderModel.getModel(gender).cn).tag(gender)
                    }
                }.frame(minHeight: 40)
                HStack{
                    DatePicker(selection: $petInfo.birthDate, in: dateRange, displayedComponents: .date, label: {Text("生日")})
                }.frame(minHeight: 50)
                HStack {
                    Text("头像")
                    Spacer()
                    
                    PhotosPicker(selection: $photoList,
                                 maxSelectionCount: 1,
                                 matching: .images){
                        if let selectedAvatar = selectedAvatar {
                            Image(uiImage: selectedAvatar)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                            .clipShape(Circle())               } else {
                                Image(systemName: self.petInfo.familyModel.systemName)
                                    .resizable()
                                    .foregroundStyle(Color.iconfill)
                                    .scaledToFit()
                                    .frame(width: 64, height: 64)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                    }
                                 .onChange(of: photoList, {
                                     fillImages()
                                 })
                }.frame(minHeight: 64)
                
                TextField("描述...", text: $petInfo.description)
                    .foregroundStyle(.secondary)
                    .frame(minHeight: 80)
                    .submitLabel(.done)
            }, header: {Text("爱宠信息（必填）")}, footer: ({
                HStack{
                    Spacer()
                    if(addPetVM.loading){
                        ProgressView("爱宠添加中...")
                    } else {
                        Button(action: {
                            addPetVM.updatePet(pet: petInfo, image: selectedAvatar)
                        }, label: {
                            Text("添 加")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 15)
                                .background(Color.button)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        })
                    }
                    Spacer()
                }
                .padding(32)
            })
            ) }
        .sheet(isPresented: $showingImageCropper) {
            ImageCropper(image: $selectedAvatar,
                         cropShapeType: $cropShapeType,
                         presetFixedRatioType: $presetFixedRatioType,
                         type: $cropperType)
            .onDisappear(perform: {
                print("cropped")
            })
            .ignoresSafeArea()
        }
        .toolbar{
            NavigationLink("编辑爱宠", destination: {
                PetListView()
                .navigationTitle("爱宠列表")
            })
        }
        .onChange(of: addPetVM.success, {
            modelData.getPetList()
            presentationMode.wrappedValue.dismiss()
        })
        .onChange(of: addPetVM.errorMsg, {
            if(addPetVM.errorMsg.count > 0){
                self.showAlert = true
            }
        })
        .alert(addPetVM.errorMsg, isPresented: $showAlert){
            Button("OK", role: .cancel, action: {
                addPetVM.errorMsg = ""
            })
        }
        .navigationTitle("添加爱宠")
    }
    
    func fillImages(){
        if photoList.isEmpty {
            return
        }
        Task{
            if let imageData = try? await photoList.first?.loadTransferable(type: Data.self) {
                if let image = UIImage(data: imageData) {
                    withAnimation{
                        selectedAvatar = image
                        if selectedAvatar != nil {
                            showingImageCropper = true
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    AddPetView()
        .environmentObject(ModelData())
}
