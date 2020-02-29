//
//  PhysicalObject2D.swift
//  Game
//
//  Created by Brian Yen on 12/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

/**
 Objects that conform to this protocol are 2-Dimensional.
 These objects can be manipulated by and have calculations
 done by the `PhysicsEngine2D` class.
 - Note: The fields in `PhysicalObject2D` are relatively
 self-explanatory with the exception of `continuousForces`.
 The idea behind the implementation is as such: the `acceleration`
 refers to the instantaneous acceleration on the object, and will no longer
 act on the object at the next time instant. However, some forces such
 as gravity act on an object over a span of time. Add these forces
 to the `continuousForces` array for the length of time that
 the force is acting on the object so that the PhysicsEngine will be
 able to update the `acceleration` for the next time instant. 
 */
protocol PhysicalObject2D: AnyObject {
    var acceleration: Vector2D { get set }
    var velocity: Vector2D { get set }
    var mass: Double? { get set }
    var position: Vector2D { get set }

    // Array of vectors that represent forces always acting on an object
    var continuousForces: [Vector2D] { get set }
}

/** Includes convenience functions to set the vector parameters of any  `PhysicalObject2D` object. */
extension PhysicalObject2D {
    func setAcceleration(_ first: Double, _ second: Double) {
        acceleration = Vector2D(first, second)
    }

    func setVelocity(_ first: Double, _ second: Double) {
        velocity = Vector2D(first, second)
    }

    func setPosition(_ first: Double, _ second: Double) {
        position = Vector2D(first, second)
    }
}
