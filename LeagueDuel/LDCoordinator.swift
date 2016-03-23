//
//  LDCoordinator.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/23/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

enum DateType : Int {
    case Open = 0
    case Start
    case End
}

class LDCoordinator: NSObject {

    static let instance = LDCoordinator()
    
    var activeSports = [SportType]()
    var sportEventDates = [SportType:(openDates:[NSDate], startDates:[NSDate], endDates:[NSDate])]()
    
    func setupRefreshTimes(activeSports: [SportType]) {
        self.activeSports = activeSports

        for sport in activeSports {
            let query = PFEvent.query(sport)
            query?.whereKey("endDate", greaterThan: NSDate())
            query?.findObjectsInBackgroundWithBlock({ (events, error) -> Void in
                if let events = events as? [PFEvent] {
                    var openDates = [NSDate]()
                    var startDates = [NSDate]()
                    var endDates = [NSDate]()
                    for event in events {
                        if (event.isLive()) {
                            endDates.append(event.endDate)
                        } else {
                            if (event.startDate.compare(NSDate(timeIntervalSinceNow: 3600*24)) == .OrderedAscending) {
                                startDates.append(event.startDate)
                            }
                            if (event.openDate.compare(NSDate()) == .OrderedDescending) {
                                if (event.openDate.compare(NSDate(timeIntervalSinceNow: 3600*24)) == .OrderedAscending) {
                                    openDates.append(event.openDate)
                                }
                            }
                        }
                    }
                    self.sportEventDates[sport] = (openDates, startDates, endDates)
                    print("\(sport)\nOPEN \(openDates)\nSTART \(startDates)\nEND \(endDates)")
                }
            })
        }
    }

    func shouldRefresh(lastRefreshDate: NSDate, sport: SportType, dateTypes: [DateType]) -> Bool {
        var shouldRefresh = false
        for dateType in dateTypes {
            switch (dateType) {
            case .Open:
                if let dates = sportEventDates[sport]?.0 {
                    for date in dates {
                        if (date.compare(NSDate()) == .OrderedAscending &&
                            date.compare(lastRefreshDate) == .OrderedDescending) {
                                shouldRefresh = true
                        }
                    }
                }
                break
            case .Start:
                if let dates = sportEventDates[sport]?.1 {
                    for date in dates {
                        if (date.compare(NSDate()) == .OrderedAscending &&
                            date.compare(lastRefreshDate) == .OrderedDescending) {
                                shouldRefresh = true
                        }
                    }
                }
                break
            case .End:
                if let dates = sportEventDates[sport]?.2 {
                    for date in dates {
                        if (date.compare(NSDate()) == .OrderedAscending &&
                            date.compare(lastRefreshDate) == .OrderedDescending) {
                                shouldRefresh = true
                        }
                    }
                }
                break
            }
        }
        return shouldRefresh
    }
    
}
