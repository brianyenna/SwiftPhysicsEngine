//
//  TestRectangle.swift
//  GameTests
//
//  Created by Brian Yen on 24/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

@testable import SwiftPhysicsEngine

/**
Instantiable class that conforms to the  `RectangularPhysicalObject2D` protocol.
- Note: This class is meant to facilitate the testing of the `PhysicsEngine2D`
*/
class TestRectangle: TestPhysicalObject, RectangularPhysicalObject2D {
    var height: Double
    var width: Double

    init(height: Double,
         width: Double,
         acceleration: Vector2D,
         velocity: Vector2D,
         mass: Double?,
         position: Vector2D,
         continuousForces: [Vector2D]) {
        self.height = height
        self.width = width
        super.init(acceleration: acceleration,
                   velocity: velocity,
                   mass: mass,
                   position: position,
                   continuousForces: continuousForces)
    }
}
