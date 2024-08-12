//
//  ForumView.swift
//  mymx
//
//  Created by ice on 2024/7/30.
//

import SwiftUI

struct ForumView: View {
    var body: some View {
        VStack{
            Image("zoo")
                .padding()
            Text("Pet's Forum is coming soon!")
                .font(.title)
        }
        .toolbarBackground(Color("forumColor"), for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}

#Preview {
    ForumView()
}
