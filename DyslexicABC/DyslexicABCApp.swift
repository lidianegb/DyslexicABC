//
//  DyslexicABCApp.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 26/12/22.
//

import SwiftUI

@main
struct DyslexicABCApp: App {
    @StateObject var appData = ApplicationData()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(appData)
                .environment(\.managedObjectContext, appData.container.viewContext)
        }
    }
}
