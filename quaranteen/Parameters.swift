//
//  Parameters.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 29/03/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation

struct Parameters: Codable {
    let particleCount: Int
    let particleLoops: Int
    let maxVelocity: CGFloat
    let columns: Int
    let rows: Int
    let vectorFieldMagnitude: CGFloat
    let noisePersistence: CGFloat
}
