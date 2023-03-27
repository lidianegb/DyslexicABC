//
//  SpeechRecognition.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 08/02/23.
//

import Foundation
import Speech
import SwiftUI

public final class SpeechRecognition: NSObject, SFSpeechRecognizerDelegate, SFSpeechRecognitionTaskDelegate, ObservableObject {
    
    @Published var timestamps = [String: String]()

    
    func didTapSpeechRecognitionButton() {
        guard let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "pt_BR")) else {
            print("Speech recognizer is not available for this locale!")
            return
        }
        speechRecognizer.delegate = self
        if (speechRecognizer.isAvailable == false) {
            print("Speech recognizer is not available for this device!")
            return
        }
        
        SFSpeechRecognizer.requestAuthorization { authStatus in
            if (authStatus == .authorized) {
                // Grab a local audio sample to parse
                let fileURL = URL(fileURLWithPath: Bundle.main.path(forResource: "a-estrelinha-do-mar-historinha-infantil-historia-curta", ofType: "mp3")!)
                
                // Get the party started and watch for results in the completion block.
                // It gets fired every time a new word (aka transcription) gets detected.
                let request = SFSpeechURLRecognitionRequest(url: fileURL)
                
                _ = speechRecognizer.recognitionTask(with: request, delegate: self)
                
            } else {
                print("Error: Speech-API not authorized!");
            }
        }
    }
    
    
    public func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
       // self.timestamps = recognitionResult.bestTranscription.segments.map { String($0.timestamp) }
//        self.timestamps = Dictionary(uniqueKeysWithValues: recognitionResult.bestTranscription.segments.map {(String($0.timestamp), $0.substring)
//        })
        
        let times: [SerializationClass] = recognitionResult.bestTranscription.segments.map {
            SerializationClass(timestamp: String($0.timestamp), value: $0.substring)
        }
        
        if let jsonData = try? JSONEncoder().encode(times), let jsonString = String(data: jsonData, encoding: .ascii) {
            _ = JSONFileManager(jsonString: jsonString)
        }
//        if let jsonData = try? JSONSerialization.data(withJSONObject: timestamps), let jsonString = String(data: jsonData, encoding: .ascii) {
//            _ = JSONFileManager(jsonString: jsonString)
//
//        }
    }
}

public struct SerializationClass: Encodable {
    let timestamp: String
    let value: String
}
