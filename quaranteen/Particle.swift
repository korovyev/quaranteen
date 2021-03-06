//
//  Particle.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 28/03/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation

class Particle {
    
    var lines = [Line]()
    var position: CGVector
    var velocity: CGVector
    var acceleration = CGVector(dx: 0, dy: 0)
    var previousPosition: CGVector
    let maxVelocity: CGFloat
    
    var wrapped = false
    
    init(start: CGPoint, velocity: CGVector, maxVelocity: CGFloat) {
        position = CGVector(dx: start.x, dy: start.y)
        self.velocity = velocity
        previousPosition = position
        self.maxVelocity = maxVelocity
    }
    
    
    func update() {
        previousPosition = position
        velocity += acceleration
        velocity = velocity.magnitudeScaled(to: maxVelocity)!
        position += velocity
        acceleration *= 0
        lines.append(currentLine())
    }
    
    func apply(force: CGVector) {
        acceleration += force
    }
    
    func wrap(size: CGSize) {
        if position.dx > size.width {
            position.dx = 0
            previousPosition = position
            wrapped = true
        }
        if position.dx < 0 {
            position.dx = size.width
            previousPosition = position
            wrapped = true
        }
        if position.dy > size.height {
            position.dy = 0
            previousPosition = position
            wrapped = true
        }
        if position.dy < 0 {
            position.dy = size.height
            previousPosition = position
            wrapped = true
        }
    }
    
    func currentLine() -> Line {
        Line(start: previousPosition.point, end: position.point)
    }
}
