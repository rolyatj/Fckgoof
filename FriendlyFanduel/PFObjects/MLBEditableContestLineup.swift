//
//  MLBEditableContestLineup.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class MLBEditableContestLineup: EditableContestLineup {
    
    var mlbEvent: PFMLBEvent!
    override var event : PFEvent! {
        get {
            return mlbEvent
        }
        set {
            if newValue is PFMLBEvent {
                mlbEvent = newValue as! PFMLBEvent
            } else {
                print("incorrect type for PFMLBEvent")
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
            } else if (newValue != nil) {
                print("incorrect type for mlbLineup")
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
            } else if (newValue != nil) {
                print("incorrect type for swappingMLBPlayerEvent")
            }
        }
    }

    var posititionPlayerEvents = [MLBPosition:NSMutableArray]() {
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
        for playerEvent in contestLineup.lineup.playerEvents {
            if let positionType = playerEvent.player.positionType(), let position = MLBPosition(rawValue: positionType) {
                if let playerEvents = posititionPlayerEvents[position] {
                    if (playerEvents.count < mlbEvent.numberOfSpots(positionType)) {
                        playerEvents.addObject(playerEvent)
                    }
                } else {
                    posititionPlayerEvents[position] = [playerEvent]
                }
            }
        }
    }
    
    override func currentSalary() -> Int {
        var salary = 0
        for posititionPlayerEvent in posititionPlayerEvents {
            for playerEvent in posititionPlayerEvent.1 {
                if let playerEvent = playerEvent as? PFPlayerEvent {
                    salary += playerEvent.salary
                }
            }
        }

        return salary
    }
    
    override func lineupSize() -> Int {
        return mlbEvent.lineupSize()
    }
    
    override func maxSalary() -> Int {
        return mlbEvent.maxSalary
    }
    
    func disabledPlayerEventIds(position: MLBPosition) -> [String] {
        var playerEventIds = [String]()
        if let playerEvents = posititionPlayerEvents[position] {
            for playerEvent in playerEvents {
                if let playerEvent = playerEvent as? PFPlayerEvent {
                    if let objectId = playerEvent.objectId {
                        playerEventIds.append(objectId)
                    }
                }
            }
        }

        return playerEventIds
    }

    override func disabledPlayerEventIds(filterType: Int) -> [String]? {
        if let position = MLBPosition(rawValue: filterType) {
            return disabledPlayerEventIds(position)
        }
        return nil
    }
    
    override func checkIfCanSubmit() -> String? {
        // TODO
        return nil
    }
    
    // DATASOURCE
    
    override func numberOfPositionsOnRoster() -> Int {
        return mlbEvent.numberOfPositions()
    }
    
    override func numberOfSpotsForPosition(position: Int) -> Int {
        return mlbEvent.numberOfSpots(position)
    }
    
    override func playerEventForPositionSpot(position: Int, spot: Int) -> PFPlayerEvent? {
        var playerEvent: PFPlayerEvent?
        if let position = MLBPosition(rawValue: position) {
            if let playerEvents = posititionPlayerEvents[position] {
                if (playerEvents.count > 0 && spot < playerEvents.count) {
                    playerEvent = playerEvents[spot] as? PFPlayerEvent
                }
            }
        }
        print(playerEvent?.player.description)
        return playerEvent
    }
    
    override func playerPickerDidCancel() {
        swappingPlayerEvent = nil
    }
    
    override func playerPickerDidSelectPlayerEvent(playerEvent: PFPlayerEvent) {
        if let playerEvent = playerEvent as? PFMLBPlayerEvent {
            if let positionType = playerEvent.player.positionType(), let position = MLBPosition(rawValue: positionType) {
                if let swappingMLBPlayerEvent = swappingMLBPlayerEvent {
                    for swappablePlayerEvent in posititionPlayerEvents {
                        let playerEvents = swappablePlayerEvent.1
                        playerEvents.removeObject(swappingMLBPlayerEvent)
                        posititionPlayerEvents[swappablePlayerEvent.0] = playerEvents
                    }
                }
                if let playerEvents = posititionPlayerEvents[position] {
                    if (playerEvents.count < mlbEvent.numberOfSpots(positionType)) {
                        playerEvents.addObject(playerEvent)
                        posititionPlayerEvents[position] = playerEvents
                    }
                } else {
                    posititionPlayerEvents[position] = [playerEvent]
                }
            }
        }

        swappingPlayerEvent = nil
    }
}