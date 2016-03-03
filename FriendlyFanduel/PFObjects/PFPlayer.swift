//
//  PFPlayer.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFPlayer: PFObject, PFSubclassing {
    
    @NSManaged var sport: PFSport!
    @NSManaged var type: Int
    @NSManaged var name: String?
    
    class func parseClassName() -> String {
        return "Player"
    }
    
}