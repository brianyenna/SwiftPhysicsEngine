//
//  TriangularPhysicalObject2D.swift
//  Game
//
//  Created by Brian Yen on 23/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

/**
 Objects that conform to this protocol are triangular and are
 2-Dimensional.
 - Note: Points 1-3 must be in anti-clockwise order when viewed
 on the iOS coordinate system (x increasing rightwards, y increasing downwards)
 - Note: Points 1-3 represent the coordinates of the 3 vertices
 of the triangle **after** rotation by `triangleAngle`
 - Note: `triangleAngle` is in degrees and represents the clockwise rotation
 with respect to the centroid (if viewed in the iOS coordinate system)
 - Note: The `position` field in `PhysicalObject2D` is interpreted
 as the centroid for the `TriangularPhysicalObject2D`
 */
protocol TriangularPhysicalObject2D: PhysicalObject2D {
    var triangleAngle: Double { get set }
    var point1: Vector2D { get set }
    var point2: Vector2D { get set }
    var point3: Vector2D { get set }
    var size: Double { get set }
}
