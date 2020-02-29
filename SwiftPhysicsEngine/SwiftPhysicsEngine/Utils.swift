//
//  Utils.swift
//  Game
//
//  Created by Brian Yen on 12/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

import UIKit

/**
 A class of utility functions for View.
 */
class Utils {
    /**
     Helper function to convert x,y coordinates of the center of a circle
     to a CGRect object representing the frame of the circle.
     - Note: This function does not perform any input validation, and will simply
     create a CGRect based on the argument values
     - Parameters:
         - x: x-coordinate of the center of the circle
         - y: y-coordinate of the center of the circle
     */
    static func getCGRectFrameForCircle(xPos: Double, yPos: Double, radius: Double) -> CGRect {
        let rect = CGRect(x: CGFloat(xPos - radius),
                          y: CGFloat(yPos - radius),
                          width: CGFloat(radius * 2),
                          height: CGFloat(radius * 2))
        return rect
    }

    /**
    Helper function to convert x,y coordinates of the centroid of a triangle
    to a CGRect object representing the frame of the triangle.
    - Note: This function does not perform any input validation, and will simply
    create a CGRect based on the argument values
    - Parameters:
        - x: x-coordinate of the centroid of the triangle
        - y: y-coordinate of the centroid of the triangle
        - size: distance from centroid of triangle to smallest
     bounding box
    */
    static func getCGRectFrameForTriangle(xPos: Double, yPos: Double, size: Double) -> CGRect {
        let rect = CGRect(x: CGFloat(xPos - size),
                          y: CGFloat(yPos - size),
                          width: CGFloat(size * 2),
                          height: CGFloat(size * 2))
        return rect
    }
}
