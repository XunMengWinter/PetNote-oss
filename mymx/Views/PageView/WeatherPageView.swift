//
//  PageView.swift
//  Landmarks
//
//  Created by ice on 2024/6/16.
//

import SwiftUI

struct WeatherPageView<Page:View>: View {
    var pages: [Page]
    @State private var currentPage = 0
    
    var body: some View {
        ZStack(alignment: .bottom) {
            PageViewController(pages: pages, currentPage: $currentPage)
            
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.bottom,12)
        }
        .frame(height: 242)
    }
    
}

#Preview {
    WeatherPageView(pages: MockData().poetryWeatherResult.poetryWeatherList.map({
        WeatherItem(poetryWeather: $0)
            .padding()
    }))
    .environmentObject(ModelData())
}
