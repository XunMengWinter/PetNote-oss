//
//  MapSheetView.swift
//  mymx
//
//  Created by ice on 2024/8/13.
//

import SwiftUI
import MapKit

struct MapSheetView: View {
    
    @EnvironmentObject private var modelData: ModelData
    @State private var search: String = "Pet Map is coming soon!"
    @State private var shopCoordinate = CLLocationCoordinate2D(latitude: 30.281439, longitude: 120.095027)
    @State private var span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    var body: some View {
        VStack {
            // 1
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Pet Map is coming soon!", text: $search)
                    .autocorrectionDisabled()
                    .submitLabel(.search)
                    .onSubmit {
                        Task {
                            let region = MKCoordinateRegion(center: shopCoordinate, span: span)
                        }
                    }
            }
            .modifier(TextFieldGrayBackgroundColor())
            
            Spacer()
            
            // 2
            List {
            }
            // 4
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .padding()
        // 2
        .interactiveDismissDisabled()
        // 3
        .presentationDetents([.height(200), .large])
        // 4
        .presentationBackground(.regularMaterial)
        // 5
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}
