//
//  CustomFont.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import UIKit
import SwiftUI

extension UIFont {
    static let openDyslexicRegular = UIFont(name: "OpendyslexicRegular-nRLZ0.otf", size: 26)
    static let openDyslexicBold = UIFont(name: "OpendyslexicBold-9Yo9n", size: 26)
    static let openDyslexicBoldItalic = UIFont(name: "OpendyslexicBoldItalic-ywjGe", size: 26)
    static let openDyslexicItalic = UIFont(name: "OpendyslexicItalic-lgd50", size: 26)
    static let openDyslexic = UIFont(name: "open-dyslexic", size: 20)
}

extension Font {
    static let openDyslexicRegular = Font.custom("OpendyslexicRegular-nRLZ0.otf", size: 26)
    static let openDyslexicBold = Font.custom("OpendyslexicBold-9Yo9n", size: 26)
    static let openDyslexicBoldItalic = Font.custom("OpendyslexicBoldItalic-ywjGe", size: 26)
    static let openDyslexicItalic = Font.custom("OpendyslexicItalic-lgd50", size: 26)
    static let openDyslexic = Font.custom("open-dyslexic", size: 20)
}
