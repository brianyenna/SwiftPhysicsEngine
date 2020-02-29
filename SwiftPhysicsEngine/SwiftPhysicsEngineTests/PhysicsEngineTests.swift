//
//  PhysicsEngineTests.swift
//  GameTests
//
//  Created by Brian Yen on 12/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

import XCTest
@testable import SwiftPhysicsEngine

class PhysicsEngineTests: XCTestCase {
    var engine: PhysicsEngine2D?
    var movingCircle: TestCircle?
    var stationaryCircle: TestCircle?
    var stationaryRectangle: TestRectangle?
    var stationaryTriangle: TestTriangle?

    override func setUp() {
        super.setUp()
        engine = PhysicsEngine2D(dragCoeff: 0.01, minVecThreshold: 0.1)
        movingCircle = TestCircle(radius: 10.0,
                                  acceleration: Vector2D(0.0, 0.0),
                                  velocity: Vector2D(1.0, 1.0),
                                  mass: 1.0,
                                  position: Vector2D(20.0, 20.0),
                                  continuousForces: [Vector2D(0.0, 10.0)])

        stationaryCircle = TestCircle(radius: 10.0,
                                      acceleration: Vector2D(0.0, 0.0),
                                      velocity: Vector2D(0.0, 0.0),
                                      mass: nil,
                                      position: Vector2D(0.0, 0.0),
                                      continuousForces: [])

        stationaryRectangle = TestRectangle(height: 10.0,
                                            width: 10.0,
                                            acceleration: Vector2D(0.0, 0.0),
                                            velocity: Vector2D(0.0, 0.0),
                                            mass: nil,
                                            position: Vector2D(0.0, 0.0),
                                            continuousForces: [])

        stationaryTriangle = TestTriangle(triangleAngle: 0.0,
                                          point1: Vector2D(0.0, 0.0),
                                          point2: Vector2D(0.0, 0.0),
                                          point3: Vector2D(0.0, 0.0),
                                          size: 10.0,
                                          acceleration: Vector2D(0.0, 0.0),
                                          velocity: Vector2D(0.0, 0.0),
                                          mass: nil,
                                          position: Vector2D(0.0, 0.0),
                                          continuousForces: [])
    }

    override func tearDown() {
        engine = nil
        movingCircle = nil
        stationaryCircle = nil
        stationaryRectangle = nil
        stationaryTriangle = nil
        super.tearDown()
    }

    func testUpdateState() {
        if let engine = engine, let circle = movingCircle, let mass = circle.mass {
            circle.setAcceleration(1.0, 0.0)
            engine.updateState(obj: circle, timeInterval: 1.0)
            XCTAssertEqual(circle.position, Vector2D(21.0, 21.0))
            XCTAssertEqual(circle.velocity, Vector2D(2.0, 1.0).scalarMult(1 - engine.dragCoeff))
            XCTAssertEqual(circle.acceleration, circle.continuousForces[0].scalarMult(1 / mass))
        }
    }

    func testUpdateRotation() {
        if let engine = engine {
            let rotatableObject = TestRotatable(angle: 10.0,
                                                rotationRate: 10.0,
                                                acceleration: Vector2D(0.0, 0.0),
                                                velocity: Vector2D(0.0, 0.0),
                                                mass: nil,
                                                position: Vector2D(0.0, 0.0),
                                                continuousForces: [])
            engine.updateRotation(obj: rotatableObject, timeInterval: 1.0)
            XCTAssertEqual(rotatableObject.angle, 20.0)
            engine.updateRotation(obj: rotatableObject, timeInterval: 36.0)
            XCTAssertEqual(rotatableObject.angle, 20.0)
        }
    }

    func testGetMinimumViableVector() {
        let vec1 = Vector2D(1.0, 1.0)
        let vec2 = Vector2D(0.5, 20.0)
        let vec3 = Vector2D(20.0, 0.5)
        let vec4 = Vector2D(-0.5, 20.0)
        let vec5 = Vector2D(20.0, -0.5)
        let vec6 = Vector2D(-0.5, -0.99)

        if let engine = engine {
            XCTAssertEqual(engine.getMinimumViableVector(vec1, threshold: 1.0), Vector2D(0.0, 0.0))
            XCTAssertEqual(engine.getMinimumViableVector(vec2, threshold: 1.0), Vector2D(0.0, 20.0))
            XCTAssertEqual(engine.getMinimumViableVector(vec3, threshold: 1.0), Vector2D(20.0, 0.0))
            XCTAssertEqual(engine.getMinimumViableVector(vec4, threshold: 1.0), Vector2D(0.0, 20.0))
            XCTAssertEqual(engine.getMinimumViableVector(vec5, threshold: 1.0), Vector2D(20.0, 0.0))
            XCTAssertEqual(engine.getMinimumViableVector(vec6, threshold: 1.0), Vector2D(0.0, 0.0))
        }
    }

