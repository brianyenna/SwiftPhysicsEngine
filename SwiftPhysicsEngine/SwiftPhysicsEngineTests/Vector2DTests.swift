//
//  Vector2DTests.swift
//  GameTests
//
//  Created by Brian Yen on 12/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

import XCTest
@testable import SwiftPhysicsEngine

class Vector2DTests: XCTestCase {
    let accuracyThreshold: Double = 0.000_1
    var vec1: Vector2D?
    var vec2: Vector2D?
    var vec3: Vector2D?

    override func setUp() {
        super.setUp()
        vec1 = Vector2D(1.0, 1.0)
        vec2 = Vector2D(0.0, 0.0)
        vec3 = Vector2D(-1.0, 1.0)
    }

    override func tearDown() {
        vec1 = nil
        vec2 = nil
        vec3 = nil
        super.tearDown()
    }

    func testEquals() {
        if let vec1 = vec1, let vec2 = vec2, let vec3 = vec3 {
            XCTAssertEqual(vec1, Vector2D(1.0, 1.0))
            XCTAssertEqual(vec2, Vector2D(0.0, 0.0))
            XCTAssertEqual(vec3, Vector2D(-1.0, 1.0))
        }
    }

    func testAdd() {
        if let vec1 = vec1, let vec2 = vec2, let vec3 = vec3 {
            XCTAssertEqual(vec1 + vec2, Vector2D(1.0, 1.0))
            XCTAssertEqual(vec2 + vec3, Vector2D(-1.0, 1.0))
            XCTAssertEqual(vec1 + vec3, Vector2D(0.0, 2.0))
        }
    }

    func testSub() {
        if let vec1 = vec1, let vec2 = vec2, let vec3 = vec3 {
            XCTAssertEqual(vec1 - vec2, Vector2D(1.0, 1.0))
            XCTAssertEqual(vec2 - vec3, Vector2D(1.0, -1.0))
            XCTAssertEqual(vec1 - vec3, Vector2D(2.0, 0.0))
        }
    }

    func testScalarMult() {
        if let vec1 = vec1, let vec2 = vec2, let vec3 = vec3 {
            XCTAssertEqual(vec1.scalarMult(3.0), Vector2D(3.0, 3.0))
            XCTAssertEqual(vec2.scalarMult(0.0), Vector2D(0.0, 0.0))
            XCTAssertEqual(vec3.scalarMult(-3.0), Vector2D(3.0, -3.0))
        }
    }

    func testDot() {
        if let vec1 = vec1, let vec2 = vec2, let vec3 = vec3 {
            XCTAssertEqual(vec1.dot(vec2), 0.0)
            XCTAssertEqual(vec2.dot(vec3), 0.0)
            XCTAssertEqual(vec1.dot(vec3), 0.0)
        }
    }

    func testNormalize_normalizable() {
        if let vec1 = vec1, let vec3 = vec3,
            let normVec1 = try? vec1.normalize(),
            let normVec3 = try? vec3.normalize() {
                XCTAssertEqual(normVec1.length, 1.0, accuracy: accuracyThreshold)
                XCTAssertEqual(normVec3.length, 1.0, accuracy: accuracyThreshold)
        }
    }

    func testNormalize_notNormalizable() {
        if let vec2 = vec2 {
            XCTAssertThrowsError(try vec2.normalize(),
                                 "Vector of length 0 should not be normalizable") { error in
                XCTAssertEqual(error as? VectorError, VectorError.normalizeZeroLengthError)
            }
        }
    }

    func testRotate_rotateAboutOrigin() {
        if let vec1 = vec1, let vec2 = vec2, let vec3 = vec3 {
            let rotatedVec1 = vec1.rotate(about: Vector2D(0.0, 0.0), by: 90.0)
            XCTAssertEqual(rotatedVec1.first, -1.0, accuracy: accuracyThreshold)
            XCTAssertEqual(rotatedVec1.second, 1.0, accuracy: accuracyThreshold)

            let rotatedVec2 = vec2.rotate(about: Vector2D(0.0, 0.0), by: 90.0)
            XCTAssertEqual(rotatedVec2.first, 0.0, accuracy: accuracyThreshold)
            XCTAssertEqual(rotatedVec2.second, 0.0, accuracy: accuracyThreshold)

            let rotatedVec3 = vec3.rotate(about: Vector2D(0.0, 0.0), by: 180.0)
            XCTAssertEqual(rotatedVec3.first, 1.0, accuracy: accuracyThreshold)
            XCTAssertEqual(rotatedVec3.second, -1.0, accuracy: accuracyThreshold)
        }
    }

    func testRotate_rotateAboutOtherPoint() {
        let tobeRotatedVec1 = Vector2D(2.0, 1.0)
        let pivotVec1 = Vector2D(1.0, 1.0)
        let rotatedVec1 = tobeRotatedVec1.rotate(about: pivotVec1, by: 90.0)
        XCTAssertEqual(rotatedVec1.first, 1.0, accuracy: accuracyThreshold)
        XCTAssertEqual(rotatedVec1.second, 2.0, accuracy: accuracyThreshold)

        let tobeRotatedVec2 = Vector2D(3.0, 4.0)
        let pivotVec2 = Vector2D(2.0, 3.0)
        let rotatedVec2 = tobeRotatedVec2.rotate(about: pivotVec2, by: 90.0)
        XCTAssertEqual(rotatedVec2.first, 1.0, accuracy: accuracyThreshold)
        XCTAssertEqual(rotatedVec2.second, 4.0, accuracy: accuracyThreshold)

        let tobeRotatedVec3 = Vector2D(3.0, 2.0)
        let pivotVec3 = Vector2D(2.0, 3.0)
        let rotatedVec3 = tobeRotatedVec3.rotate(about: pivotVec3, by: 270.0)
        XCTAssertEqual(rotatedVec3.first, 1.0, accuracy: accuracyThreshold)
        XCTAssertEqual(rotatedVec3.second, 2.0, accuracy: accuracyThreshold)
    }

    func testDistanceTo() {
        let vec1 = Vector2D(0.0, 0.0)
        let vec2 = Vector2D(1.0, 1.0)
        let vec3 = Vector2D(-1.0, 1.0)
        let vec4 = Vector2D(1.0, -1.0)
        XCTAssertEqual(vec1.distanceTo(other: vec2), sqrt(2), accuracy: accuracyThreshold)
        XCTAssertEqual(vec1.distanceTo(other: vec3), sqrt(2), accuracy: accuracyThreshold)
        XCTAssertEqual(vec1.distanceTo(other: vec4), sqrt(2), accuracy: accuracyThreshold)
    }
}
