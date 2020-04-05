//
//  Window.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 31/03/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation

struct Window {
    let rect: CGRect
    let lines: [Line]
    
    func clipped() -> [Line] {
        let clipAlgorithm = CohenSutherland(rect: rect)
        let clipped = lines.compactMap(clipAlgorithm.clip)
        return clipped + rect.borders
    }
}
