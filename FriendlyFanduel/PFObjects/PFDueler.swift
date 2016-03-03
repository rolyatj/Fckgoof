//
//  PFDueler.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFDueler: PFUser {

    @NSManaged var name: String?
    @NSManaged var followingIds: [String]?
    
    func setup() {
        self.followingIds = [String]()
    }
    
}
