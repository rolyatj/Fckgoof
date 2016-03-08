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
        
    convenience init(editableContestLineup: MLBEditableContestLineup) {
        self.init()
        self.dueler = PFDueler.currentUser()!
        self.setRoster(editableContestLineup)
    }
    
    override func setRoster(editableContestLineup: EditableContestLineup) {
        self.playerEvents = [PFPlayerEvent]()
        if let editableContestLineup = editableContestLineup as? MLBEditableContestLineup {
            for positionPlayerEvent in editableContestLineup.posititionPlayerEvents {
                for playerEvent in positionPlayerEvent.1 {
                    if let playerEvent = playerEvent as? PFPlayerEvent {
                        playerEvents.append(playerEvent)
                    }
                }
            }
        }

    }
    
    class func parseClassName() -> String {
        return "MLBLineup"
    }
    
    override class func sport() -> SportType? {
        return .MLB
    }
    
}
