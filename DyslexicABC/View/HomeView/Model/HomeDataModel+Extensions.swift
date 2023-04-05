//
//  HomeData+Extensions.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 03/04/23.
//

import Foundation
import SwiftUI

extension HomeData {
    var showListHistory: [HomeItem] {
        return listHistory?.array as? [HomeItem] ?? []
    }
}

extension HomeItem {
    var showTitle: String {
        return title ?? "Undefined"
    }
    
    var showFile: String {
        return file ?? "Undefined"
    }
    
    var showAudio: String {
        return audio ?? "Undefined"
    }
    
    var showImage: Image {
        return Image(image ?? "")
    }
}
