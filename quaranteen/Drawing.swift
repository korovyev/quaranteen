//
//  Drawing.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 01/04/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation


class Drawing {
    
    var randomNumbers: SeededRandomNumberGenerator
    let fileWriter: FileWriter
    let rect: CGRect
    let context: CGContext
    let parameters: Parameters
    var size: CGSize {
        rect.size
    }
    
    init(seed: UInt64, outputPath: String, rect: CGRect) {
        randomNumbers = SeededRandomNumberGenerator(seed: seed)
        fileWriter = FileWriter(seed: seed, path: URL(fileURLWithPath: outputPath))
        self.rect = rect
        self.context = Drawing.createContext(of: rect.size)
        parameters = Parameters(
            particleCount: 3000,
            particleLoops: 2,
            maxVelocity: 8,
            columns: 100,
            rows: 100,
            vectorFieldMagnitude: 6,
            noisePersistence: 0.65
        )
    }
    
    func drawFlowField() {
        let lines = createFlowField()
        fillBackground(color: .white)
        draw(lines: lines, color: .black)
        save(lines: lines)
    }
    
    func drawWindowedFlowField() {
        let size = CGSize(width: 100, height: 1000)
        let windows = [
            CGRect(origin: .init(x: 100, y: 100), size: size),
            CGRect(origin: .init(x: 275, y: 100), size: size),
            CGRect(origin: .init(x: 450, y: 100), size: size),
            CGRect(origin: .init(x: 625, y: 100), size: size),
            CGRect(origin: .init(x: 800, y: 100), size: size),
        ]
        
        let lines = createFlowField()
        var windowedLines = [Line]()
        
        windows.forEach { rect in
            let window = Window(rect: rect, lines: lines)
            windowedLines.append(contentsOf: window.clipped())
        }
        
        windowedLines.append(contentsOf: rect.borders)
        
        fillBackground(color: .black)
        //rgb(0.38,0.37,0.32)
        draw(lines: windowedLines, color: CGColor(red: 0.38, green: 0.37, blue: 0.32, alpha: 1), lineWidth: 1)
        save(lines: windowedLines)
    }
    
    private func createFlowField() -> [Line] {

        print("Building Perlin Noise")

        let perlinNoise = PerlinNoise(width: parameters.columns, height: parameters.rows, noisePersistence: parameters.noisePersistence, randomNumberGenerator: &randomNumbers)

        print("Building Vector Field")

        let vectorField = VectorField(size: size, columns: parameters.columns, rows: parameters.rows)
        vectorField.build()

        print("Applying noise to vector field")

        vectorField.applyNoise(noise: perlinNoise)
        _ = vectorField.buildForces(magnitude: parameters.vectorFieldMagnitude)

        print("Creating \(parameters.particleCount) particles")

        var particles = [Particle]()

        for _ in 0..<parameters.particleCount {
            let start = CGPoint.init(in: rect, generator: &randomNumbers)
            let velocity = CGPoint.zero
            
            particles.append(Particle(start: start, velocity: velocity.vector, maxVelocity: parameters.maxVelocity))
        }

        print("Applying vector forces to particles, \(parameters.particleLoops) times")

        for _ in 0..<parameters.particleLoops {
            particles.forEach { update(particle: $0, field: vectorField) }
        }

        print("Moving particles until they hit the edge")

        particles.forEach { p in
            p.wrapped = false
            while !p.wrapped {
                update(particle: p, field: vectorField)
            }
        }
        return particles.flatMap { $0.lines }
    }
    
    private func update(particle: Particle, field: VectorField) {
        particle.apply(force: field.vector(at: particle.position.point))
        particle.update()
        particle.wrap(size: size)
    }
    
    private func createWindow(lines: [Line], rect: CGRect) -> [Line] {
        let window = Window(rect: rect, lines: lines)
        return window.clipped()
    }
}

extension Drawing {
    
    func fillBackground(color: CGColor) {
        context.setFillColor(color)
        context.fill(rect)
    }
    
    func draw(lines: [Line], color: CGColor, lineWidth: CGFloat = 1) {
        
        context.setStrokeColor(color)
        context.setLineWidth(lineWidth)
        
        lines.forEach { line in
            context.move(to: line.start)
            context.addLine(to: line.end)
            context.strokePath()
        }
    }
    
    func draw(vectorField: VectorField, color: CGColor) {
        vectorField.lines.forEach { col in
            draw(lines: col, color: color)
        }
    }
    
    func save(lines: [Line]?) {
        if let lines = lines {
            print("Saving \(lines.count) lines to file")
            fileWriter.save(lines: lines)
        }
        let image = context.makeImage()!
        fileWriter.save(image: image)
        fileWriter.save(parameters: parameters)
    }
}

extension Drawing {
    static func createContext(of size: CGSize) -> CGContext {
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(
            data: nil,
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bytesPerRow: 0,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue) else {
                fatalError()
        }
        return context
    }
}

