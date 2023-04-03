//
//  HomeModel.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 27/03/23.
//

import Foundation

public struct HomeCodableData: Codable {
    public let title: String
    public let listHistory: [HomeListHistory]
    
    private enum CodingKeys: String, CodingKey {
        case title = "titulo"
        case listHistory = "historias"
    }
}

public struct HomeListHistory: Codable {
    public let file: String
    public let audio: String
    
    private enum CodingKeys: String, CodingKey {
        case file = "arquivo"
        case audio
    }
}
