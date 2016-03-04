//
//  UpcomingLineupsViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class UpcomingLineupsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var lineups = [PFLineup]() {
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

        fetchLineups()
        fetchEvents()
    }
    
    func fetchLineups() {
        let query = PFLineup.myUpcominglineupsQuery()
        query?.findObjectsInBackgroundWithBlock({ (lineups, error) -> Void in
            if let lineups = lineups as? [PFLineup] {
                self.lineups = lineups
            }
        })
    }
    
    func fetchEvents() {
        let query = PFEvent.queryWithIncludes()
        query?.findObjectsInBackgroundWithBlock({ (events, error) -> Void in
            if let events = events as? [PFEvent] {
                self.availableEvents = events
            }
        })
    }

    func toCreateTeamForEvent(event: PFEvent) {
        performSegueWithIdentifier("toCreateTeam", sender: event)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toCreateTeam") {
            if let createTeamVC = segue.destinationViewController as? CreateTeamViewController {
                createTeamVC.event = sender as! PFEvent
            }
        }
    }
    
}

extension UpcomingLineupsViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return availableEvents.count
        } else {
            return lineups.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! EventTableViewCell
            let event = availableEvents[indexPath.row]
            cell.configureWithEvent(event)
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("LineupCell", forIndexPath: indexPath) as! TeamTableViewCell
            let team = lineups[indexPath.row]
            cell.configureWithTeam(team)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.section == 0) {
            let event = availableEvents[indexPath.row]
            toCreateTeamForEvent(event)
        } else {
            let team = lineups[indexPath.row]

        }

    }
    
}
