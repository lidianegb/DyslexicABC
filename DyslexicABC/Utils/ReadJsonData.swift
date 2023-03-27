//
//  ReadJsonData.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import SwiftUI

class ReadJsonData<T: Codable>: ObservableObject {
    @Published var data: T?
    var resourceName: String
    
    init(resourceName: String) {
        self.resourceName = resourceName
        loadData()
    }
    
    func loadData() {
        guard let url = Bundle.main.url(forResource: resourceName, withExtension: "json") else {
            return
        }
        if let urlData = try? Data(contentsOf: url),
           let data = try? JSONDecoder().decode(T.self, from: urlData) {
            self.data = data
        }
    }
}
