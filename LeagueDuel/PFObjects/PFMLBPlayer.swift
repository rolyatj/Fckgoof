//
//  PFMLBPlayer.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFMLBPlayer: PFPlayer, PFSubclassing {
    
    class func parseClassName() -> String {
        return "MLBPlayer"
    }
    
    override class func sport() -> SportType? {
        return .MLB
    }

    override func positionType() -> Int? {
        if let position = position {
            if position == "P" {
                return MLBPosition.Pitcher.rawValue
            } else if position == "C" {
                return MLBPosition.Catcher.rawValue
            } else if position == "1B" {
                return MLBPosition.FirstBase.rawValue
            } else if position == "2B" {
                return MLBPosition.SecondBase.rawValue
            } else if position == "SS" {
                return MLBPosition.ShortStop.rawValue
            } else if position == "3B" {
                return MLBPosition.ThirdBase.rawValue
            } else if (position == "LF" || position == "CF" || position == "RF") {
                return MLBPosition.OutField.rawValue
            } else if position == "DH" {
                return MLBPosition.DesignatedHitter.rawValue
            }
        }
        return nil
    }
    
}
