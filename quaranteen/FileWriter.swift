//
//  FileWriter.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 29/03/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation

class FileWriter {
    private let seed: UInt64
    private let path: URL
    private let fileManager = FileManager()
    private var outputPath: URL {
        path.appendingPathComponent(String(seed))
    }
    
    init(seed: UInt64, path: URL) {
        self.seed = seed
        self.path = path
    }
    
    func save(image: CGImage) {
        createDirectory()
        let imageURL = outputPath.appendingPathComponent("image.png")
        guard let destination = CGImageDestinationCreateWithURL(imageURL as CFURL, kUTTypePNG, 1, nil) else {
                fatalError()
        }

        CGImageDestinationAddImage(destination, image, nil)
        CGImageDestinationFinalize(destination)
    }
    
    func createDirectory() {
        guard !fileManager.fileExists(atPath: outputPath.absoluteString, isDirectory: nil) else {
            return
        }
        
        try? fileManager.createDirectory(at: outputPath, withIntermediateDirectories: false, attributes: nil)
    }
    
    func save(lines: [Line]) {
        createDirectory()
        let filePath = outputPath.appendingPathComponent("image.txt")
        try? lines.stringRepresentation.write(to: filePath, atomically: false, encoding: .utf8)
    }
    
    func save(parameters: Parameters) {
        createDirectory()
        let json = try? JSONEncoder().encode(parameters)
        let path = outputPath.appendingPathComponent("parameters.json")
        try? json?.write(to: path)
    }
}

private extension Array where Element == Line {
    
    var stringRepresentation: String {
        var string = ""
        forEach { line in
            let start = String(Float(line.start.x))
                .appending(",")
                .appending(String(Float(line.start.y)))
            
            let end = String(Float(line.end.x))
                .appending(",")
                .appending(String(Float(line.end.y)))
            
            let fullLine = start.appending(";").appending(end)
            
            string.append(fullLine)
            string.append("\n")
        }
        
        return string
    }
}
