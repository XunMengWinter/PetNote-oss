//
//  PhotoPageView.swift
//  mymx
//
//  Created by ice on 2024/7/2.
//

import SwiftUI

struct PhotoPageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            PageViewController(pages: pages, currentPage: $currentPage)
            
            if(pages.count > 1){
                PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                    .frame(width: CGFloat(pages.count * 18))
                    .scaleEffect(0.75)
            }
        }
    }
}
