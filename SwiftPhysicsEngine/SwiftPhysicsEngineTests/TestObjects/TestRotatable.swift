//
//  TestRotatable.swift
//  GameTests
//
//  Created by Brian Yen on 24/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

@testable import SwiftPhysicsEngine

/**
 Instantiable class that conforms to the  `RotatablePhysicalObject2D` protocol.
 - Note: This class is meant to facilitate the testing of the `PhysicsEngine2D`
 */
class TestRotatable: TestPhysicalObject, RotatablePhysicalObject2D {
    var angle: Double
    var rotationRate: Double

    init(angle: Double,
         rotationRate: Double,
         acceleration: Vector2D,
         velocity: Vector2D,
         mass: Double?,
         position: Vector2D,
         continuousForces: [Vector2D]) {
        self.angle = angle
        self.rotationRate = rotationRate
        super.init(acceleration: acceleration,
                   velocity: velocity,
                   mass: mass,
                   position: position,
                   continuousForces: continuousForces)
    }
}
