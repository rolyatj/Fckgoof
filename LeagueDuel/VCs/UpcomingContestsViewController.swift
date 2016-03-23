//
//  UpcomingContestsViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class UpcomingContestsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var contestLineups = [PFContestLineup]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    var availableEvents = [PFEvent]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchEvents()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchContests()
    }
    
    func fetchContests() {
        let sport = SportType.MLB
        let q = PFLineup.myLineupsQuery(sport)
        q?.findObjectsInBackgroundWithBlock({ (objc, Dictionary) -> Void in
            print(objc)
        })
        let query = PFContestLineup.myUpcomingContestLineupsQuery(sport)
        query?.findObjectsInBackgroundWithBlock({ (contestLineups, error) -> Void in
            if let contestLineups = contestLineups as? [PFContestLineup] {
                self.contestLineups = contestLineups
            }
        })
    }
    
    func fetchEvents() {
        let sport = SportType.MLB
        let lineupQuery = PFEvent.upcomingEventsQuery(sport)
        lineupQuery?.findObjectsInBackgroundWithBlock({ (events, error) -> Void in
            if let events = events as? [PFEvent] {
                self.availableEvents = events
            }
        })
    }

    func toCreateLineupForEvent(event: PFEvent, duelTeam: PFDuelTeam) {
        var editableContestLineup: PFContestLineup?
        for contestLineup in contestLineups {
            print("\(contestLineup.contest.league.objectId) == \(duelTeam.league.objectId)")
            print("\(contestLineup.contest.leagueId) == \(duelTeam.league.objectId)")
            print("\(contestLineup.contest.event.objectId) == \(event.objectId)")
            if (contestLineup.contest.league.objectId == duelTeam.league.objectId &&
                contestLineup.contest.event.objectId == event.objectId) {
                    editableContestLineup = contestLineup
                    break
            }
        }
        if let editableContestLineup = editableContestLineup {
            toEditContestLineup(editableContestLineup)
        } else if let createLineupVC = storyboard?.instantiateViewControllerWithIdentifier("CreateLineupVC") as? CreateLineupViewController {
            createLineupVC.event = event
            createLineupVC.duelTeam = duelTeam
            let navigationController = UINavigationController(rootViewController: createLineupVC)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }

    func toEditContestLineup(contestLineup: PFContestLineup) {
        if let editLineupVC = storyboard?.instantiateViewControllerWithIdentifier("EditLineupVC") as? EditLineupViewController {
            editLineupVC.contestLineup = contestLineup
            let navigationController = UINavigationController(rootViewController: editLineupVC)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    func toCreateLineupForEvent(event: PFEvent) {
        fetchAvailableTeamsForEvent(event)
    }
    
    func fetchAvailableTeamsForEvent(event: PFEvent) {
        let sport = SportType.MLB
        let query = PFDuelTeam.myTeamsQuery()
        query?.findObjectsInBackgroundWithBlock({ (duelTeams, error) -> Void in
            if let duelTeams = duelTeams as? [PFDuelTeam] {
                print("found \(duelTeams.count) duelTeams for \(event)")
                self.chooseTeamForEvent(event, duelTeams:duelTeams)
            }
        })
    }
    
    func chooseTeamForEvent(event: PFEvent, duelTeams: [PFDuelTeam]) {
        if duelTeams.count > 1 {
            let alertController = UIAlertController(title: "Which Team?", message: nil, preferredStyle: .Alert)
            for duelTeam in duelTeams {
                let sportAction = UIAlertAction(title: duelTeam.name, style: .Default) { (action) -> Void in
                    self.toCreateLineupForEvent(event, duelTeam: duelTeam)
                }
                alertController.addAction(sportAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        } else if let duelTeam = duelTeams.first {
            toCreateLineupForEvent(event, duelTeam: duelTeam)
        } else {
            // TODO "you don't have any available leagues. Create one?"
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    }
    
}

extension UpcomingContestsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return availableEvents.count
        } else {
            return contestLineups.count
        }
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 0) {
            return "Upcoming Events"
        } else {
            return "Your Upcoming Lineups"
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
            let event = availableEvents[indexPath.row]
            cell.configureWithEvent(event)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("ContestLineupCell", forIndexPath: indexPath) as! ContestTableViewCell
            let contestLineup = contestLineups[indexPath.row]
            cell.configureWithContestLineup(contestLineup)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.section == 0) {
            let event = availableEvents[indexPath.row]
            toCreateLineupForEvent(event)
        } else {
            let contestLineup = contestLineups[indexPath.row]
            toEditContestLineup(contestLineup)
            
        }

    }
    
}
