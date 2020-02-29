//
//  PhysicsEngine2D+checkCollision.swift
//  Game
//
//  Created by Brian Yen on 27/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

import UIKit

/**
 All object collision code and their helper functions for `PhysicsEngine2D`.
 */
extension PhysicsEngine2D {
    /**
     Function to check if 2 `CircularPhysicalObject2D` are colliding. Logic is specific to
     circular object collision.
     - Returns: `true` if the objects are colliding, `false` otherwise.
     */
    func checkCollidingObjects(obj1: CircularPhysicalObject2D, obj2: CircularPhysicalObject2D) -> Bool {
        let obj1XPos = obj1.position.first
        let obj1YPos = obj1.position.second

        let obj2XPos = obj2.position.first
        let obj2YPos = obj2.position.second

        let distBetweenObj = pow(Decimal(obj1XPos - obj2XPos), 2) + pow(Decimal(obj1YPos - obj2YPos), 2)
        let minDistBetweenObj = pow(Decimal(obj1.radius + obj2.radius), 2)

        if distBetweenObj < minDistBetweenObj {
            return true
        } else {
            return false
        }
    }

    /**
     Function to check if a `CiruclarPhysicalObject2D` and a `RectangularPhysicalObject2D`
     are colliding. Logic is specific to a circular and rectangular object collision.
     - Returns: `true` if the objects are colliding, `false` otherwise.
     */
    func checkCollidingObjects(obj1: CircularPhysicalObject2D, obj2: RectangularPhysicalObject2D) -> Bool {
        let obj1Rect = Utils.getCGRectFrameForCircle(xPos: obj1.position.first,
                                                     yPos: obj1.position.second,
                                                     radius: obj1.radius)
        let obj2Rect = CGRect(x: obj2.position.first,
                              y: obj2.position.second,
                              width: obj2.width,
                              height: obj2.height)

        return obj1Rect.intersects(obj2Rect)
    }

    /**
    Function to check if a `CircularPhysicalObject2D` and a `TriangularPhysicalObject2D`
    are colliding. Logic is specific to a circular and triangular object collision.
    - Returns: `true` if the objects are colliding, `false` otherwise.
    - Note: The algorithm used is obtained from http://www.phatcode.net/articles.php?id=459
    */
    func checkCollidingObjects(obj1: CircularPhysicalObject2D, obj2: TriangularPhysicalObject2D) -> Bool {
        let allPoints: [Vector2D] = [obj2.point1, obj2.point2, obj2.point3]
        let edges: [[Vector2D]] = [[obj2.point1, obj2.point2],
                                   [obj2.point2, obj2.point3],
                                   [obj2.point3, obj2.point1]]

        // Test 1: Vertex Within Circle
        for point in allPoints {
            let pointToCircleCentreVec = point - obj1.position
            if pointToCircleCentreVec.length < obj1.radius {
                return true
            }
        }

        // Test 2: Circle Centre within Triangle
        let circleCentreWithinTriangle = edges.allSatisfy({ edge in
            let edgeLineSegment = edge[1] - edge[0]
            let inwardNormVec = Vector2D(edgeLineSegment.second, -edgeLineSegment.first)
            let dist = inwardNormVec.dot(obj1.position - edge[0])
            return dist >= 0
        })
        if circleCentreWithinTriangle {
            return true
        }

        // Test 3: Circle Intersects Edge
        for edge in edges {
            let pointToCircleVec = obj1.position - edge[0]
            let edgeLineSegment = edge[1] - edge[0]
            var k = pointToCircleVec.dot(edgeLineSegment)

            if k > 0 {
                let len = edgeLineSegment.length
                k /= edgeLineSegment.length

                if (k < len) &&
                    (pow(Decimal(pointToCircleVec.first), 2) +
                    pow(Decimal(pointToCircleVec.second), 2) - pow(Decimal(k), 2) < pow(Decimal(obj1.radius), 2)) {
                    return true
                }
            }
        }

        return false
    }

    /**
    Function to check if a `RectangularPhysicalObject2D` and a `RectangularPhysicalObject2D`
    are colliding. Logic is specific to a rectangular and rectangular object collision.
    - Returns: `true` if the objects are colliding, `false` otherwise.
    */
    func checkCollidingObjects(obj1: RectangularPhysicalObject2D, obj2: RectangularPhysicalObject2D) -> Bool {
        let obj1Rect = CGRect(x: obj1.position.first,
                              y: obj1.position.second,
                              width: obj1.width,
                              height: obj1.height)
        let obj2Rect = CGRect(x: obj2.position.first,
                              y: obj2.position.second,
                              width: obj2.width,
                              height: obj2.height)
        return obj1Rect.intersects(obj2Rect)
    }

    /**
    Function to check if a `TriangularPhysicalObject2D` and a `TriangularPhysicalObject2D`
    are colliding. Logic is specific to a triangular and triangular object collision.
    - Returns: `true` if the objects are colliding, `false` otherwise.
    */
    func checkCollidingObjects(obj1: TriangularPhysicalObject2D, obj2: TriangularPhysicalObject2D) -> Bool {
        let obj1Edges: [[Vector2D]] = [[obj1.point1, obj1.point2],
                                       [obj1.point2, obj1.point3],
                                       [obj1.point3, obj1.point1]]
        let obj2Edges: [[Vector2D]] = [[obj2.point1, obj2.point2],
                                       [obj2.point2, obj2.point3],
                                       [obj2.point3, obj2.point1]]

        var count: Int = 0
        for obj2Edge in obj2Edges {
            for obj1Edge in obj1Edges {
                if checkLineSegmentsIntersectAtAPoint(point1: obj1Edge[0],
                                                      point2: obj1Edge[1],
                                                      point3: obj2Edge[0],
                                                      point4: obj2Edge[1]) {
                    count += 1
                }

                // If at least 2 edges intersect, the triangles intersect
                if count == 2 {
                    return true
                }
            }
        }
        return false
    }

    /**
     Checks if 2 line segments intersect.
     - Parameters:
        - point1: starting point of first line segment
        - point2: ending point of first line segment
        - point3: starting point of second line segment
        - point4: ending point of second line segment
     - Returns: `true` is the line segments intersect, `false` otherwise
     - Note: The algorithm used is from: https://bryceboe.com/2006/10/23/line-segment-intersection-algorithm/
     - Note: The algorithm checks for intersection at a single point. If the lines are collinear, then the
     algorithm will not consider them to be intersecting.
     */
    func checkLineSegmentsIntersectAtAPoint(point1: Vector2D, point2: Vector2D,
                                            point3: Vector2D, point4: Vector2D) -> Bool {
        (checkPointsInCounterClockwiseOrder(point1, point3, point4) !=
            checkPointsInCounterClockwiseOrder(point2, point3, point4)) &&
        (checkPointsInCounterClockwiseOrder(point1, point2, point3) !=
            checkPointsInCounterClockwiseOrder(point1, point2, point4))
    }

    /**
     Helper function to check that all 3 points are in counter-clockwise order.
     */
    private func checkPointsInCounterClockwiseOrder(_ point1: Vector2D,
                                                    _ point2: Vector2D,
                                                    _ point3: Vector2D) -> Bool {
        (point3.second - point1.second) * (point2.first - point1.first) >
            (point2.second - point1.second) * (point3.first - point1.first)
    }
}
