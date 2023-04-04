//
//  CardHistory.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 04/04/23.
//

import Foundation
import SwiftUI

struct CardHistory: View {
    
    private enum LocalMetrics {
        static let opacity = 0.3
        static let lineWidth = 1.5
    }
   
    var entity: StoryDataModel
    var totalColumns: CGFloat
    
    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: Metrics.tiny)
                .stroke(Color.gray.opacity(LocalMetrics.opacity), lineWidth: LocalMetrics.lineWidth)
                .foregroundColor(.white)
                .frame(height: (UIScreen.main.bounds.width / totalColumns) - Metrics.medium)
                .overlay {
                    entity.showImage
                        .resizable()
                }
            Text(entity.showTitle)
                .font(.openDyslexic)
                .fontWeight(.light)
                .fontWeight(.bold)
                .frame(alignment: .center)
                .multilineTextAlignment(.center)
            
        }
    }
}
