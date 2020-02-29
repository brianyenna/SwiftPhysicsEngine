//
//  CircularPhysicalObject2D.swift
//  Game
//
//  Created by Brian Yen on 12/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

/**
 Objects that conform to this protocol are circular and are
 2-Dimensional.
 */
protocol CircularPhysicalObject2D: PhysicalObject2D {
    var radius: Double { get set }
}
