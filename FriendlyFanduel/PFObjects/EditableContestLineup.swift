//
//  EditableContestLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

protocol EditableContestLineupDelegate {
    func editableContestLineupChanged()
}

class EditableContestLineup: NSObject {
    
    enum PositionType : Int {
        case Pitcher = 0
        case Hitter
        
        case count
    }
    
    var delegate: EditableContestLineupDelegate?
    var event: PFEvent!
    var lineup: PFLineup?
    var swappingPlayerEvent: PFPlayerEvent?
    
    var pitchers = [PFPlayerEvent]() {
        didSet {
            delegate?.editableContestLineupChanged()
        }
    }
    var hitters = [PFPlayerEvent]() {
        didSet {
            delegate?.editableContestLineupChanged()
        }
    }
    
    convenience init(event: PFEvent) {
        self.init()
        self.event = event
    }
    
    convenience init(contestLineup: PFContestLineup) {
        self.init()
        self.event = contestLineup.contest.event
        self.lineup = contestLineup.lineup
    }
    
    func currentSalary() -> Int {
        var salary = 0
        for player in pitchers {
            salary += player.salary
        }
        for player in hitters {
            salary += player.salary
        }
        return salary
    }
    
    func lineupSize() -> Int {
        return event.numberPitchers + event.numberHitters
    }
    
    func maxSalary() -> Int {
        return event.maxSalary
    }
    
    func disabledPitcherEventIds() -> [String] {
        var pitcherEventIds = [String]()
        for pitcher in pitchers {
            if let objectId = pitcher.objectId {
                pitcherEventIds.append(objectId)
            }
        }
        return pitcherEventIds
    }
    
    func disabledHitterEventIds() -> [String] {
        var hitterEventIds = [String]()
        for hitter in hitters {
            if let objectId = hitter.objectId {
                hitterEventIds.append(objectId)
            }
        }
        return hitterEventIds
    }
    
    func disabledPlayerEventIds(filterType: Int) -> [String]? {
        if (filterType == PositionType.Pitcher.rawValue) {
            return disabledPitcherEventIds()
        } else if (filterType == PositionType.Hitter.rawValue) {
            return disabledHitterEventIds()
        }
        return nil
    }
    
    func checkIfCanSubmit() -> String? {
        // TODO
        return nil
    }
    
    // DATASOURCE
    
    func numberOfPositionsOnRoster() -> Int {
        return PositionType.count.rawValue
    }
    
    func numberOfSpotsForPosition(position: Int) -> Int {
        if (position == PositionType.Pitcher.rawValue) {
            return event.numberPitchers
        }
        return event.numberHitters
    }
    
    func playerEventForPositionSpot(position: Int, spot: Int) -> PFPlayerEvent? {
        if (position == PositionType.Pitcher.rawValue) {
            if (pitchers.count > 0 && spot < pitchers.count) {
                return pitchers[spot]
            }
        } else {
            if (hitters.count > 0 && spot < hitters.count) {
                return hitters[spot]
            }
        }
        
        return nil
    }
    
}

extension EditableContestLineup: PlayerPickerViewControllerDelegate {
    func playerPickerDidCancel() {
        swappingPlayerEvent = nil
    }
    func playerPickerDidSelectPlayerEvent(playerEvent: PFPlayerEvent) {
        if (playerEvent.player.type == PositionType.Pitcher.rawValue) {
            if let swappingPlayerEvent = swappingPlayerEvent, index = pitchers.indexOf(swappingPlayerEvent) {
                pitchers.removeAtIndex(index)
            }
            if (pitchers.count < event.numberPitchers) {
                pitchers.append(playerEvent)
            }
        } else if (playerEvent.player.type == PositionType.Hitter.rawValue) {
            if let swappingPlayerEvent = swappingPlayerEvent, index = hitters.indexOf(swappingPlayerEvent) {
                hitters.removeAtIndex(index)
            }
            if (hitters.count < event.numberHitters) {
                hitters.append(playerEvent)
            }
        }
        swappingPlayerEvent = nil
    }
}
