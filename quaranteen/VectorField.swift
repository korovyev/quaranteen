//
//  VectorField.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 22/03/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation

class VectorField {
    let size: CGSize
    private let columns: Int
    private let rows: Int
    private var lines = [[Line]]()
    
    init(size: CGSize, columns: Int, rows: Int) {
        self.size = size
        self.columns = columns
        self.rows = rows
    }
    
    func build() {
        
        let columnWidth = size.width / CGFloat(columns)
        let rowHeight = size.height / CGFloat(rows)
        
        for column in 0..<columns {
            
            var col = [Line]()
            
            for row in 0..<rows {
                
                let columnF = CGFloat(column)
                let rowF = CGFloat(row)
                
                let start = CGPoint(x: columnF * columnWidth, y: rowF * rowHeight)
                let end = CGPoint(x: (columnF + 1) * columnWidth, y: (rowF + 1) * rowHeight)
                
                let line = Line(start: start, end: end)
                
                col.append(line)
            }
            
            lines.append(col)
        }
    }
    
    func applyNoise(noise: PerlinNoise) {
        for column in 0..<columns {
            for row in 0..<rows {
                let noiseValue = noise.noise[column][row]
                let line = lines[column][row]
                //rotate line.end around line.start by noiseValue * two pi
                let twopi = Float.pi * 2
                
                let new = line.rotate(by: noiseValue * twopi)
                lines[column][row] = new
            }
        }
    }
    
    func buildForces(magnitude: CGFloat) -> [[CGVector]] {
        
        var vecCols = [[CGVector]]()
        for column in 0..<columns {
            var vecRows = [CGVector]()
            for row in 0..<rows {
                let line = lines[column][row]
                vecRows.append(line.start.vector(to: line.end).magnitudeScaled(to: magnitude)!)
            }
            vecCols.append(vecRows)
        }
        
        return vecCols
    }
    
    func draw(in context: CGContext) {
        context.setStrokeColor(.black)
        context.setLineWidth(0.5)
        
        for column in lines {
            for line in column {
                context.move(to: line.start)
                context.addLine(to: line.end)
            }
        }
        context.strokePath()
    }
}
