//
//  Coordinator.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 03/04/23.
//

import Foundation
import SwiftUI

class Coordinator: ObservableObject {
    @Published var path = NavigationPath()
    static var shared = Coordinator()
    
    func popToRoot() {
        for _ in .zero..<path.count {
            path.removeLast()
        }
    }
    
    func pop() {
        path.removeLast()
    }
    
    func goToHistoryScreen(_ data: StoryDataModel) {
        path.append(Router.history(data))
    }
    
    func goToHome() {
        path.append(Router.home)
    }
}
