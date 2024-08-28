//
//  PhotoItem.swift
//  mymx
//
//  Created by ice on 2024/6/20.
//

import SwiftUI
import UIKit
import NukeUI

struct PhotoItem: View {
    var photo: Photo
//    let screenWidth = UIScreen.main.bounds.size.width
    var body: some View {
        VStack(alignment: .leading) {
            HStack{
                LazyImage(url: URL(string: photo.avatar)){ image in
                    image.image?.resizable()
                        .scaledToFill()
                }
                .frame(width: 48, height: 48)
                .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                Text(photo.name)
                    .font(.headline)
                    .fontWeight(.medium)

                Spacer()
                
                Text(photo.getPublishedTime())
                    .font(.subheadline)
                //                Image(systemName: "ellipsis")
            }
            .padding(.trailing)
            .padding(.leading)
            .padding(.top)
            
            PhotoPageView(pages: photo.images.map({
                LazyImage(url: URL(string: $0.imageUrl)){phase in
                    phase.image?.resizable()
                        .scaledToFit()
                        .transition(.opacity.animation(.smooth))
                }
            }))
            .frame(maxWidth: .infinity)
            .aspectRatio(CGFloat(photo.images[0].width) / CGFloat( photo.images[0].height + 1), contentMode: .fill)
            
            VStack(alignment: .leading){
                if(!photo.title.isEmpty){
                    Text(photo.title)
                        .font(.title3)
                        .padding(.bottom, 4)
                }
                if(!photo.content.isEmpty){
                    Text(photo.content)
                        .font(.body)
                        .padding(.bottom, 4)
                }
            }
            .padding(.top, 6)
            .padding(.leading)
            .padding(.trailing)
            .padding(.bottom)
            
            //            Divider()
        }
    }
}

#Preview {
    PhotoItem(photo: MockData().photo)
}
