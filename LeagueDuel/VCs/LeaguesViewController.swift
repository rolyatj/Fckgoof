//
//  LeaguesViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class LeaguesViewController: MessageViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var leagues = [PFLeague]() {
        didSet {
            self.tableView.reloadData()
            if (leagues.count == 0) {
                let actionFooterView = FooterView.actionFooterView(self)
                tableView.tableFooterView = actionFooterView
            } else {
                tableView.tableFooterView?.removeFromSuperview()
                tableView.tableFooterView = nil
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchLeagues(true)
        tableView.registerNib(UINib(nibName: "LeagueTableViewCell", bundle: nil), forCellReuseIdentifier: "LeagueCell")
    }
    
    func fetchLeagues(isFirstTime: Bool) {
        let query = PFLeague.myLeaguesQuery()
        if (isFirstTime) {
            query?.cachePolicy = PFCachePolicy.CacheThenNetwork
        } else {
            query?.cachePolicy = PFCachePolicy.NetworkOnly
        }
        query?.findObjectsInBackgroundWithBlock({ (leagues, error) -> Void in
            if let leagues = leagues as? [PFLeague] {
                self.leagues = leagues
            }
        })
    }

    func showLeague(league: PFLeague) {
        performSegueWithIdentifier("toLeague", sender: league)
    }
    
    @IBAction func joinLeagueTapped(sender: AnyObject?) {
        let alertController = UIAlertController(title: "Join League", message: "What's the unique ID?", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "10 Character ID"
        }
        let okAction = UIAlertAction(title: "Join", style: .Default) { (action) -> Void in
            if let text = alertController.textFields?.first?.text where text.characters.count == 10 {
                self.findLeague(text)
            } else {
                self.showErrorPopup("The League ID must be 10 characters.", completion: { 
                    self.joinLeagueTapped(nil)
                })
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    func findLeague(objectId: String) {
        let query = PFLeague.query()
        query?.getObjectInBackgroundWithId(objectId, block: { (league, error) -> Void in
            if let league = league as? PFLeague {
                if league.canAddAnotherMember() {
                    self.performSegueWithIdentifier("toCreateTeam", sender: league)
                } else {
                    self.showErrorPopup("The league has reached capacity.", completion: nil)
                }
            } else {
                self.showErrorPopup("Couldn't find league with id \(objectId)", completion: nil)
            }
        })
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toLeague") {
            if let leagueVC = segue.destinationViewController as? LeagueViewController {
                leagueVC.league = sender as! PFLeague
            }
        } else if (segue.identifier == "toCreateLeague") {
            if let createLeagueVC = segue.destinationViewController as? CreateLeagueViewController {
                createLeagueVC.delegate = self
            }
        } else if (segue.identifier == "toCreateTeam") {
            if let createTeamVC = segue.destinationViewController as? CreateTeamViewController {
                createTeamVC.delegate = self
                createTeamVC.league = sender as! PFLeague
            }
        }
    }

}

extension LeaguesViewController: FooterViewDelegate {
    func footerViewActionTapped() {
        performSegueWithIdentifier("toCreateLeague", sender: nil)
    }
}

extension LeaguesViewController: CreateLeagueViewControllerDelegate {
    
    func didJoinLeague(league: PFLeague, shouldPromptShare: Bool) {
        fetchLeagues(false)
        if (shouldPromptShare) {
            if let leagueId = league.objectId {
                // TODO branch links
                let body = "I set up a league for us on the LeagueDuel app, a free iOS app that keeps track of daily/weekly fantasy leagues for friends/family. Here's the league code so you can join in the fun! \(leagueId)"
                
                let alertController = UIAlertController(title: "Share League?", message: "In order for others to join they will need to enter the unique ID\n\n\(leagueId)", preferredStyle: .Alert)
                let textAction = UIAlertAction(title: "Join", style: .Default) { (action) -> Void in
                    self.sendText(body)
                }
                let emailAction = UIAlertAction(title: "Email", style: .Default) { (action) -> Void in
                    self.sendEmail(nil, subject: "Join My League on LeagueDuel", body: body)
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                alertController.addAction(cancelAction)
                alertController.addAction(textAction)
                alertController.addAction(emailAction)
                self.presentViewController(alertController, animated: true, completion: nil)
            }
        }
    }
    
}

extension LeaguesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return leagues.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LeagueCell", forIndexPath: indexPath) as! LeagueTableViewCell
        let league = leagues[indexPath.row]
        cell.configureWithLeague(league)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let league = leagues[indexPath.row]
        showLeague(league)
    }
    
}