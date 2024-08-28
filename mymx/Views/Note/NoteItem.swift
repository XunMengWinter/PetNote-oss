//
//  NoteItemswift.swift
//  mymx
//
//  Created by ice on 2024/7/6.
//

import SwiftUI
import NukeUI

struct NoteItem: View {
    @EnvironmentObject var modelData: ModelData

    @State var note: NoteModel
    
    let screenWidth = UIScreen.main.bounds.size.width
    @State private var columnLayout = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    @State private var showBigImage = false
    @State private var imageIndex = 0
    
    var body: some View {
        LazyVStack(alignment: .leading, spacing: 0) {

            HStack{
                Text(note.content)
                    .font(.title3)
                    .padding(.vertical)
                Spacer(minLength: 0)
                Button(action: {
                    print("tap ....")
                }, label: {
                    Image(systemName: "ellipsis")
                })
                    
            }
            if note.images.count > 1 {
                LazyVGrid(columns: columnLayout, spacing: 8) {
                    ForEach(note.images, id: \.self) { image in
                        
                        Rectangle()
                            .foregroundStyle(.clear)
                            .overlay{
                                LazyImage(url: URL(string: image)) { state in
                                    state.image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                }
                                
                            }
                            .aspectRatio(1.0, contentMode: ContentMode.fit)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .contentShape(.rect)
                            .onTapGesture(perform: {
                                showBigImage.toggle()
                                imageIndex = note.images.firstIndex(of: image)!
                            })
                    }
                }
            }
            else if note.images.count == 1{
                LazyImage(url: URL(string: note.images[0])) { state in
                    state.image?
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .frame(maxWidth: .infinity)
                .frame(maxHeight: screenWidth)
                .onTapGesture(perform: {
                    showBigImage.toggle()
                    imageIndex = 0
                })
            }
            HStack{
                if(note.pets.count > 0 && modelData.petList.count > 0){
                    ScrollView(.horizontal){
                        HStack(spacing: 6){
                            Image(systemName: "arrow.turn.down.right")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(.gray)
                            
                            ForEach(note.getPets(allPets: modelData.petList), content: {pet in
                                LazyImage(url: URL(string: pet.avatar)){ state in
                                    state.image?
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 36, height: 36)
                                }.clipShape(Circle())
                                
                            })
                        }
                    }
                    .scrollIndicators(.hidden)
                }
                Spacer()
                Text(self.note.noteDate, format: .dateTime.day().month().year())
                    .font(.subheadline)
            }
            .padding(.vertical)
        }
        .sheet(isPresented: $showBigImage, content: {
                ImagePageView(pages: note.images.map({
                    AttachmentImageView(imageUrl: $0)
                }), currentPage: $imageIndex)
            .presentationDragIndicator(.visible)
        })
        .onAppear(perform: {
            if(note.images.count == 2 || note.images.count == 4){
                self.columnLayout = Array(repeating: GridItem(.flexible(), spacing: 8), count: 2)
            }else if(note.images.count == 1){
                self.columnLayout = Array(repeating: GridItem(.flexible(), spacing: 8), count: 1)
            }else if(note.images.count > 12){
                self.columnLayout = Array(repeating: GridItem(.flexible(), spacing: 8), count: 4)
            }
        })
    }
}
