//
//  DyslexicABCApp.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 26/12/22.
//

import SwiftUI

@main
struct DyslexicABCApp: App {
    @StateObject private var coordinator = Coordinator.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                HomeView()
                    .navigationDestination(for: Router.self) { route in
                        ViewFactory.viewForRouter(route)
                    }
            }
        }
    }
}
