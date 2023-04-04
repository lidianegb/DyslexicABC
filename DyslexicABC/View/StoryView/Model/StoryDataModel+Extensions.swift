//
//  Extensions.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 25/03/23.
//

import Foundation
import SwiftUI

extension StoryDataModel {
    var showTitle: String {
        return title ?? "Undefined"
    }
    
    var showAuthor: String {
        return author ?? "Undefined"
    }
    
    var showText: String {
        return text ?? "Undefined"
    }
    
    var showImage: Image {
       return Image(image ?? "")
    }
    
    var showTimes: [StoryDataTimesModel] {
        return times?.array as? [StoryDataTimesModel]  ?? []
    }
    
    var showWords: [StoryDataWordsModel] {
        return words?.array as? [StoryDataWordsModel] ?? []
    }
}
