//
//  TestCircle.swift
//  GameTests
//
//  Created by Brian Yen on 24/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

@testable import SwiftPhysicsEngine

/**
Instantiable class that conforms to the  `CircularPhysicalObject2D` protocol.
- Note: This class is meant to facilitate the testing of the `PhysicsEngine2D`
*/
class TestCircle: TestPhysicalObject, CircularPhysicalObject2D {
    var radius: Double

    init(radius: Double,
         acceleration: Vector2D,
         velocity: Vector2D,
         mass: Double?,
         position: Vector2D,
         continuousForces: [Vector2D]) {
        self.radius = radius
        super.init(acceleration: acceleration,
                   velocity: velocity,
                   mass: mass,
                   position: position,
                   continuousForces: continuousForces)
    }
}
