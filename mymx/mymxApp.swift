//
//  mymxApp.swift
//  mymx
//
//  Created by ice on 2024/6/17.
//

import SwiftUI

@main
struct mymxApp: App {
    @State private var modelData = ModelData()
    @State private var networkMonitor = NetworkMonitor()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .environment(networkMonitor)
        }
    }
}
