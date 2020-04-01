//
//  Drawing.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 01/04/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation


struct Drawing {
    func begin(with destinationPath: String, seed: UInt64) {

        let destinationURL = URL(fileURLWithPath: destinationPath)
        let fileWriter = FileWriter(seed: seed, path: destinationURL)
        var randomNumbers = SeededRandomNumberGenerator(seed: seed)


        let size = CGSize(width: 1000, height: 1000)
        let rect = CGRect.init(origin: .init(x: 0, y: 0), size: size)

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

        context.setFillColor(.black)
        context.fill(rect)

        let parameters = Parameters(
            particleCount: 5000,
            particleLoops: 1,
            maxVelocity: 10,
            columns: 100,
            rows: 100,
            vectorFieldMagnitude: 8
        )

        print("Building Perlin Noise")

        let perlinNoise = PerlinNoise(width: parameters.columns, height: parameters.rows, randomNumberGenerator: &randomNumbers)

        print("Building Vector Field")

        let vectorField = VectorField(size: size, columns: parameters.columns, rows: parameters.rows)
        vectorField.build()

        print("Applying noise to vector field")

        vectorField.applyNoise(noise: perlinNoise)
        //vectorField.draw(in: context)

        let forceField = vectorField.buildForces(magnitude: parameters.vectorFieldMagnitude)

        print("Creating \(parameters.particleCount) particles")

        var particles = [Particle]()

        for _ in 0..<parameters.particleCount {
            let start = CGPoint.init(in: rect, generator: &randomNumbers)
            let velocity = CGPoint.zero
            
            particles.append(Particle(start: start, velocity: velocity.vector, maxVelocity: parameters.maxVelocity))
        }

        print("Applying vector forces to particles, \(parameters.particleLoops) times")

        for _ in 0..<parameters.particleLoops {
            particles.forEach { $0.draw(in: context) }
            particles.forEach { p in
                
                let position = p.position.point
                let columnWidth = size.width / CGFloat(parameters.columns)
                let rowHeight = size.height / CGFloat(parameters.rows)
                
                let x = Int(floor(position.x / columnWidth))
                let y = Int(floor(position.y / rowHeight))
                
                p.apply(force: forceField[max(0, x-1)][max(0, y-1)])
            }
            particles.forEach { $0.update() }
            particles.forEach { $0.wrap(size: size) }
        }

        print("Moving particles until they hit the edge")

        particles.forEach { p in
            p.wrapped = false
            
            while !p.wrapped {
                p.draw(in: context)
                let position = p.position.point
                let columnWidth = size.width / CGFloat(parameters.columns)
                let rowHeight = size.height / CGFloat(parameters.rows)
                
                let x = Int(floor(position.x / columnWidth))
                let y = Int(floor(position.y / rowHeight))
                
                p.apply(force: forceField[max(0, x-1)][max(0, y-1)])
                p.update()
                p.wrap(size: size)
            }
        }

        var lines = [Line]()
        particles.forEach { p in
            lines.append(contentsOf: p.lines)
        }

        let window = Window(rect: .init(origin: .init(x: 100, y: 100), size: .init(width: 100, height: 100)), lines: lines)
        let _ = window.clipped(context: context)

        print("Saving \(lines.count) lines to file")

        let image = context.makeImage()!

        fileWriter.save(lines: lines)
        fileWriter.save(image: image)
        fileWriter.save(parameters: parameters)

    }
}

