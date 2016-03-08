//
//  PFMLBEvent.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFMLBEvent: PFEvent, PFSubclassing {

    @NSManaged var numberP: Int
    @NSManaged var numberC: Int
    @NSManaged var number1B: Int
    @NSManaged var number2B: Int
    @NSManaged var numberSS: Int
    @NSManaged var number3B: Int
    @NSManaged var numberOF: Int
    @NSManaged var numberDH: Int
    
    class func parseClassName() -> String {
        return "MLBEvent"
    }
    
    override class func sport() -> SportType? {
        return .MLB
    }
    
    override func numberOfPositions() -> Int {
        return MLBPosition.count.rawValue
    }
    
    override func lineupSize() -> Int {
        return numberP + numberC + number1B + number2B + numberSS + number3B + numberOF + numberDH
    }
    
    override func numberOfSpots(position: Int) -> Int {
        if let position = MLBPosition(rawValue: position) {
            switch (position) {
            case .Pitcher:
                return numberP
            case .Catcher:
                return numberC
            case .FirstBase:
                return number1B
            case .SecondBase:
                return number2B
            case .ShortStop:
                return numberSS
            case .ThirdBase:
                return number3B
            case .OutField:
                return numberOF
            case .DesignatedHitter:
                return numberDH
            default:
                return 0
            }
        }
        return 0
    }
    
}
