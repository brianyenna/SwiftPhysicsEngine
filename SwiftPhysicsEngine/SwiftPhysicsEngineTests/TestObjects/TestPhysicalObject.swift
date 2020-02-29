//
//  TestPhysicalObject.swift
//  GameTests
//
//  Created by Brian Yen on 24/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

@testable import SwiftPhysicsEngine

/**
Instantiable class that conforms to the  `PhysicalObject2D` protocol.
- Note: This class is meant to facilitate the testing of the `PhysicsEngine2D`
*/
class TestPhysicalObject: PhysicalObject2D {
    var acceleration: Vector2D
    var velocity: Vector2D
    var mass: Double?
    var position: Vector2D
    var continuousForces: [Vector2D]

    init(acceleration: Vector2D,
         velocity: Vector2D,
         mass: Double?,
         position: Vector2D,
         continuousForces: [Vector2D]) {
        self.acceleration = acceleration
        self.velocity = velocity
        self.mass = mass
        self.position = position
        self.continuousForces = continuousForces
    }
}
