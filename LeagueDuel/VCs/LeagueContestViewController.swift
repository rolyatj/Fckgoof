//
//  LeagueContestViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class LeagueContestViewController: UIViewController {

    @IBOutlet weak var tableView: LeagueContestTableView!
    var contest: PFContest!
    var contestLineups = [PFContestLineup]() {
        didSet {
            self.tableView?.contestLineups = contestLineups
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.lcDelegate = self
        fetchContests(true)
    }
    
    func fetchContests(isFirstTime: Bool) {
        if let sport = contest!.dynamicType.sport() {
            let query = PFContestLineup.leagueContestLineupsQuery(sport, contest:contest)
            if (contest.event.isLive()) {
                if (isFirstTime) {
                    query?.cachePolicy = PFCachePolicy.CacheThenNetwork
                } else {
                    query?.cachePolicy = PFCachePolicy.NetworkOnly
                }
            } else {
                query?.cachePolicy = PFCachePolicy.IgnoreCache
            }
            query?.findObjectsInBackgroundWithBlock({ (contestLineups, error) -> Void in
                if let contestLineups = contestLineups as? [PFContestLineup] {
                    self.contestLineups = contestLineups
                }
            })
            self.performSelector("fetchContests:", withObject: false, afterDelay: 30)
        }
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
        } else if (segue.identifier == "toDuelTeam") {
            if let vc = segue.destinationViewController as? LeagueDuelTeamViewController {
                vc.duelTeam = sender as! PFDuelTeam
                vc.league = contest.league
            }
        }
    }
    

}

extension LeagueContestViewController: LeagueContestTableViewDelegate {
    
    func duelTeamTapped(duelTeam: PFDuelTeam) {
        performSegueWithIdentifier("toDuelTeam", sender:duelTeam)
    }
    
    func playerEventTapped(playerEvent: PFPlayerEvent) {
        performSegueWithIdentifier("toPlayerEvent", sender: playerEvent)
    }
    
}

protocol LeagueContestTableViewDelegate {
    func duelTeamTapped(duelTeam: PFDuelTeam)
    func playerEventTapped(playerEvent: PFPlayerEvent)
}

class LeagueContestTableView: UITableView, UITableViewDataSource, UITableViewDelegate {
    
    var lcDelegate: LeagueContestTableViewDelegate?
    var contestLineups = [PFContestLineup]() {
        didSet {
            self.reloadData()
        }
    }
    var selectedLineup: Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.delegate = self
        self.dataSource = self
    }
    
    func changeSelectedLineup(newSelectedLineup: Int?) {
        self.beginUpdates()
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
        self.endUpdates()
        if let newSelectedLineup = newSelectedLineup {
            self.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: newSelectedLineup), atScrollPosition: .Top, animated: true)
        }
    }
    
    func deselectLineup(lineupIndex: Int) {
        let contestLineup = contestLineups[lineupIndex]
        var indexPaths = [NSIndexPath]()
        for i in 1...contestLineup.lineup.allPlayerEvents().count {
            indexPaths.append(NSIndexPath(forRow: i, inSection: lineupIndex))
        }
        self.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        self.deselectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: lineupIndex), animated: true)
    }
    
    func selectLineup(lineupIndex: Int) {
        let contestLineup = contestLineups[lineupIndex]
        var indexPaths = [NSIndexPath]()
        for i in 1...contestLineup.lineup.allPlayerEvents().count {
            indexPaths.append(NSIndexPath(forRow: i, inSection: lineupIndex))
        }
        self.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        self.selectRowAtIndexPath(NSIndexPath(forRow: 0, inSection: lineupIndex), animated: true, scrollPosition: .Middle)
    }
    
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
            let contestLineup = contestLineups[indexPath.section]
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            changeSelectedLineup(nil)
            lcDelegate?.duelTeamTapped(contestLineup.lineup.duelTeam)

        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let contestLineup = contestLineups[indexPath.section]
            let playerEvent = contestLineup.lineup.allPlayerEvents()[indexPath.row-1]
            lcDelegate?.playerEventTapped(playerEvent)
        }
    }
    
}

extension LeagueContestTableView: LineupTableViewCellDelegate {
    
    func lineupCellDropdownTapped(cell: UITableViewCell, selected: Bool) {
        if let indexPath = self.indexPathForCell(cell) {
            changeSelectedLineup(indexPath.section)
        }
    }
    
}