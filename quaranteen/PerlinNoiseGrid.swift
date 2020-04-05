//
//  PerlinNoiseGrid.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 22/03/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation

class PerlinNoise {
    
    let noise: [[Float]]
    private let generator: SeededRandomNumberGenerator
    
    init(width: Int, height: Int, noisePersistence: CGFloat, randomNumberGenerator: inout SeededRandomNumberGenerator) {
        let base = PerlinNoise.whiteNoise(width: width, height: height, generator: &randomNumberGenerator)
        self.generator = randomNumberGenerator
        self.noise = PerlinNoise.generate(baseNoise: base, octaveCount: 8, noisePersistence: noisePersistence, width: width, height: height)
    }
    
    class func whiteNoise(width: Int, height: Int, generator: inout SeededRandomNumberGenerator) -> [[Float]] {
        
        var outer = [[Float]](repeating: [], count: width)
        for y in 0..<height {
            var inner = [Float](repeating: 0.0, count: height)
            for x in 0..<width {
                inner[x] = Float.random(in: 0...1, using: &generator)
            }
            outer[y] = inner
        }
        
        return outer
    }
    
    class func smoothNoise(baseNoise: [[Float]], octave: Int, width: Int, height: Int) -> [[Float]] {
        let samplePeriod = 1 << octave
        let sampleFrequency: Float = 1.0 / Float(samplePeriod)
        
        var smoothed = zeroesArray(width: width, height: height)
        
        for i in 0..<width {
            let sample_i0 = (i / samplePeriod) * samplePeriod
            let sample_i1 = (sample_i0 + samplePeriod) % width
            let horizontalBlend = Float(i - sample_i0) * sampleFrequency
            
            for j in 0..<height {
                //calculate the vertical sampling indices
                let sample_j0 = (j / samplePeriod) * samplePeriod
                let sample_j1 = (sample_j0 + samplePeriod) % height
                let verticalBlend = Float(j - sample_j0) * sampleFrequency
                
                let top = interpolate(x0: baseNoise[sample_i0][sample_j0], x1: baseNoise[sample_i1][sample_j0], alpha: horizontalBlend)
                let bottom = interpolate(x0: baseNoise[sample_i0][sample_j1], x1: baseNoise[sample_i1][sample_j1], alpha: horizontalBlend)
                
                smoothed[i][j] = interpolate(x0: top, x1: bottom, alpha: verticalBlend)
            }
        }
        
        return smoothed
    }
    
    class func generate(baseNoise: [[Float]], octaveCount: Int, noisePersistence: CGFloat, width: Int, height: Int) -> [[Float]] {
        var smoothNoise = [[[Float]]](repeating: zeroesArray(width: width, height: height), count: octaveCount)
        
        
        for i in 0..<octaveCount {
            smoothNoise[i] = self.smoothNoise(baseNoise: baseNoise, octave: i, width: width, height: height)
        }
        
        var perlinNoise = zeroesArray(width: width, height: height)
        var amplitude: Float = 1.0
        var totalAmplitude: Float = 0.0
        
        for octave in (0..<octaveCount).reversed() {
            amplitude = amplitude * Float(noisePersistence)
            totalAmplitude = totalAmplitude + amplitude
            
            for i in 0..<width {
                for j in 0..<height {
                    perlinNoise[i][j] += smoothNoise[octave][i][j] * amplitude
                }
            }
        }
        
        for i in 0..<width {
            for j in 0..<height {
                perlinNoise[i][j] = perlinNoise[i][j] / totalAmplitude
            }
        }
        
        return perlinNoise
    }
    
    class func interpolate(x0: Float, x1: Float, alpha: Float) -> Float {
        x0 * (1 - alpha) + alpha * x1
    }
    
    class func zeroesArray(width: Int, height: Int) -> [[Float]] {
        [[Float]](repeating: [Float](repeating: 0.0, count: height), count: width)
    }
}
