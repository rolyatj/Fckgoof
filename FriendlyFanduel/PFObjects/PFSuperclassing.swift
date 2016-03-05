//
//  PFSuperclassing.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/5/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import Parse

class PFSuperclass: PFObject {
    
    class func queryWithIncludes(sport: SportType) -> PFQuery? {
        return nil
    }
    class func query(sport: SportType) -> PFQuery? {
        return nil
    }
    class func sport() -> SportType? {
        return nil
    }
    
}

enum SportType: Int {
    case MLB = 0
}