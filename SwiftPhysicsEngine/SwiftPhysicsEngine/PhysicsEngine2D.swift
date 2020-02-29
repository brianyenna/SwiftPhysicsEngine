//
//  PhysicsEngine2D.swift
//  Game
//
//  Created by Brian Yen on 12/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

import UIKit

/**
 A Physics Engine to perform mathematical calculations and update the physical
 state of objects. This Physics Engine only applies to 2-Dimensional simulations.
 - Note: The Physics Engine's coordinate system is same as that of the coordinate
 system used by iOS. This means that x coordinate increases rightwards, and y coordinate
 increases downwards.
 - Note: This file contains all the code for updating of state and other miscellaneous functions
 related to the `PhysicsEngine2D`. The code for collision checking is in
 `PhysicsEngine2D+checkCollision.swift`
 */
class PhysicsEngine2D {
    let dragCoeff: Double // Simulates drag in the physical world
    let minVecThreshold: Double // Value used to threshold vector component values

    init(dragCoeff: Double, minVecThreshold: Double) {
        self.dragCoeff = dragCoeff
        self.minVecThreshold = minVecThreshold
    }

    /**
     Updates the state of a `PhysicalObject2D` object based on its current
     parameters.
     - Note: when updating acceleration, this function uses the `continuousForces`
     parameter on the `PhysicalObject2D` object to determine the acceleration on the
     object in the next time instant. See `PhysicalObject2D` for an explanation on the
     purpose of the `continuousForces` field.
     */
    func updateState(obj: PhysicalObject2D, timeInterval: CFTimeInterval, subjectToDrag: Bool = true) {
        // Update Position
        let newPosition = obj.position + obj.velocity.scalarMult(timeInterval)
        obj.position = newPosition

        // Update Velocity
        var newVelocity = obj.velocity + obj.acceleration.scalarMult(timeInterval)
        if subjectToDrag {
            newVelocity = newVelocity.scalarMult(1 - dragCoeff)
        }
        obj.velocity = getMinimumViableVector(newVelocity, threshold: minVecThreshold)
        // Update acceleration (only if non-`nil`/finite mass)
        if let mass = obj.mass {
            let resultantForce = obj.continuousForces.reduce(Vector2D(0.0, 0.0)) { first, second in
                first + second
            }
            obj.acceleration = resultantForce.scalarMult(1 / mass)
        }
    }

    /**
     Updates the rotation state of a `RotatablePhysicalObject2D` object based
     on the provided `timeInterval` and the object's `rotationRate`
     */
    func updateRotation(obj: RotatablePhysicalObject2D, timeInterval: CFTimeInterval) {
        let angleChange = obj.rotationRate * timeInterval
        obj.angle = (obj.angle + angleChange).truncatingRemainder(dividingBy: 360)
    }

    /**
     If any component of the vector is too small (i.e. within the threshold), then the
     component is set to zero. This function basically provides thresholding on the vector.
     */
    func getMinimumViableVector(_ vector: Vector2D, threshold: Double) -> Vector2D {
        var xComponent = vector.first
        var yComponent = vector.second
        if (xComponent <= threshold) && (xComponent >= -threshold) {
            xComponent = 0.0
        }

        if (yComponent <= threshold) && (yComponent >= -threshold) {
            yComponent = 0.0
        }
        return Vector2D(xComponent, yComponent)
    }

