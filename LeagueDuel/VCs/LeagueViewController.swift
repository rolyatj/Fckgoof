//
//  LeagueViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class LeagueViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var league: PFLeague!
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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchDuelTeams()
    }
    
    func fetchDuelTeams() {
        let query = PFDuelTeam.query()
        query?.whereKey("league", equalTo: league)
        query?.orderByAscending("createdAt")
        query?.cachePolicy = PFCachePolicy.CacheThenNetwork

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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return duelTeams.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let duelTeam = duelTeams[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier("DuelTeamCell", forIndexPath: indexPath)
        cell.textLabel?.text = duelTeam.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let duelTeam = duelTeams[indexPath.row]
        if let vc = storyboard?.instantiateViewControllerWithIdentifier("DuelTeamVC") as? LeagueDuelTeamViewController {
            vc.duelTeam = duelTeam
            vc.league = league
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
}
