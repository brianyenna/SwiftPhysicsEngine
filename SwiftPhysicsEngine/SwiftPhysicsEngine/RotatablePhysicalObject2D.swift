//
//  RotatablePhysicalObject2D.swift
//  Game
//
//  Created by Brian Yen on 13/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

/**
Objects that conform to this protocol are rotatable and are
2-Dimensional.
*/
protocol RotatablePhysicalObject2D: PhysicalObject2D {
    var angle: Double { get set } // in degrees, not radians
    var rotationRate: Double { get set }
}
