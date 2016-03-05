//
//  MLBEditableContestLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class MLBEditableContestLineup: EditableContestLineup {
    
    enum PositionType : Int {
        case Pitcher = 0
        case Hitter
        
        case count
    }
    
    var mlbEvent: PFMLBEvent!
    override var event : PFEvent! {
        get {
            return mlbEvent
        }
        set {
            if newValue is PFMLBEvent {
                mlbEvent = newValue as! PFMLBEvent
            } else {
                print("incorrect chassis type for racecar")
            }
        }
    }
    var mlbLineup: PFMLBLineup?
    override var lineup: PFLineup? {
        get {
            return mlbLineup
        }
        set {
            if newValue is PFMLBLineup {
                mlbLineup = newValue as? PFMLBLineup
            } else {
                print("incorrect chassis type for racecar")
            }
        }
    }
    var swappingMLBPlayerEvent: PFMLBPlayerEvent?
    override var swappingPlayerEvent : PFPlayerEvent? {
        get {
            return swappingMLBPlayerEvent
        }
        set {
            if newValue is PFMLBPlayerEvent {
                swappingMLBPlayerEvent = newValue as? PFMLBPlayerEvent
            } else {
                print("incorrect chassis type for racecar")
            }
        }
    }

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
    
    override func currentSalary() -> Int {
        var salary = 0
        for player in pitchers {
            salary += player.salary
        }
        for player in hitters {
            salary += player.salary
        }
        return salary
    }
    
    override func lineupSize() -> Int {
        return mlbEvent.numberPitchers + mlbEvent.numberHitters
    }
    
    override func maxSalary() -> Int {
        return mlbEvent.maxSalary
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
    
    override func disabledPlayerEventIds(filterType: Int) -> [String]? {
        if (filterType == PositionType.Pitcher.rawValue) {
            return disabledPitcherEventIds()
        } else if (filterType == PositionType.Hitter.rawValue) {
            return disabledHitterEventIds()
        }
        return nil
    }
    
    override func checkIfCanSubmit() -> String? {
        // TODO
        return nil
    }
    
    // DATASOURCE
    
    override func numberOfPositionsOnRoster() -> Int {
        return PositionType.count.rawValue
    }
    
    override func numberOfSpotsForPosition(position: Int) -> Int {
        if (position == PositionType.Pitcher.rawValue) {
            return mlbEvent.numberPitchers
        }
        return mlbEvent.numberHitters
    }
    
    override func playerEventForPositionSpot(position: Int, spot: Int) -> PFPlayerEvent? {
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
    
    override func playerPickerDidCancel() {
        swappingPlayerEvent = nil
    }
    override func playerPickerDidSelectPlayerEvent(playerEvent: PFPlayerEvent) {
        if let playerEvent = playerEvent as? PFMLBPlayerEvent {
            if (playerEvent.player.type == PositionType.Pitcher.rawValue) {
                if let swappingPlayerEvent = swappingPlayerEvent, index = pitchers.indexOf(swappingPlayerEvent) {
                    pitchers.removeAtIndex(index)
                }
                if (pitchers.count < mlbEvent.numberPitchers) {
                    pitchers.append(playerEvent)
                }
            } else if (playerEvent.player.type == PositionType.Hitter.rawValue) {
                if let swappingPlayerEvent = swappingPlayerEvent, index = hitters.indexOf(swappingPlayerEvent) {
                    hitters.removeAtIndex(index)
                }
                if (hitters.count < mlbEvent.numberHitters) {
                    hitters.append(playerEvent)
                }
            }
        }

        swappingPlayerEvent = nil
    }
}