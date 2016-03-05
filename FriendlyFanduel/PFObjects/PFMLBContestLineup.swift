//
//  PFMLBContestLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFMLBContestLineup: PFContestLineup, PFSubclassing {
    
    func getContest() -> PFMLBContest {
        return contest as! PFMLBContest
    }
    
    class func parseClassName() -> String {
        return "MLBContestLineup"
    }
    
}
