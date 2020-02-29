//
//  PhyicsEngineTests+updatingCollisions.swift
//  GameTests
//
//  Created by Brian Yen on 24/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

import XCTest
@testable import SwiftPhysicsEngine

/**
 Extension of PhysicsEngineTests to test all `updateCollision` methods in
 `PhysicsEngine2D`
 */
extension PhysicsEngineTests {
    func testUpdateCollisionWithTriangularObject_translation_triangleAbove() {
        if let engine = engine, let movingCircle = movingCircle, let stationaryTriangle = stationaryTriangle {
            stationaryTriangle.point1 = Vector2D(20.0, 10.0)
            stationaryTriangle.point2 = Vector2D(10.0, 30.0)
            stationaryTriangle.point3 = Vector2D(30.0, 30.0)

            movingCircle.position = Vector2D(20.0, 35.0)
            engine.updateCollisionWithTriangularObject(movingObj: movingCircle, triObj: stationaryTriangle)
            XCTAssertEqual(movingCircle.position, Vector2D(20.0, 40.0))
        }
    }

    func testUpdateCollisionWithTriangularObject_reflection_triangleAbove() {
        if let engine = engine, let movingCircle = movingCircle, let stationaryTriangle = stationaryTriangle {
            stationaryTriangle.point1 = Vector2D(20.0, 10.0)
            stationaryTriangle.point2 = Vector2D(10.0, 30.0)
            stationaryTriangle.point3 = Vector2D(30.0, 30.0)

            movingCircle.position = Vector2D(20.0, 35.0)
            movingCircle.velocity = Vector2D(1.0, -1.0)
            engine.updateCollisionWithTriangularObject(movingObj: movingCircle, triObj: stationaryTriangle)
            XCTAssertEqual(movingCircle.velocity, Vector2D(1.0, 1.0))
        }
    }

    func testUpdateCollisionWithCircularObject_translation_otherCircleBelow() {
        if let movingCircle = movingCircle, let stationaryCircle = stationaryCircle, let engine = engine {
            stationaryCircle.radius = 10.0
            stationaryCircle.setPosition(20.0, 30.0)

            engine.updateCollisionWithCircularObject(movingObj: movingCircle, otherCircleObj: stationaryCircle)
            XCTAssertEqual(movingCircle.position, Vector2D(20.0, 10.0))
        }
    }

    func testUpdateCollisionWithCircularObject_translation_otherCircleRight() {
        if let movingCircle = movingCircle, let stationaryCircle = stationaryCircle, let engine = engine {
            stationaryCircle.radius = 10.0
            stationaryCircle.setPosition(30.0, 20.0)

            engine.updateCollisionWithCircularObject(movingObj: movingCircle, otherCircleObj: stationaryCircle)
            XCTAssertEqual(movingCircle.position, Vector2D(10.0, 20.0))
        }
    }

    func testUpdateCollisionWithCircularObject_translation_otherCircleLeft() {
        if let movingCircle = movingCircle, let stationaryCircle = stationaryCircle, let engine = engine {
            stationaryCircle.radius = 10.0
            stationaryCircle.setPosition(10.0, 20.0)

            engine.updateCollisionWithCircularObject(movingObj: movingCircle, otherCircleObj: stationaryCircle)
            XCTAssertEqual(movingCircle.position, Vector2D(30.0, 20.0))
        }
    }

    func testUpdateCollisionWithCircularObject_translation_otherCircleTop() {
        if let movingCircle = movingCircle, let stationaryCircle = stationaryCircle, let engine = engine {
            stationaryCircle.radius = 10.0
            stationaryCircle.setPosition(20.0, 10.0)

            engine.updateCollisionWithCircularObject(movingObj: movingCircle, otherCircleObj: stationaryCircle)
            XCTAssertEqual(movingCircle.position, Vector2D(20.0, 30.0))
        }
    }

    func testUpdateCollisionWithCircularObject_reflection_otherCircleRight() {
        if let movingCircle = movingCircle, let stationaryCircle = stationaryCircle, let engine = engine {
            stationaryCircle.radius = 10.0
            stationaryCircle.setPosition(40.0, 20.0)

            engine.updateCollisionWithCircularObject(movingObj: movingCircle, otherCircleObj: stationaryCircle)
            XCTAssertEqual(movingCircle.velocity, Vector2D(-1.0, 1.0))
        }
    }

    func testUpdateCollisionWithCircularObject_reflection_otherCircleLeft() {
        if let movingCircle = movingCircle, let stationaryCircle = stationaryCircle, let engine = engine {
            movingCircle.setVelocity(-1.0, 1.0)
            stationaryCircle.radius = 10.0
            stationaryCircle.setPosition(0.0, 20.0)

            engine.updateCollisionWithCircularObject(movingObj: movingCircle, otherCircleObj: stationaryCircle)
            XCTAssertEqual(movingCircle.velocity, Vector2D(1.0, 1.0))
        }
    }

