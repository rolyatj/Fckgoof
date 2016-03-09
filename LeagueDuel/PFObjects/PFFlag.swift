//
//  PFFlag.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFFlag: PFObject, PFSubclassing {
    
    @NSManaged var userFlagged: PFDueler?
    @NSManaged var userFlagging: PFDueler?
    
    class func parseClassName() -> String {
        return "Flag"
    }
    
    convenience init(userFlagging: PFDueler) {
        self.init()
        self.userFlagged = userFlagging
        self.userFlagging = PFDueler.currentUser()
    }
}