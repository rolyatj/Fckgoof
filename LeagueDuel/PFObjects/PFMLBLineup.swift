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
        print("WARNING: temp MLBLineup created (without reference to a duelTeam). only should be used when 'exporting'")
        self.setRoster(editableContestLineup)
    }
    
    convenience init(duelTeam: PFDuelTeam, editableContestLineup: MLBEditableContestLineup) {
        self.init()
        self.duelTeam = duelTeam
        self.setRoster(editableContestLineup)
    }
    
    override func setRoster(editableContestLineup: EditableContestLineup) {
        self.playerEvents0 = [PFPlayerEvent]()
        self.playerEvents1 = [PFPlayerEvent]()
        self.playerEvents2 = [PFPlayerEvent]()
        self.playerEvents3 = [PFPlayerEvent]()
        self.playerEvents4 = [PFPlayerEvent]()
        self.playerEvents5 = [PFPlayerEvent]()
        self.playerEvents6 = [PFPlayerEvent]()
        self.playerEvents7 = [PFPlayerEvent]()
        self.playerEvents8 = [PFPlayerEvent]()
        self.playerEvents9 = [PFPlayerEvent]()
        if let editableContestLineup = editableContestLineup as? MLBEditableContestLineup {
            for positionPlayerEvent in editableContestLineup.positionPlayerEvents {
                
                for playerEvent in positionPlayerEvent.1 {
                    if let playerEvent = playerEvent as? PFPlayerEvent {
                        switch (positionPlayerEvent.0) {
                        case .Pitcher:
                            playerEvents0.append(playerEvent)
                            break
                        case .Catcher:
                            playerEvents1.append(playerEvent)
                            break
                        case .FirstBase:
                            playerEvents2.append(playerEvent)
                            break
                        case .SecondBase:
                            playerEvents3.append(playerEvent)
                            break
                        case .ShortStop:
                            playerEvents4.append(playerEvent)
                            break
                        case .ThirdBase:
                            playerEvents5.append(playerEvent)
                            break
                        case .OutField:
                            playerEvents6.append(playerEvent)
                            break
                        case .DesignatedHitter:
                            playerEvents7.append(playerEvent)
                            break
                        default:
                            break
                        }
                    }
                }
            }
        }
    }
    
    override func positionMapping() -> [Int : [PFPlayerEvent]]? {
        return [MLBPosition.Pitcher.rawValue: playerEvents0,
            MLBPosition.Catcher.rawValue: playerEvents1,
            MLBPosition.FirstBase.rawValue: playerEvents2,
            MLBPosition.SecondBase.rawValue: playerEvents3,
            MLBPosition.ShortStop.rawValue: playerEvents4,
            MLBPosition.ThirdBase.rawValue: playerEvents5,
            MLBPosition.OutField.rawValue: playerEvents6,
            MLBPosition.DesignatedHitter.rawValue: playerEvents7]
    }
    
    class func parseClassName() -> String {
        return "MLBLineup"
    }
    
    override class func sport() -> SportType? {
        return .MLB
    }
    
}
