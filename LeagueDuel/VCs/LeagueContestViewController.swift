//
//  LeagueContestViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class LeagueContestViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var contest: PFContest!
    var contestLineups = [PFContestLineup]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    var selectedLineup: Int?
    
    func changeSelectedLineup(newSelectedLineup: Int?) {
        tableView.beginUpdates()
        if (newSelectedLineup == selectedLineup) {
            if let selectedLineup = selectedLineup {
                deselectLineup(selectedLineup)
            }
            selectedLineup = nil
        } else {
            if let selectedLineup = selectedLineup {
                deselectLineup(selectedLineup)
            }
            if let newSelectedLineup = newSelectedLineup {
                selectLineup(newSelectedLineup)
            }
            selectedLineup = newSelectedLineup
        }
        tableView.endUpdates()
        if let newSelectedLineup = newSelectedLineup {
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: newSelectedLineup), atScrollPosition: .Top, animated: true)
        }
    }
    
    func deselectLineup(lineupIndex: Int) {
        let contestLineup = contestLineups[lineupIndex]
        var indexPaths = [NSIndexPath]()
        for i in 1...contestLineup.lineup.allPlayerEvents().count {
            indexPaths.append(NSIndexPath(forRow: i, inSection: lineupIndex))
        }
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        tableView.deselectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: lineupIndex), animated: true)
    }
    
    func selectLineup(lineupIndex: Int) {
        let contestLineup = contestLineups[lineupIndex]
        var indexPaths = [NSIndexPath]()
        for i in 1...contestLineup.lineup.allPlayerEvents().count {
            indexPaths.append(NSIndexPath(forRow: i, inSection: lineupIndex))
        }
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        tableView.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: lineupIndex), animated: true, scrollPosition: .Middle)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchContests()
    }
    
    func fetchContests() {
        let sport = SportType.MLB
        let query = PFContestLineup.leagueContestLineupsQuery(sport, contest:contest)
        query?.findObjectsInBackgroundWithBlock({ (contestLineups, error) -> Void in
            if let contestLineups = contestLineups as? [PFContestLineup] {
                self.contestLineups = contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
                self.contestLineups += contestLineups
            }
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toPlayerEvent") {
            if let vc = segue.destinationViewController as? PlayerEventViewController {
                vc.playerEvent = sender as! PFPlayerEvent
            }
        }
    }
    

}

extension LeagueContestViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return contestLineups.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 1
        if (selectedLineup == section) {
            let contestLineup = contestLineups[section]
            rows += contestLineup.lineup.allPlayerEvents().count
        }
        return rows
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.row == 0) {
            return 55
        } else {
            return 40
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let contestLineup = contestLineups[indexPath.section]
            let cell = tableView.dequeueReusableCellWithIdentifier("ResultLineupCell", forIndexPath: indexPath) as! ResultLineupTableViewCell
            cell.configureWithLineup(contestLineup.lineup, delegate: self)
            cell.selected = indexPath.section == selectedLineup
            return cell
        } else {
            let contestLineup = contestLineups[indexPath.section]
            let playerEvent = contestLineup.lineup.allPlayerEvents()[indexPath.row-1]
            let cell = tableView.dequeueReusableCellWithIdentifier("PlayerEventCell", forIndexPath: indexPath) as! PlayerEventTableViewCell
            cell.configureWithPlayerEvent(playerEvent)
            return cell
        }

    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == 0) {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            changeSelectedLineup(nil)
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let contestLineup = contestLineups[indexPath.section]
            let playerEvent = contestLineup.lineup.allPlayerEvents()[indexPath.row-1]
            performSegueWithIdentifier("toPlayerEvent", sender: playerEvent)
        }
    }
    
}

extension LeagueContestViewController: LineupTableViewCellDelegate {
    
    func lineupCellDropdownTapped(cell: UITableViewCell, selected: Bool) {
        if let indexPath = tableView.indexPathForCell(cell) {
            changeSelectedLineup(indexPath.section)
        }
    }
    
}