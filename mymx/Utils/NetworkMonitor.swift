//
//  NetworkMonitor.swift
//  mymx
//
//  Created by ice on 2024/8/1.
//

import Foundation
import Network
import Observation

@MainActor
@Observable
final class NetworkMonitor {
    private let monitor = NWPathMonitor()
    private let workerQueue = DispatchQueue(label: "Monitor")

    var isConnected = false

    init() {
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self else { return }
            Task { @MainActor in
                self.isConnected = (path.status == .satisfied)
            }
        }
        monitor.start(queue: workerQueue)
    }

    deinit {
        monitor.cancel()
    }
}
