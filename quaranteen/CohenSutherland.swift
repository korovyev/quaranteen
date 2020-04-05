//
//  CohenSutherland.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 01/04/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation

//https://www.geeksforgeeks.org/line-clipping-set-1-cohen-sutherland-algorithm/
struct CohenSutherland {
    let rect: CGRect
    
    enum RegionCode: Int {
        case inside = 0 // 0000
        case left = 1   // 0001
        case right = 2  // 0010
        case bottom = 4 // 0100
        case top = 8    // 1000
    }
    
    func clip(line: Line) -> Line? {
        
        guard initialSweep(for: line) else {
            return nil
        }
        
        var startCode = computeCode(for: line.start)
        var endCode = computeCode(for: line.end)
        
        var start = line.start
        var end = line.end
        
        while true {
            if startCode.rawValue == 0 && endCode.rawValue == 0 {
                // both points inside rectangle
                return Line(start: start, end: end)
            }
            else if startCode.rawValue & endCode.rawValue != 0 {
                // both points outside rectangle in same region
                return nil
            }
            else {
                // some segment lies within rectangle
                
                let outsideCode: RegionCode
                let x, y: CGFloat
                if startCode.rawValue != 0 {
                    outsideCode = startCode
                }
                else {
                    outsideCode = endCode
                }
                
                // Find intersection point
                // using formulas y = y1 + slope * (x - x1),
                // x = x1 + (1 / slope) * (y - y1)
                if outsideCode.rawValue & RegionCode.top.rawValue != 0 {
                    // point is above the clip rectangle
                    x = start.x + (end.x - start.x) * ((rect.origin.y + rect.height) - start.y) / (end.y - start.y)
                    y = rect.origin.y + rect.height
                }
                else if outsideCode.rawValue & RegionCode.bottom.rawValue != 0 {
                    // point is below the rectangle
                    x = start.x + (end.x - start.x) * (rect.origin.y - start.y) / (end.y - start.y)
                    y = rect.origin.y
                }
                else if outsideCode.rawValue & RegionCode.right.rawValue != 0 {
                    // point is to the right of rectangle
                    y = start.y + (end.y - start.y) * ((rect.origin.x + rect.width) - start.x) / (end.x - start.x)
                    x = (rect.origin.x + rect.width)
                }
                else if outsideCode.rawValue & RegionCode.left.rawValue != 0 {
                    // point is to the left of rectangle
                    y = start.y + (end.y - start.y) * (rect.origin.x - start.x) / (end.x - start.x);
                    x = rect.origin.x
                }
                else {
                    x = .greatestFiniteMagnitude
                    y = .greatestFiniteMagnitude
                    break
//                    fatalError()
                }
                
                // Now intersection point x, y is found
                // We replace point outside rectangle
                // by intersection point
                if (outsideCode == startCode) {
                    start = .init(x: x, y: y)
                    startCode = computeCode(for: .init(x: x, y: y))
                }
                else {
                    end = .init(x: x, y: y)
                    endCode = computeCode(for: .init(x: x, y: y))
                }
            }
        }
        
        return nil
    }
    
    private func computeCode(for point: CGPoint) -> RegionCode {
        var code: Int = RegionCode.inside.rawValue
        if point.x < rect.origin.x {
            code |= RegionCode.left.rawValue
        }
        else if point.x > rect.origin.x + rect.width {
            code |= RegionCode.right.rawValue
        }
        else if point.y < rect.origin.y {
            code |= RegionCode.bottom.rawValue
        }
        else if point.y > rect.origin.y + rect.height {
            code |= RegionCode.top.rawValue
        }
        
        return RegionCode(rawValue: code)!
    }
    
    private func initialSweep(for line: Line) -> Bool {
        // check left
        if line.start.x < rect.origin.x && line.end.x < rect.origin.x { return false }
        // check right
        if line.start.x > rect.origin.x + rect.width && line.end.x > rect.origin.x + rect.width { return false }
        // check bottom
        if line.start.y < rect.origin.y && line.end.y < rect.origin.y { return false }
        // check top
        if line.start.y > rect.origin.y + rect.height && line.end.y > rect.origin.y + rect.height { return false }
        
        return true
    }
}
