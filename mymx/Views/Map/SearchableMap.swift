//
//  SearchableMap.swift
//  mymx
//
//  Created by ice on 2024/8/13.
//

import SwiftUI
import MapKit

struct SearchableMap: View {
    @State private var position = MapCameraPosition.automatic
    @State private var xihuCoordinate = CLLocationCoordinate2D(latitude: 30.243933, longitude: 120.146351)
    @State private var span = MKCoordinateSpan(latitudeDelta: 0.08, longitudeDelta: 0.08)

    @State private var isSheetPresented: Bool = false
    @State private var scene: MKLookAroundScene?
    @State private var statusBarHeight: CGFloat = 0
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        // 3
        ZStack{
            ScrollView{
                VStack{
                    Map(position: .constant(.region(MKCoordinateRegion(center: xihuCoordinate, span: span)))) {
                      
                    }
                    .frame(height: 500)
                    .mapControls {
//                        MapUserLocationButton()
                        MapCompass()
                        MapScaleView()
                    }
                    .overlay(alignment: .bottom) {
                        HStack{
                            Image("map")
                                .resizable()
                                .frame(width: 100, height: 100)
                            Text("Pet Map is coming soon!")
                                .font(.title)
                                .padding()
                        }
                        .padding()
                        .background(.regularMaterial)
                        .clipShape(.rect(cornerRadius: 16))
                        .padding()
                    }
                    
                }
            }
            
            VStack{
                HStack{
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: "chevron.backward")
                            .font(.title2)
                            .padding(.top, statusBarHeight)
                            .padding()
                            .contentShape(.rect)
                    })
                    Spacer()
                }
                Spacer()
            }
        }
        .ignoresSafeArea(.all)
//        .navigationTitle("Pet Map")
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)
        .sheet(isPresented: $isSheetPresented) {
            MapSheetView()
        }
        .onAppear(perform: {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                self.statusBarHeight = windowScene.statusBarManager?.statusBarFrame.height ?? 0
            }
        })
    }
    
    private func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
        let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
        return try await lookAroundScene.scene
    }
}

#Preview {
    SearchableMap()
}
