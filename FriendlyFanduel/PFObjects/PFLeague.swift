//
//  PFLeague.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFLeague: PFObject, PFSubclassing {
    
    @NSManaged var commissioner: PFDueler!
    @NSManaged var duelers: [String]!
    @NSManaged var name: String?
    @NSManaged var sport: PFSport!
    
    class func parseClassName() -> String {
        return "League"
    }
    
    convenience init(sport: PFSport, name: String) {
        self.init()
        self.commissioner = PFDueler.currentUser()!
        self.duelers = [PFDueler.currentUser()!.objectId!]
        self.name = name
        self.sport = sport
    }

}