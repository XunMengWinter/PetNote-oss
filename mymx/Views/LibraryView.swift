//
//  LibraryHome.swift
//  mymx
//
//  Created by ice on 2024/6/17.
//

import SwiftUI

struct LibraryView: View {
    var body: some View {
        VStack{
            Image("library")
                .padding()
            Text("Pet's Library is coming soon!")
                .font(.title)
        }
        .toolbarBackground(Color("libraryColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    LibraryView()
}
