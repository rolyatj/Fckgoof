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
    
    var delegate: EditableContestLineupDelegate?
    var event: PFEvent!
    var lineup: PFLineup?
    var swappingPlayerEvent: PFPlayerEvent?
    
    class func editableContestLineupWithEvent(event: PFEvent) -> EditableContestLineup? {
        if let sport = event.dynamicType.sport() {
            if (sport == .MLB) {
                let editableContestLineup = MLBEditableContestLineup(event: event)
                return editableContestLineup
            }
        }
        return nil
    }
    
    class func editableContestLineupWithLineup(contestLineup: PFContestLineup) -> EditableContestLineup? {
        if let event = contestLineup.contest.event, let sport = event.dynamicType.sport() {
            if (sport == .MLB) {
                let editableContestLineup = MLBEditableContestLineup(contestLineup: contestLineup)
                return editableContestLineup
            }
        }
        return nil
    }
    
    func setupWithLineup(lineup: PFLineup) {
        
    }
    
    func currentSalary() -> Int {
        return 0
    }
    
    func lineupSize() -> Int {
        return 0
    }
    
    func maxSalary() -> Int {
        return 0
    }
    
    func disabledPlayerEventIds(filterType: Int) -> [String]? {
        return nil
    }
    
    func errorMessageIfInvalid() -> String? {
        // TODO
        return nil
    }
    
    // DATASOURCE
    
    func numberOfPositionsOnRoster() -> Int {
        return 0
    }
    
    func numberOfSpotsForPosition(position: Int) -> Int {
        return 0
    }
    
    func titleForPosition(position: Int) -> String? {
        return nil
    }
    
    func playerEventForPositionSpot(position: Int, spot: Int) -> PFPlayerEvent? {
        return nil
    }
    
    func hasSelectedPlayerEvent(playerEvent: PFPlayerEvent) -> Bool {
        return false
    }
    
}

extension EditableContestLineup: PlayerPickerViewControllerDelegate {
    func playerPickerDidCancel() {
        swappingPlayerEvent = nil
    }
    func playerPickerDidSelectPlayerEvent(playerEvent: PFPlayerEvent) {
        swappingPlayerEvent = nil
        togglePlayerEvent(playerEvent)
    }
    
    func togglePlayerEvent(playerEvent: PFPlayerEvent) {
        // subclassed
    }
}