    /**
    Updates the state of a moving circular object after colliding with a triangular object.
    - Note: Several assumptions are made in this function:
       - `triObj` has infinite mass (The code for finite mass collisions has yet to be implemented)
       - perfectly elastic collision occurs
    - Note: This mutates the state of `movingObj`
    */
    func updateCollisionWithTriangularObject(movingObj: CircularPhysicalObject2D,
                                             triObj: TriangularPhysicalObject2D) {
        guard triObj.mass == nil else {
            print("Finite Mass Collision Not Implemented Yet")
            return
        }

        // `triObj` has infinite mass
        let edges: [[Vector2D]] = [[triObj.point1, triObj.point2],
                                   [triObj.point2, triObj.point3],
                                   [triObj.point3, triObj.point1]]

        var minTransDist = Double.infinity
        var nVec = Vector2D(0.0, 0.0)

        do {
            for edgeEndPoints in edges {
                let edge = edgeEndPoints[1] - edgeEndPoints[0]
                let inwardNormVec = try Vector2D(edge.second, -edge.first).normalize()
                let dist = (movingObj.position - edgeEndPoints[0]).dot(inwardNormVec)

                // Centre of Circle outside of Triangle
                if dist < 0 {
                    minTransDist = movingObj.radius + dist
                    nVec = inwardNormVec.scalarMult(-1)
                    break
                }

                // Centre of Circle Inside Triangle (find minimum translation distance)
                if dist < minTransDist {
                    minTransDist = dist
                    nVec = inwardNormVec.scalarMult(-1)
                }
            }
        } catch VectorError.normalizeZeroLengthError {
            print("Unable to normalize vector: vector has zero length")
        } catch {
            print("An unexpected error occured")
        }

        // Correct Intersection Position Error
        let correctedPosition = movingObj.position + nVec.scalarMult(minTransDist)
        movingObj.position = correctedPosition

        // Update Velocity Vector
        updateReflectionVelocity(movingObj: movingObj, nVec: nVec)
    }

    /**
     Updates the state of a moving circular object after colliding with another
     circular object.
     - Note: Several assumptions are made in this function:
        - `otherCircleObj` has infinite mass (The code for finite mass collisions has yet to be implemented)
        - both `movingObj` and `otherCircleObj` are circular objects
        - perfectly elastic collision occurs
     - Note: This mutates the state of `movingObj`
     */
    func updateCollisionWithCircularObject(movingObj: CircularPhysicalObject2D,
                                           otherCircleObj: CircularPhysicalObject2D) {
        guard otherCircleObj.mass == nil else {
            print("Finite Mass Collision Not Implemented Yet")
            return
        }

        // `otherCircleObj` has infinite mass
        do {
            // Move `movingObj` away from `otherObj` by length of intersection
            correctIntersectionPositionError(movingObj: movingObj,
                                             otherCircleObj: otherCircleObj)

            // Update Velocity vector (reflection off `otherCircleObj`)
            let nVec = try (otherCircleObj.position - movingObj.position).normalize()
            updateReflectionVelocity(movingObj: movingObj, nVec: nVec)
        } catch VectorError.normalizeZeroLengthError {
            print("Unable to normalize vector: vector has zero length")
        } catch {
            print("An unexpected error occured")
        }
    }

    /**
     Helper function that updates the state of `movingObj` by moving `movingObj` away from
     `otherObj` by the length of intersection. This ensures that even if at a certain time step the 2 objects
     are intersecting, they will be disentangled before the reflection vector is calculated.
     - Note: This mutates the state of `movingObj`
     */
    private func correctIntersectionPositionError(movingObj: CircularPhysicalObject2D,
                                                  otherCircleObj: CircularPhysicalObject2D) {
        let distDeltaVec = otherCircleObj.position - movingObj.position
        let distDelta = distDeltaVec.length
        let scalingFactor = ((movingObj.radius + otherCircleObj.radius) - distDelta) / distDelta
        let minTranslationVec = distDeltaVec.scalarMult(scalingFactor)
        let newPositionVec = movingObj.position - minTranslationVec
        movingObj.position = newPositionVec
    }

    /**
     Helper function that updates the velocity vector of `movingObj` by calculating the reflection vector
     after colliding with another object, where the point of collision is determined by the normal vector `nVec`.
     - Note: This mutates the state of `movingObj`
     - Note: The formula for calculating the reflection vector is 𝑟=𝑑−2(𝑑⋅𝑛)𝑛, and the formula was obtained
     from https://math.stackexchange.com/questions/13261/how-to-get-a-reflection-vector
     */
    private func updateReflectionVelocity(movingObj: CircularPhysicalObject2D,
                                          nVec: Vector2D) {
        let dVec = movingObj.velocity
        let rVec = dVec - nVec.scalarMult(2 * (dVec.dot(nVec)))
        movingObj.velocity = rVec
    }

