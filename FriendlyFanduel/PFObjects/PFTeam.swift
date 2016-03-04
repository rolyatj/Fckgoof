//
//  PFTeam.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFTeam: PFObject, PFSubclassing {

    @NSManaged var name: String?
    
    class func parseClassName() -> String {
        return "Team"
    }
    
}
    