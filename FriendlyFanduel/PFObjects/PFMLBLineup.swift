//
//  PFMLBLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class PFMLBLineup: PFLineup, PFSubclassing {
    
    @NSManaged var pitcherPlayerEvents: [PFPlayerEvent]!
    @NSManaged var hitterPlayerEvents: [PFPlayerEvent]!
    
    convenience init(editableContestLineup: MLBEditableContestLineup) {
        self.init()
        self.dueler = PFDueler.currentUser()!
        self.setRoster(editableContestLineup)
    }
    
    override func setRoster(editableContestLineup: EditableContestLineup) {
        if let editableContestLineup = editableContestLineup as? MLBEditableContestLineup {
            self.pitcherPlayerEvents = editableContestLineup.hitters
            self.hitterPlayerEvents = editableContestLineup.pitchers
        }

    }
    
    class func parseClassName() -> String {
        return "MLBLineup"
    }
    
}
