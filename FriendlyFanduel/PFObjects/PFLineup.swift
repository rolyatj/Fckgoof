//
//  PFLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFLineup: PFObject {
    
    @NSManaged var dueler: PFDueler!
    
    class func lineupFromEditableLineup(editableContestLineup: EditableContestLineup) -> PFLineup? {
        if (editableContestLineup is MLBEditableContestLineup) {
            return PFMLBLineup(editableContestLineup: editableContestLineup as! MLBEditableContestLineup)
        }
        return nil
    }
    
    func setRoster(editableContestLineup: EditableContestLineup) {
    }
    
    class func myLineupsQuery() -> PFQuery? {
        if let user = PFDueler.currentUser(){
            let query = PFLineup.query()
            query?.whereKey("dueler", equalTo: user)
            return query
        }
        return nil
    }
    
}
