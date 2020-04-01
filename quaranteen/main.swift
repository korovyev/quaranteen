//
//  main.swift
//  quaranteen
//
//  Created by Kevin Sweeney on 22/03/2020.
//  Copyright © 2020 Kevin Sweeney. All rights reserved.
//

import Foundation
import CoreGraphics
import ArgumentParser

struct Quaranteen: ParsableCommand {
    static let configuration = CommandConfiguration(abstract: "Flowing Particles :)")
    
    @Argument(help: "The filepath you want the output files to be created in")
    var destinationPath: String

    @Argument(default: UInt64.random(in: 0..<UInt64.max), help: "The seed used to reproduce previous random results.")
    var seed: UInt64
    
    func run() {
        let drawing = Drawing()
        drawing.begin(with: destinationPath, seed: seed)
    }
}

Quaranteen.main()
