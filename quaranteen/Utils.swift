//
//  Utils.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 29/03/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation
import GameKit

extension CGPoint {
    
    init(in rect: CGRect, generator: inout SeededRandomNumberGenerator) {
        self.init()
        let x = CGFloat.random(in: rect.origin.x..<(rect.origin.x + rect.width), using: &generator)
        let y = CGFloat.random(in: rect.origin.y..<(rect.origin.y + rect.height), using: &generator)
        
        self.x = x
        self.y = y
    }
    
    var vector: CGVector {
        .init(dx: x, dy: y)
    }
    
    func isInside(rect: CGRect) -> Bool {
        x > rect.origin.x && x < rect.origin.x + rect.width && y > rect.origin.y && y < rect.origin.y + rect.height
    }
}

extension CGVector {
    var point: CGPoint {
        .init(x: dx, y: dy)
    }
}

struct SeededRandomNumberGenerator : RandomNumberGenerator {
    // https://stackoverflow.com/a/57370987
    mutating func next() -> UInt64 {
        // GKRandom produces values in [INT32_MIN, INT32_MAX] range; hence we need two numbers to produce 64-bit value.
        let next1 = UInt64(bitPattern: Int64(gkrandom.nextInt()))
        let next2 = UInt64(bitPattern: Int64(gkrandom.nextInt()))
        return next1 | (next2 << 32)
    }

    init(seed: UInt64) {
        self.gkrandom = GKMersenneTwisterRandomSource(seed: seed)
    }

    private let gkrandom: GKRandom
}
