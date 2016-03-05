//
//  SetLineupViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class SetLineupViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var remainingLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    var editableContestLineup: EditableContestLineup! {
        didSet {
            self.refreshLabels()
            PFPlayerEvent.resetPinsForAllPlayersForEvent(editableContestLineup.event) // TODO
            editableContestLineup.delegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func refreshLabels() {
        let salary = editableContestLineup.currentSalary()
        let numplayers = editableContestLineup.lineupSize()
        let remainingSalary = editableContestLineup.maxSalary() - salary
        let remainingSalaryAvg = remainingSalary/numplayers
        remainingLabel?.text = "$\(remainingSalaryAvg) per player remaining"
        remainingLabel?.textColor = remainingSalaryAvg > 0 ? UIColor.blackColor() : UIColor.redColor()
        totalLabel?.text = "$\(remainingSalary)"
        totalLabel?.textColor = remainingSalary > 0 ? UIColor.blackColor() : UIColor.redColor()
    }
    
    func toChoosePitcher() {
        toPlayerPicker(0)
    }
    
    func toChooseHitter() {
        toPlayerPicker(1)
    }
    
    func toPlayerPicker(type: Int) {
        if let playerPickerVC = storyboard?.instantiateViewControllerWithIdentifier("PlayerPickerVC") as?  PlayerPickerViewController {
            playerPickerVC.editableContestLineup = editableContestLineup
            playerPickerVC.filterType = type
            let navigationController = UINavigationController(rootViewController: playerPickerVC)
            self.presentViewController(navigationController, animated: true, completion: nil)
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func saveToContest(contest: PFContest) {
        if let lineupQuery = PFLineup.myLineupsQuery() {
            let query = PFContestLineup.query()
            query?.whereKey("contest", equalTo: contest)
            query?.whereKey("lineup", matchesQuery: lineupQuery)
            query?.getFirstObjectInBackgroundWithBlock({ (contestLineup, error) -> Void in
                if let contestLineup = contestLineup as? PFContestLineup {
                    // update
                    do {
                        let lineup = contestLineup.lineup
                        lineup.setRoster(self.editableContestLineup)
                        try lineup.save()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    } catch {
                        // TODO
                        print(error)
                    }
                } else {
                    // create contestLineup
                    do {
                        if let lineup = PFLineup.lineupFromEditableLineup(self.editableContestLineup) {
                            let contestLineup = PFContestLineup(contest: contest, lineup: lineup)
                            try contestLineup.save()
                            self.dismissViewControllerAnimated(true, completion: nil)
                        }
                    } catch {
                        // TODO
                        print(error)
                    }
                }
            })
        }

    }

    @IBAction func submitTapped(sender: AnyObject) {
        // subclassed
    }
    
}

extension SetLineupViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return editableContestLineup.numberOfPositionsOnRoster()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return editableContestLineup.numberOfSpotsForPosition(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let playerEvent = editableContestLineup.playerEventForPositionSpot(indexPath.section, spot: indexPath.row) {
            let cell = tableView.dequeueReusableCellWithIdentifier("PlayerSelectedCell", forIndexPath: indexPath)
            cell.textLabel?.text = playerEvent.player.name
            cell.detailTextLabel?.text = "\(playerEvent.salary)"
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
            cell.textLabel?.text = "Select"
            cell.detailTextLabel?.text = "Player"
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if let playerEvent = editableContestLineup.playerEventForPositionSpot(indexPath.section, spot: indexPath.row) {
            editableContestLineup.swappingPlayerEvent = playerEvent
        }
        if (indexPath.section == 0) {
            toChoosePitcher()
        } else {
            toChooseHitter()
        }
    }
    
}

extension SetLineupViewController: EditableContestLineupDelegate {
    func editableContestLineupChanged() {
        self.tableView?.reloadData()
        self.refreshLabels()
    }
}
