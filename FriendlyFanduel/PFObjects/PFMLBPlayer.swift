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

}
