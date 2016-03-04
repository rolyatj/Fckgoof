//
//  CreateTeamViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class CreateTeamViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var selectedLeagueButton: UIButton!
    
    var event: PFEvent!
    var selectedLeague: PFLeague? {
        didSet {
            if let selectedLeague = selectedLeague {
                selectedLeagueButton?.setTitle(selectedLeague.name, forState: .Normal)
            } else {
                selectedLeagueButton?.setTitle("Select League", forState: .Normal)
            }
        }
    }
    var availableLeagues = [PFLeague]() {
        didSet {
            selectedLeague = availableLeagues.first
        }
    }
    var pitchers = [PFPlayerEvent]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var hitters = [PFPlayerEvent]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchAvailableLeagues()
        
        PFPlayerEvent.resetPinsForAllPlayersForEvent(event) // TODO
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pinnedPlayerEvents:", name: "pinnedPlayerEvents", object: nil)
    }
    
    func pinnedPlayerEvents(notification: NSNotification) {
        if let event = notification.object as? PFEvent {
            if (self.event.objectId == event.objectId) {
                //fetchPlayerEvents()
            }
        }
    }
    
    func fetchAvailableLeagues() {
        let query = PFLeague.myLeaguesQuery()
        query?.findObjectsInBackgroundWithBlock({ (leagues, error) -> Void in
            if let leagues = leagues as? [PFLeague] {
                self.availableLeagues = leagues
            }
        })
    }
    
    @IBAction func changeLeague(sender: AnyObject) {
        if availableLeagues.count > 1 {
            let alertController = UIAlertController(title: "Which League?", message: nil, preferredStyle: .Alert)
            for league in availableLeagues {
                let sportAction = UIAlertAction(title: league.name, style: .Default) { (action) -> Void in
                    self.selectedLeague = league
                }
                alertController.addAction(sportAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func toChoosePitcher() {
        self.performSegueWithIdentifier("toChoosePitcher", sender: nil)
    }
    
    func toChooseHitter() {
        self.performSegueWithIdentifier("toChooseHitter", sender: nil)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let playerPickerVC = segue.destinationViewController as? PlayerPickerViewController {
            playerPickerVC.delegate = self
            if (segue.identifier == "toChoosePitcher") {
                playerPickerVC.filterType = 0
                playerPickerVC.disabledPlayerEvents = pitchers
            } else if (segue.identifier == "toChooseHitter") {
                playerPickerVC.filterType = 1
                playerPickerVC.disabledPlayerEvents = hitters
            }
        }
    }
    
}

extension CreateTeamViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 2
        } else {
            return 6
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            if (pitchers.count > 0 && indexPath.row < pitchers.count) {
                let pitcherEvent = pitchers[indexPath.row]
                let cell = tableView.dequeueReusableCellWithIdentifier("PlayerSelectedCell", forIndexPath: indexPath)
                cell.textLabel?.text = pitcherEvent.player.name
                cell.detailTextLabel?.text = "\(pitcherEvent.salary)"
                return cell
            }
        } else {
            if (hitters.count > 0 && indexPath.row < hitters.count) {
                let hitterEvent = hitters[indexPath.row]
                let cell = tableView.dequeueReusableCellWithIdentifier("PlayerSelectedCell", forIndexPath: indexPath)
                cell.textLabel?.text = hitterEvent.player.name
                cell.detailTextLabel?.text = "\(hitterEvent.salary)"
                return cell
            }
        }

        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
        cell.textLabel?.text = "Select"
        cell.detailTextLabel?.text = "Player"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (indexPath.section == 0) {
            if (pitchers.count > 0 && indexPath.row < pitchers.count) {
            } else {
                toChoosePitcher()
            }
        } else {
            if (hitters.count > 0 && indexPath.row < hitters.count) {
            } else {
                toChooseHitter()
            }
        }
    }
    
}

extension CreateTeamViewController: PlayerPickerViewControllerDelegate {
    func didSelectPlayerEvent(playerEvent: PFPlayerEvent) {
        if (playerEvent.player.type == 0) {
            if (pitchers.count < 2) {
                pitchers.append(playerEvent)
            }
        } else if (playerEvent.player.type == 1) {
            if (hitters.count < 8) {
                hitters.append(playerEvent)
            }
        }
        self.tableView.reloadData()
    }
}
