//
//  CustomFont.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import UIKit
import SwiftUI

enum FontName: String {
    case openDyslexicRegular = "OpendyslexicRegular-nRLZ0.otf"
    case openDyslexicBold = "OpendyslexicBold-9Yo9n"
    case openDyslexicBoldItalic = "OpendyslexicBoldItalic-ywjGe"
    case openDyslexicItalic = "OpendyslexicItalic-lgd50"
    case openDyslexic = "open-dyslexic"
}

extension Font {
    static let openDyslexicRegular = Font.custom(FontName.openDyslexicRegular.rawValue, size: Metrics.small)
    static let openDyslexicBold = Font.custom(FontName.openDyslexicBold.rawValue, size: Metrics.small)
    static let openDyslexicBoldItalic = Font.custom(FontName.openDyslexicBoldItalic.rawValue, size: Metrics.small)
    static let openDyslexicItalic = Font.custom(FontName.openDyslexicItalic.rawValue, size: Metrics.small)
    static let openDyslexic = Font.custom(FontName.openDyslexic.rawValue, size: Metrics.small)
}
