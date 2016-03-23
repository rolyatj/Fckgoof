//
//  LeagueViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class LeagueViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var league: PFLeague!
    var contests = [PFContest]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    var duelTeams = [PFDuelTeam]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = league.name?.uppercaseString
        
        if (league.isCommissioner()) {
            let editButton = UIBarButtonItem(title: "Edit", style: .Plain, target: self, action: "editLeague")
            navigationItem.rightBarButtonItem = editButton
        }
        fetchDuelTeams()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    func fetchEvents() {
        let sport = SportType.MLB
        let query = PFContest.leagueContestsQuery(league, sport: sport)
        query?.findObjectsInBackgroundWithBlock({ (contests, error) -> Void in
            if let contests = contests as? [PFContest] {
                self.contests = contests
            }
        })
    }
    
    func fetchDuelTeams() {
        let query = PFDuelTeam.query()
        query?.whereKey("league", equalTo: league)
        query?.orderByAscending("createdAt")
        query?.findObjectsInBackgroundWithBlock({ (duelTeams, error) -> Void in
            if let duelTeams = duelTeams as? [PFDuelTeam] {
                self.duelTeams = duelTeams
            }
        })
    }
    
    func editLeague() {
        performSegueWithIdentifier("toEditLeague", sender: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toEditLeague") {
            if let editLeagueVC = segue.destinationViewController as? EditLeagueViewController {
                editLeagueVC.league = league
            }
        }
    }

}

extension LeagueViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return contests.count
        } else {
            return duelTeams.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if (indexPath.section == 0) {
            return 78
        } else {
            return 44
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (indexPath.section == 0) {
            let contest = contests[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("ContestCell", forIndexPath: indexPath) as! ContestTableViewCell
            cell.configureWithContest(contest)
            return cell
        } else {
            let duelTeam = duelTeams[indexPath.row]
            let cell = tableView.dequeueReusableCellWithIdentifier("DuelTeamCell", forIndexPath: indexPath)
            cell.textLabel?.text = duelTeam.name
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
}
