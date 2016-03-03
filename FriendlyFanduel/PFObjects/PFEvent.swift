//
//  PFEvent.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFEvent: PFObject, PFSubclassing {
    
    @NSManaged var startDate: NSDate!
    @NSManaged var endDate: NSDate!
    @NSManaged var name: String?
    @NSManaged var sport: PFSport!
    
    class func parseClassName() -> String {
        return "Event"
    }
    
}