    func testCheckCollidingObjects_circleToCircle_noCollision() {
        if let engine = engine, let movingCircle = movingCircle, let stationaryCircle = stationaryCircle {
            stationaryCircle.position = Vector2D(0.0, 20.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: stationaryCircle, obj2: movingCircle))

            stationaryCircle.position = Vector2D(40.0, 20.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: stationaryCircle, obj2: movingCircle))

            stationaryCircle.position = Vector2D(20.0, 0.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: stationaryCircle, obj2: movingCircle))

            stationaryCircle.position = Vector2D(20.0, 40.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: stationaryCircle, obj2: movingCircle))
        }
    }

    func testCheckCollidingObjects_circleToCircle_collision() {
        if let engine = engine, let movingCircle = movingCircle, let stationaryCircle = stationaryCircle {
            stationaryCircle.position = Vector2D(10.0, 20.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: stationaryCircle, obj2: movingCircle))

            stationaryCircle.position = Vector2D(30.0, 20.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: stationaryCircle, obj2: movingCircle))

            stationaryCircle.position = Vector2D(20.0, 10.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: stationaryCircle, obj2: movingCircle))

            stationaryCircle.position = Vector2D(20.0, 30.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: stationaryCircle, obj2: movingCircle))
        }
    }

    func testCheckCollidingObjects_circleToRectangle_noCollision() {
        if let engine = engine, let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle {
            stationaryRectangle.position = Vector2D(0.0, 20.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryRectangle))

            stationaryRectangle.position = Vector2D(40.0, 20.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryRectangle))

            stationaryRectangle.position = Vector2D(20.0, 0.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryRectangle))

            stationaryRectangle.position = Vector2D(20.0, 40.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryRectangle))
        }
    }

    func testCheckCollidingObjects_circleToRectangle_collision() {
        if let engine = engine, let movingCircle = movingCircle, let stationaryRectangle = stationaryRectangle {
            stationaryRectangle.position = Vector2D(5.0, 20.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryRectangle))

            stationaryRectangle.position = Vector2D(25.0, 20.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryRectangle))

            stationaryRectangle.position = Vector2D(20.0, 5.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryRectangle))

            stationaryRectangle.position = Vector2D(20.0, 25.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryRectangle))
        }
    }

    func testCheckCollidingObjects_circleToTriangle_noCollision() {
        if let engine = engine, let movingCircle = movingCircle, let stationaryTriangle = stationaryTriangle {
            // Left
            stationaryTriangle.point1 = Vector2D(10.0, 10.0)
            stationaryTriangle.point2 = Vector2D(-10.0, 20.0)
            stationaryTriangle.point3 = Vector2D(10.0, 30.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryTriangle))

            // Right
            stationaryTriangle.point1 = Vector2D(30.0, 10.0)
            stationaryTriangle.point2 = Vector2D(30.0, 30.0)
            stationaryTriangle.point3 = Vector2D(50.0, 20.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryTriangle))

            // Top
            stationaryTriangle.point1 = Vector2D(20.0, -10.0)
            stationaryTriangle.point2 = Vector2D(10.0, 10.0)
            stationaryTriangle.point3 = Vector2D(30.0, 10.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryTriangle))

            // Bottom
            stationaryTriangle.point1 = Vector2D(10.0, 30.0)
            stationaryTriangle.point2 = Vector2D(20.0, 50.0)
            stationaryTriangle.point3 = Vector2D(30.0, 30.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryTriangle))
        }
    }

    func testCheckCollidingObjects_circleToTriangle_collision() {
        if let engine = engine, let movingCircle = movingCircle, let stationaryTriangle = stationaryTriangle {
            // Vertex Inside Circle
            stationaryTriangle.point1 = Vector2D(20.0, 25.0)
            stationaryTriangle.point2 = Vector2D(10.0, 45.0)
            stationaryTriangle.point3 = Vector2D(30.0, 45.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryTriangle))

            // Circle Centre Within Triangle
            stationaryTriangle.point1 = Vector2D(20.0, 10.0)
            stationaryTriangle.point2 = Vector2D(10.0, 30.0)
            stationaryTriangle.point3 = Vector2D(30.0, 30.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryTriangle))

            // Circle Intersects With Edge
            stationaryTriangle.point1 = Vector2D(30.0, 20.0)
            stationaryTriangle.point2 = Vector2D(20.0, 40.0)
            stationaryTriangle.point3 = Vector2D(40.0, 40.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: movingCircle, obj2: stationaryTriangle))
        }
    }

    func testCheckCollidingObjects_rectangleToRectangle_noCollision() {
        if let engine = engine, let stationaryRectangle = stationaryRectangle {
            let otherRect1 = TestRectangle(height: 10.0,
                                           width: 10.0,
                                           acceleration: Vector2D(0.0, 0.0),
                                           velocity: Vector2D(0.0, 0.0),
                                           mass: nil,
                                           position: Vector2D(10.0, 0.0),
                                           continuousForces: [])
            XCTAssertFalse(engine.checkCollidingObjects(obj1: stationaryRectangle, obj2: otherRect1))

            let otherRect2 = TestRectangle(height: 10.0,
                                           width: 10.0,
                                           acceleration: Vector2D(0.0, 0.0),
                                           velocity: Vector2D(0.0, 0.0),
                                           mass: nil,
                                           position: Vector2D(0.0, 10.0),
                                           continuousForces: [])
            XCTAssertFalse(engine.checkCollidingObjects(obj1: stationaryRectangle, obj2: otherRect2))
        }
    }

    func testCheckCollidingObjects_rectangleToRectangle_collision() {
        if let engine = engine, let stationaryRectangle = stationaryRectangle {
            let otherRect1 = TestRectangle(height: 10.0,
                                           width: 10.0,
                                           acceleration: Vector2D(0.0, 0.0),
                                           velocity: Vector2D(0.0, 0.0),
                                           mass: nil,
                                           position: Vector2D(5.0, 0.0),
                                           continuousForces: [])
            XCTAssertTrue(engine.checkCollidingObjects(obj1: stationaryRectangle, obj2: otherRect1))

            let otherRect2 = TestRectangle(height: 10.0,
                                           width: 10.0,
                                           acceleration: Vector2D(0.0, 0.0),
                                           velocity: Vector2D(0.0, 0.0),
                                           mass: nil,
                                           position: Vector2D(0.0, 5.0),
                                           continuousForces: [])
            XCTAssertTrue(engine.checkCollidingObjects(obj1: stationaryRectangle, obj2: otherRect2))
        }
    }

    func testCheckCollidingObjects_triangleToTriangle_noCollision() {
        if let engine = engine, let stationaryTriangle = stationaryTriangle {
            stationaryTriangle.point1 = Vector2D(20.0, 10.0)
            stationaryTriangle.point2 = Vector2D(10.0, 30.0)
            stationaryTriangle.point3 = Vector2D(30.0, 30.0)

            let otherTriangle = TestTriangle(triangleAngle: 0.0,
                                             point1: Vector2D(0.0, 0.0),
                                             point2: Vector2D(0.0, 0.0),
                                             point3: Vector2D(0.0, 0.0),
                                             size: 10.0,
                                             acceleration: Vector2D(0.0, 0.0),
                                             velocity: Vector2D(0.0, 0.0),
                                             mass: nil,
                                             position: Vector2D(0.0, 0.0),
                                             continuousForces: [])

            // Left Edge
            otherTriangle.point1 = Vector2D(10.0, 30.0)
            otherTriangle.point2 = Vector2D(20.0, 10.0)
            otherTriangle.point3 = Vector2D(0.0, 10.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: stationaryTriangle, obj2: otherTriangle))

            // Right Edge
            otherTriangle.point1 = Vector2D(30.0, 30.0)
            otherTriangle.point2 = Vector2D(40.0, 10.0)
            otherTriangle.point3 = Vector2D(20.0, 10.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: stationaryTriangle, obj2: otherTriangle))

            // Bottom Edge
            otherTriangle.point1 = Vector2D(20.0, 50.0)
            otherTriangle.point2 = Vector2D(30.0, 30.0)
            otherTriangle.point3 = Vector2D(10.0, 30.0)
            XCTAssertFalse(engine.checkCollidingObjects(obj1: stationaryTriangle, obj2: otherTriangle))
        }
    }

    func testCheckCollidingObjects_triangleToTriangle_collision() {
        if let engine = engine, let stationaryTriangle = stationaryTriangle {
            stationaryTriangle.point1 = Vector2D(20.0, 10.0)
            stationaryTriangle.point2 = Vector2D(10.0, 30.0)
            stationaryTriangle.point3 = Vector2D(30.0, 30.0)

            let otherTriangle = TestTriangle(triangleAngle: 0.0,
                                             point1: Vector2D(0.0, 0.0),
                                             point2: Vector2D(0.0, 0.0),
                                             point3: Vector2D(0.0, 0.0),
                                             size: 10.0,
                                             acceleration: Vector2D(0.0, 0.0),
                                             velocity: Vector2D(0.0, 0.0),
                                             mass: nil,
                                             position: Vector2D(0.0, 0.0),
                                             continuousForces: [])

            // Centre of Triangle Within Other Triangle
            otherTriangle.point1 = Vector2D(20.0, 30.0)
            otherTriangle.point2 = Vector2D(30.0, 10.0)
            otherTriangle.point3 = Vector2D(10.0, 10.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: stationaryTriangle, obj2: otherTriangle))

            // 2 Sides Intersect With 1 Side of Other triangle
            otherTriangle.point1 = Vector2D(20.0, 40.0)
            otherTriangle.point2 = Vector2D(30.0, 20.0)
            otherTriangle.point3 = Vector2D(10.0, 20.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: stationaryTriangle, obj2: otherTriangle))

            otherTriangle.point1 = Vector2D(25.0, 30.0)
            otherTriangle.point2 = Vector2D(35.0, 10.0)
            otherTriangle.point3 = Vector2D(15.0, 10.0)
            XCTAssertTrue(engine.checkCollidingObjects(obj1: stationaryTriangle, obj2: otherTriangle))
        }
    }

    /**
     Note that a quirk of the algorithm is that it considers 2 collinear lines to be non-intersecting.
     */
    func testCheckLineSegmentsIntersectAtAPoint_noIntersection() {
        if let engine = engine {
            // 2 Parallel Lines
            var point1 = Vector2D(0.0, 0.0)
            var point2 = Vector2D(1.0, 0.0)
            var point3 = Vector2D(0.0, 1.0)
            var point4 = Vector2D(1.0, 1.0)
            XCTAssertFalse(engine.checkLineSegmentsIntersectAtAPoint(point1: point1,
                                                                     point2: point2,
                                                                     point3: point3,
                                                                     point4: point4))

            // 2 Collinear Lines
            point1 = Vector2D(0.0, 0.0)
            point2 = Vector2D(1.0, 0.0)
            point3 = Vector2D(0.0, 0.0)
            point4 = Vector2D(1.0, 0.0)
            XCTAssertFalse(engine.checkLineSegmentsIntersectAtAPoint(point1: point1,
                                                                     point2: point2,
                                                                     point3: point3,
                                                                     point4: point4))

            // Non-intersecting Line Segments, Intersecting Lines (Infinite)
            // Checks that the intersection check is only for the line segment and not the whole infinite line
            point1 = Vector2D(0.0, 0.0)
            point2 = Vector2D(1.0, 1.0)
            point3 = Vector2D(0.0, 5.0)
            point4 = Vector2D(5.0, 0.0)
            XCTAssertFalse(engine.checkLineSegmentsIntersectAtAPoint(point1: point1,
                                                                     point2: point2,
                                                                     point3: point3,
                                                                     point4: point4))
        }
    }

    func testCheckLineSegmentsIntersectAtAPoint_intersection() {
        if let engine = engine {
            let point1 = Vector2D(0.0, 0.0)
            let point2 = Vector2D(1.0, 1.0)
            let point3 = Vector2D(0.0, 1.0)
            let point4 = Vector2D(1.0, 0.0)
            XCTAssertTrue(engine.checkLineSegmentsIntersectAtAPoint(point1: point1,
                                                                    point2: point2,
                                                                    point3: point3,
                                                                    point4: point4))
        }
    }
}
