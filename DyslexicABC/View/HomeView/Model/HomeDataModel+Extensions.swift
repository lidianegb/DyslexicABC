//
//  HomeDataModel+Extensions.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 03/04/23.
//

import Foundation

extension HomeDataModel {
    var showTitle: String {
        return title ?? "Undefined"
    }
    
    var showListHistory: [StoryDataModel] {
        return listHistory?.allObjects as? [StoryDataModel] ?? []
    }
}
