//
//  TextView.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 31/01/23.
//

import SwiftUI

struct TextView: UIViewRepresentable {
    @Binding var text: NSAttributedString?
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        textView.autocapitalizationType = .sentences
        textView.isSelectable = false
        textView.isUserInteractionEnabled = false
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.attributedText = text
        uiView.font = UIFont.openDyslexic ?? .preferredFont(forTextStyle: .callout)
    }
}
