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

    @NSManaged var numberHitters: Int
    @NSManaged var numberPitchers: Int
    
    class func parseClassName() -> String {
        return "MLBEvent"
    }
    
    override class func sport() -> SportType? {
        return .MLB
    }
    
}
