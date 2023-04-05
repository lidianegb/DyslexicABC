//
//  HistoryCodableData.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import Foundation

struct HistoryCodableData: Codable, Identifiable {
    var id = UUID()
    var title: String
    var author: String
    var image: String
    var text: String
    var words: [HistoryCodableWord]
    var times: [HistoryCodableTime]
    
    enum CodingKeys: String, CodingKey {
        case title = "titulo"
        case author = "autor"
        case image = "imagem"
        case text = "texto"
        case words = "palavras"
        case times = "tempos"
    }
}

struct HistoryCodableWord: Codable, Identifiable {
    var id = UUID()
    var word: String
    var syllables: [String]
    
    enum CodingKeys: String, CodingKey {
        case word = "palavra"
        case syllables = "silabas"
    }
}

struct HistoryCodableTime: Codable, Identifiable {
    var id = UUID()
    var word: String
    var timestamp: String
    
    enum CodingKeys: String, CodingKey {
        case word = "palavra"
        case timestamp
    }
}

