//
//  PFPlayerEvent.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFPlayerEvent: PFObject, PFSubclassing {
    
    @NSManaged var event: PFEvent!
    @NSManaged var player: PFPlayer!
    @NSManaged var result: PFPlayerEventResult!
    @NSManaged var salary: Int
    
    class func parseClassName() -> String {
        return "PlayerEvent"
    }
}
