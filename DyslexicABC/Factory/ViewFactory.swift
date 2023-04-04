//
//  ViewFactory.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 03/04/23.
//

import Foundation
import SwiftUI

class ViewFactory {
    @ViewBuilder
    static func viewForRouter(_ route: Router) -> some View {
        switch route {
        case .home:
            HomeView()
        case let .history(data):
            StoryView(storyData: data)
        }
    }
}
