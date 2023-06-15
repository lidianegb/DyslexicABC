//
//  PlayerView.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 05/04/23.
//

import Foundation
import SwiftUI
import AVFoundation

struct PlayerView: View {
 
   var viewModel: HistoryViewModel
    var currentStringTime: String
    var duration: Double
    var stringDuration: String
   
    @State var state: PlayerState = .stoped
    @State var expanded: Bool = false
    
    var buttonSize = CGSize(width: 80, height: 80)
    var expandedButtonWidth = UIScreen.main.bounds.width
    let stopButtonImage = "stop.fill"
    var playPauseImage: String {
        state == .playing ? "pause.fill" : "play.fill"
    }
   
    var body: some View {
        VStack {
            VStack {
               // Slider(value: $currentTime, in: 0...duration)
                //    .controlSize(.small)
                //    .accentColor(.white)
                 //   .padding([.bottom])
                HStack {
                    Text(currentStringTime)
                    Spacer()
                    Text(stringDuration)
                }
            } .opacity(expanded ? 1 : 0)
           
        
            HStack {
                Spacer()
                PlayButton( image: playPauseImage, color: .green, buttonSize: buttonSize,action: {
                    if state == .playing {
                        state = .paused
                    } else {
                        state = .playing
                    }
                })
                    .transition(.move(edge: .trailing))
                Spacer()
                if expanded {
                    PlayButton(image: stopButtonImage, color: .red, buttonSize: buttonSize, action: {
                        state = .stoped
                    })
                        .transition(.move(edge: .leading))
                    Spacer()
                }
            }
        }
        .onChange(of: state, perform: { newValue in
            withAnimation {
                expanded = newValue == .stoped ? false : true
            }
        })
        .frame(width: expanded ? expandedButtonWidth : buttonSize.width, height: buttonSize.height)
      
    }
}

struct PlayerViewTest: View {
    let stopButtonImage: String
    var playPauseImage: String
    var buttonSize: CGSize
    var playAction: (() -> Void)?
    var stopAction: (() -> Void)?
    
    @State private var expanded: Bool = false

    var body: some View {
        VStack {
            HStack {
                Spacer()
                PlayButton(image: playPauseImage, color: .green, buttonSize: buttonSize,action: {
                    withAnimation {
                        expanded = true
                    }
                   playAction?()
                })
                    .transition(.move(edge: .trailing))
                Spacer()
                if expanded {
                    PlayButton(image: stopButtonImage, color: .red, buttonSize: buttonSize, action: {
                        withAnimation {
                            expanded = false
                        }
                        stopAction?()
                    })
                        .transition(.move(edge: .leading))
                    Spacer()
                }
            }
        }
    }
}

struct PlayButton: View {
    var image: String
    var color: Color
    var buttonSize: CGSize
    var action: (() -> Void)?
  
    var body: some View {
        Button(action: {
           action?()
        }, label: {
            Circle()
                .overlay(content: {
                    HStack {
                        Image(systemName: image)
                            .font(.system(.title2))
                            .foregroundColor(Color.white)
                    }
                       
                })
                .frame(width: buttonSize.width, height: buttonSize.height)
                .accentColor(color)
                .cornerRadius(buttonSize.width / 2)
                .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                
        })
    }
}

struct PlayerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerViewTest(stopButtonImage: "stop.fill", playPauseImage: "play.fill", buttonSize: CGSize(width: 50, height: 50))
    }
}
