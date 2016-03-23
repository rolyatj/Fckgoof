//
//  LeaguesViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class LeaguesViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var leagues = [PFLeague]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "fetchLeagues", name: "pinnedMyLeagues", object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        fetchLeagues()
    }
    
    func fetchLeagues() {
        let query = PFLeague.myLeaguesQuery()
        query?.fromLocalDatastore()
        query?.findObjectsInBackgroundWithBlock({ (leagues, error) -> Void in
            if let leagues = leagues as? [PFLeague] {
                self.leagues = leagues
            }
        })
    }

    func showLeague(league: PFLeague) {
        performSegueWithIdentifier("toLeague", sender: league)
    }
    
    @IBAction func joinLeagueTapped(sender: AnyObject) {
        let alertController = UIAlertController(title: "Join League", message: "What's the unique ID?", preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "10 Character ID"
        }
        let okAction = UIAlertAction(title: "Join", style: .Default) { (action) -> Void in
            if let text = alertController.textFields?.first?.text where text.characters.count == 10 {
                self.findLeague(text)
            } else {
                // TODO
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
                self.joinLeague(league)
            } else {
                // TODO
            }
        })
    }
    
    func joinLeague(league: PFLeague) {
        // TODO PFDueler
        if let user = PFDueler.currentUser(), let objectId = user.objectId {
            league.addUniqueObject(objectId, forKey: "duelers")
            league.saveEventually({ (success, error) -> Void in
                self.fetchLeagues()
            })
        }
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
        }
    }

}

extension LeaguesViewController: CreateLeagueViewControllerDelegate {
    
    func didCreateLeague(league: PFLeague) {
        //TODO share.
    }
    
}

extension LeaguesViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
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