//
//  FontStepper.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 05/04/23.
//

import Foundation
import SwiftUI

struct FontStepper: View {
    let text: String
    @Binding var value: Double
    let range: ClosedRange<Double>
    let step: Double
    let onIncrement: (() -> Void)?
    let onDecrement: (() -> Void)?
    @State private var valueChanged = false

    var body: some View {
        HStack {
            Text(text)
            Spacer()
            ZStack {
                Image("minusPlus")
                    .resizable()
                    .frame(width: 90, height: 35)
                HStack {
                    Button {
                        decrement()
                    } label: {
                        Image(systemName: "minus")
                            .frame(width: 38, height: 35)
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.green)

                    Button {
                        increment()
                    } label: {
                        Image(systemName: "plus")
                            .frame(width: 38, height: 35)
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.red)
                }
            }
        }
        .onAppear() {
            if value < range.lowerBound {
                value = range.lowerBound
            } else if value > range.upperBound {
                value = range.upperBound
            }
        }
    }

    func decrement() {
        if value > range.lowerBound {
            value -= step
            valueChanged = true
        }
        if value < range.lowerBound {
            value = range.lowerBound
        }
        if let onDecrement = onDecrement {
            if valueChanged {
                onDecrement()
                valueChanged = false
            }
        }
    }

    func increment() {
        if value < range.upperBound {
            value += step
            valueChanged = true
        }
        if value > range.upperBound {
            value = range.upperBound
        }
        if let onIncrement = onIncrement {
            if valueChanged {
                onIncrement()
                valueChanged = false
            }
        }
    }
}
