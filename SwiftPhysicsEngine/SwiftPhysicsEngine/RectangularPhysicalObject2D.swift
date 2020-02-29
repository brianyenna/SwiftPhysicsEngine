//
//  RectangularPhysicalObject2D.swift
//  Game
//
//  Created by Brian Yen on 12/2/20.
//  Copyright © 2020 Brian Yen. All rights reserved.
//

/**
Objects that conform to this protocol are rectangular and are
2-Dimensional.
 - Note: the `position` field in`PhysicalObject2D` refers
 to the top-left corner of the `RectangularPhysicalObject2D`
*/
protocol RectangularPhysicalObject2D: PhysicalObject2D {
    var height: Double { get set }
    var width: Double { get set }
}
