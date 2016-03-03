//
//  PFSport.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFSport: PFObject, PFSubclassing {
    
    @NSManaged var name: String
    @NSManaged var type: Int
    
    class func parseClassName() -> String {
        return "Sport"
    }
    
}