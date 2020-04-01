//
//  Primitive.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 22/03/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation

struct Line {
    let start: CGPoint
    let end: CGPoint
}

extension Line {
    func rotate(by angle: Float) -> Line {
        let origin = start
        
        let movedPointX = (end.x - origin.x)
        let movedPointY = (end.y - origin.y)
        let cosAngle = CGFloat(cos(angle))
        let sinAngle = CGFloat(sin(angle))
        
        let endX = origin.x + cosAngle * movedPointX - sinAngle * movedPointY
        let endY = origin.y + sinAngle * movedPointX + cosAngle * movedPointY
        let rotated = CGPoint(x: endX, y: endY)
        return Line(start: start, end: rotated)
    }
}