    /**
    Updates the state of a moving circular object after colliding with another
    rectangular object.
    - Note: Several assumptions are made in this function:
       - `otherCircleObj` has infinite mass (The code for finite mass collisions has yet to be implemented)
       - perfectly elastic collision occurs
    - Note: This mutates the state of `movingObj`
    */
    func updateCollisionWithRectangularObject(movingObj: CircularPhysicalObject2D,
                                              rectObj: RectangularPhysicalObject2D) {
        guard rectObj.mass == nil else {
            print("Finite Mass Collision Not Implemented Yet")
            return
        }

        // `rectObj` has infinite mass
        let vectors = getNormalVectorAndMinTranslationVector(movingObj: movingObj,
                                                             rectObj: rectObj)
        let nVec = vectors[0]
        let minTranslationVec = vectors[1]

        // Move `movingObj` away from `rectObj` by length of intersection
        let newPositionVec = movingObj.position + minTranslationVec
        movingObj.position = newPositionVec

        // Update Velocity Vector (Reflection)
        updateReflectionVelocity(movingObj: movingObj, nVec: nVec)
    }

    /**
     Helper function to get the normal vector of collision and translation vector to correct for intersection.
     This function is applicable only to the collision between a `CircularPhysicalObject2D` and a
     `RectangularPhysicalObject2D`.
     */
    private func getNormalVectorAndMinTranslationVector(movingObj: CircularPhysicalObject2D,
                                                        rectObj: RectangularPhysicalObject2D) -> [Vector2D] {
        // Create CGRects to quickly calculate intersection
        let movingObjRect = Utils.getCGRectFrameForCircle(xPos: movingObj.position.first,
                                                          yPos: movingObj.position.second,
                                                          radius: movingObj.radius)
        let rectObjRect = CGRect(x: rectObj.position.first,
                                 y: rectObj.position.second,
                                 width: rectObj.width,
                                 height: rectObj.height)

        let collisionBottom = rectObjRect.maxY - movingObjRect.minY
        let collisionTop = movingObjRect.maxY - rectObjRect.minY
        let collisionLeft = movingObjRect.maxX - rectObjRect.minX
        let collisionRight = rectObjRect.maxX - movingObjRect.minX

        var nVec = Vector2D(0.0, 0.0)
        let intersection = movingObjRect.intersection(rectObjRect)
        var minTranslationVec = Vector2D(0.0, 0.0)
        // Collide with Top of rectObj
        if collisionTop < collisionBottom && collisionTop < collisionLeft && collisionTop < collisionRight {
            nVec = Vector2D(0.0, 1.0)
            minTranslationVec = Vector2D(0.0, -Double(intersection.height))
        }
        // Collide with Bottom of rectObj
        if collisionBottom < collisionTop && collisionBottom < collisionLeft && collisionBottom < collisionRight {
            nVec = Vector2D(0.0, -1.0)
            minTranslationVec = Vector2D(0.0, Double(intersection.height))
        }
        // Collide with Left of rectObj
        if collisionLeft < collisionRight && collisionLeft < collisionTop && collisionLeft < collisionBottom {
            nVec = Vector2D(-1.0, 0.0)
            minTranslationVec = Vector2D(-Double(intersection.width), 0.0)
        }
        // Collide with Right of rectObj
        if collisionRight < collisionLeft && collisionRight < collisionTop && collisionRight < collisionBottom {
            nVec = Vector2D(1.0, 0.0)
            minTranslationVec = Vector2D(Double(intersection.width), 0.0)
        }

        return [nVec, minTranslationVec]
    }
}
