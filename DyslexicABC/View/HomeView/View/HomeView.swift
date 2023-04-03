//
//  HomeView.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 27/03/23.
//

import SwiftUI
import CoreData

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        Button {
             
        } label: {
            Text("Hello, World!")
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
