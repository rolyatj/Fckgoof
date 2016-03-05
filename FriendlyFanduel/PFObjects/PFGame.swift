//
//  PFLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFGame: PFObject {
    
    @NSManaged var homeTeam: PFTeam!
    @NSManaged var awayTeam: PFTeam!
    @NSManaged var lineupTime: NSDate!
    
}
