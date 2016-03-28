//
//  ProfileViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leaguesLabel: UILabel!
    @IBOutlet weak var contestsEnteredLabel: UILabel!
    @IBOutlet weak var contestsWonLabel: UILabel!

    var duelTeams = [PFDuelTeam]() {
        didSet {
            leaguesLabel?.text = "\(duelTeams.count)"
            var numberContestsEntered = 0
            var numberContestsWon = 0
            for duelTeam in duelTeams {
                numberContestsEntered += duelTeam.numberContestsEntered
                numberContestsWon += duelTeam.numberContestsWon
            }
            contestsEnteredLabel?.text = "\(numberContestsEntered)"
            contestsWonLabel?.text = "\(numberContestsWon)"
            tableView?.reloadData()
            if (duelTeams.count == 0) {
                let actionFooterView = FooterView.actionFooterView(self)
                tableView.tableFooterView = actionFooterView
            } else {
                tableView.tableFooterView?.removeFromSuperview()
                tableView.tableFooterView = UIView()
            }
        }
    }
    var shouldFetchOnAppear = false // TODO set this to true on league join.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchTeams(true)
        tableView.registerNib(UINib(nibName: "TeamTableViewCell", bundle: nil), forCellReuseIdentifier: "TeamCell")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if (shouldFetchOnAppear) {
            fetchTeams(false)
            shouldFetchOnAppear = false
        } else {
            tableView.reloadData()
        }
    }
    
    func fetchTeams(isFirstTime: Bool) {
        let query = PFDuelTeam.myTeamsQuery()
        if (!isFirstTime) {
            query?.cachePolicy = PFCachePolicy.CacheThenNetwork
        } else {
            query?.cachePolicy = PFCachePolicy.NetworkOnly
        }
        query?.findObjectsInBackgroundWithBlock({ (duelTeams, error) -> Void in
            if let duelTeams = duelTeams as? [PFDuelTeam] {
                self.duelTeams = duelTeams
            }
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toDuelTeam") {
            if let vc = segue.destinationViewController as? LeagueDuelTeamViewController {
                vc.duelTeam = sender as! PFDuelTeam
                vc.league = (sender as! PFDuelTeam).league
            }
        }
    }

}

extension ProfileViewController: FooterViewDelegate {
    func footerViewActionTapped() {
        tabBarController?.selectedIndex = 0
    }
}

extension ProfileViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duelTeams.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let team = duelTeams[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("TeamCell", forIndexPath: indexPath) as! TeamTableViewCell
        cell.configureWithDuelTeam(team, showLeague: true)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let team = duelTeams[indexPath.row]
        performSegueWithIdentifier("toDuelTeam", sender: team)
    }
    
}
