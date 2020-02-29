//
//  Vector2D.swift
//  Game
//
//  Created by Brian Yen on 12/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

import Foundation

/**
 Class to represent 2-Dimensional Vectors.
 - Note: The components within the Vector2D class are not called
 `xCoord` and `yCoord` (or whatever variant) because the struct is
 meant to be as general as possible (meaning that the axes may not
 necessarily be aligned to the x-y coordinate system)
 */
struct Vector2D: Equatable, Codable {
    var first: Double
    var second: Double
    var length: Double {
        (first * first + second * second).squareRoot()
    }

    init(_ first: Double, _ second: Double) {
        self.first = first
        self.second = second
    }

    /** For vector addition.  */
    static func + (lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(lhs.first + rhs.first,
                 lhs.second + rhs.second)
    }

    /** For vector subtraction. Not commutative. */
    static func - (lhs: Vector2D, rhs: Vector2D) -> Vector2D {
        Vector2D(lhs.first - rhs.first,
                 lhs.second - rhs.second)
    }

    /** For scalar multiplication*/
    func scalarMult(_ scalar: Double) -> Vector2D {
        Vector2D(first * scalar, second * scalar)
    }

    /** For calculatign dot product. */
    func dot(_ otherVec: Vector2D) -> Double {
        first * otherVec.first + second * otherVec.second
    }

    /**
     For normalizing the vector to a unit vector.
     - throws: normalizeZeroLengthError if the vector has zero length (and therefore
     cannot be normalized)
     */
    func normalize() throws -> Vector2D {
        let threshold = 0.000_001
        if (length >= -threshold) && (length <= threshold) {
            throw VectorError.normalizeZeroLengthError
        }

        return Vector2D(first / length,
                        second / length)
    }

    /**
     Rotates the vector anti-clockwise about a point.
     - Note: the rotation angle is specified in degrees.
     - Returns: the rotated vector
     */
    func rotate(about centre: Vector2D, by rotationAngleDegrees: Double) -> Vector2D {
        let rotationAngleRadians = (rotationAngleDegrees * .pi) / 180
        let transVec = Vector2D(first - centre.first,
                                second - centre.second)
        let rotatedVec = Vector2D(cos(rotationAngleRadians) * transVec.first -
                                    sin(rotationAngleRadians) * transVec.second,
                                  sin(rotationAngleRadians) * transVec.first +
                                    cos(rotationAngleRadians) * transVec.second)
        return rotatedVec + centre
    }

    /**
     Returns the distance between the current vector and `other`
     */
    func distanceTo(other: Vector2D) -> Double {
        let xDist = first - other.first
        let yDist = second - other.second
        return sqrt(xDist * xDist + yDist * yDist)
    }
}

/** Errors for the Vector2D class. */
enum VectorError: Error {
    case normalizeZeroLengthError
}
