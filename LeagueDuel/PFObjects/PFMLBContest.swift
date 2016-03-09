//
//  PFMLBContest.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFMLBContest: PFContest, PFSubclassing {
    
    class func parseClassName() -> String {
        return "MLBContest"
    }
    
    override class func sport() -> SportType? {
        return .MLB
    }
    
}
