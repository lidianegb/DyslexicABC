//
//  Extensions.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 25/03/23.
//

import Foundation
import SwiftUI

extension HistoryData {
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
    
    var showTimes: [HistoryTime] {
        return times?.array as? [HistoryTime]  ?? []
    }
    
    var showWords: [HistoryWord] {
        return words?.array as? [HistoryWord] ?? []
    }
}