    func testUpdateCollisionWithCircularObject_reflection_otherCircleTop() {
        if let movingCircle = movingCircle, let stationaryCircle = stationaryCircle, let engine = engine {
            movingCircle.setVelocity(-1.0, -1.0)
            stationaryCircle.radius = 10.0
            stationaryCircle.setPosition(20.0, 0.0)

            engine.updateCollisionWithCircularObject(movingObj: movingCircle, otherCircleObj: stationaryCircle)
            XCTAssertEqual(movingCircle.velocity, Vector2D(-1.0, 1.0))
        }
    }

    func testUpdateCollisionWithCircularObject_reflection_otherCircleBottom() {
        if let movingCircle = movingCircle, let stationaryCircle = stationaryCircle, let engine = engine {
            movingCircle.setVelocity(-1.0, 1.0)
            stationaryCircle.radius = 10.0
            stationaryCircle.setPosition(20.0, 40.0)

            engine.updateCollisionWithCircularObject(movingObj: movingCircle, otherCircleObj: stationaryCircle)
            XCTAssertEqual(movingCircle.velocity, Vector2D(-1.0, -1.0))
        }
    }

    func testUpdateCollisionWithRectangularObject_translation_BorderRight() {
        if let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle, let engine = engine {
            stationaryRectangle.setPosition(25.0, 20.0)
            engine.updateCollisionWithRectangularObject(movingObj: movingCircle, rectObj: stationaryRectangle)
            XCTAssertEqual(movingCircle.position, Vector2D(15.0, 20.0))
        }
    }

    func testUpdateCollisionWithRectangularObject_translation_BorderLeft() {
        if let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle, let engine = engine {
            stationaryRectangle.setPosition(5.0, 20.0)
            engine.updateCollisionWithRectangularObject(movingObj: movingCircle, rectObj: stationaryRectangle)
            XCTAssertEqual(movingCircle.position, Vector2D(25.0, 20.0))
        }
    }

    func testUpdateCollisionWithRectangularObject_translation_BorderTop() {
        if let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle, let engine = engine {
            stationaryRectangle.setPosition(20.0, 5.0)
            engine.updateCollisionWithRectangularObject(movingObj: movingCircle, rectObj: stationaryRectangle)
            XCTAssertEqual(movingCircle.position, Vector2D(20.0, 25.0))
        }
    }

    func testUpdateCollisionWithRectangularObject_translation_BorderBottom() {
        if let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle, let engine = engine {
            stationaryRectangle.setPosition(20.0, 25.0)
            engine.updateCollisionWithRectangularObject(movingObj: movingCircle, rectObj: stationaryRectangle)
            XCTAssertEqual(movingCircle.position, Vector2D(20.0, 15.0))
        }
    }

    func testUpdateCollisionWithRectangularObject_reflection_BorderLeft() {
        if let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle, let engine = engine {
            movingCircle.setVelocity(-1.0, 1.0)
            stationaryRectangle.setPosition(5.0, 20.0)
            engine.updateCollisionWithRectangularObject(movingObj: movingCircle, rectObj: stationaryRectangle)
            XCTAssertEqual(movingCircle.velocity, Vector2D(1.0, 1.0))
        }
    }

    func testUpdateCollisionWithRectangularObject_reflection_BorderRight() {
        if let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle, let engine = engine {
            movingCircle.setVelocity(1.0, 1.0)
            stationaryRectangle.setPosition(25.0, 20.0)
            engine.updateCollisionWithRectangularObject(movingObj: movingCircle, rectObj: stationaryRectangle)
            XCTAssertEqual(movingCircle.velocity, Vector2D(-1.0, 1.0))
        }
    }

    func testUpdateCollisionWithRectangularObject_reflection_BorderBottom() {
        if let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle, let engine = engine {
            movingCircle.setVelocity(1.0, 1.0)
            stationaryRectangle.setPosition(20.0, 25.0)
            engine.updateCollisionWithRectangularObject(movingObj: movingCircle, rectObj: stationaryRectangle)
            XCTAssertEqual(movingCircle.velocity, Vector2D(1.0, -1.0))
        }
    }

    func testUpdateCollisionWithRectangularObject_reflection_BorderTop() {
        if let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle, let engine = engine {
            movingCircle.setVelocity(1.0, -1.0)
            stationaryRectangle.setPosition(20.0, 5.0)
            engine.updateCollisionWithRectangularObject(movingObj: movingCircle, rectObj: stationaryRectangle)
            XCTAssertEqual(movingCircle.velocity, Vector2D(1.0, 1.0))
        }
    }
}
