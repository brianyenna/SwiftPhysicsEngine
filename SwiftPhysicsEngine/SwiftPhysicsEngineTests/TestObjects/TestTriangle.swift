//
//  TestTriangle.swift
//  GameTests
//
//  Created by Brian Yen on 24/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

@testable import SwiftPhysicsEngine

/**
Instantiable class that conforms to the  `TriangularPhysicalObject2D` protocol.
- Note: This class is meant to facilitate the testing of the `PhysicsEngine2D`
*/
class TestTriangle: TestPhysicalObject, TriangularPhysicalObject2D {
    var triangleAngle: Double
    var point1: Vector2D
    var point2: Vector2D
    var point3: Vector2D
    var size: Double

    init(triangleAngle: Double,
         point1: Vector2D,
         point2: Vector2D,
         point3: Vector2D,
         size: Double,
         acceleration: Vector2D,
         velocity: Vector2D,
         mass: Double?,
         position: Vector2D,
         continuousForces: [Vector2D]) {
        self.triangleAngle = triangleAngle
        self.point1 = point1
        self.point2 = point2
        self.point3 = point3
        self.size = size
        super.init(acceleration: acceleration,
                   velocity: velocity,
                   mass: mass,
                   position: position,
                   continuousForces: continuousForces)
    }
}
