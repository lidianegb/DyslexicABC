//
//  JSONFileManager.swift
//  DyslexicABC
//
//  Created by Lidiane Gomes Barbosa on 08/02/23.
//

import Foundation

public class JSONFileManager {
    var jsonString: String

    init(jsonString: String) {
        self.jsonString = jsonString
        generateFile(jsonString: jsonString)
    }
    
    private func generateFile(jsonString: String) {
        if let documentDirectory = FileManager.default.urls(for: .documentDirectory,
                                                            in: .userDomainMask).first {
            let pathWithFilename = documentDirectory.appendingPathComponent("teste-estrelinha-do-mar.json")
            do {
                try jsonString.write(to: pathWithFilename,
                                     atomically: true,
                                     encoding: .utf8)
            } catch {
                // Handle error
            }
        }
    }
}

//extension JSONFileManager: SpeechRecognitionManagerDelegate {
//    public func didFinishRecognition(with result: [String : String]) {
//       // var dictionary: [String: Any] = result
//        if let jsonData = try? JSONSerialization.data(withJSONObject: result), let jsonString = String(data: jsonData, encoding: .ascii) {
//            generateFile(jsonString: jsonString)
//        }
//    }
//}
