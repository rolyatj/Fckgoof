//
//  PFPlayerEventResult.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFPlayerEventResult: PFObject {
    
    @NSManaged var score: Float
    @NSManaged var result: String?
    
}

