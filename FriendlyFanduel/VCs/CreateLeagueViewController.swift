//
//  CreateLeagueViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class CreateLeagueViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var leagueNameButton: UIButton!
    var leagueName = "" {
        didSet {
            if (leagueName.characters.count > 0) {
                leagueNameButton?.setTitle(leagueName, forState: .Normal)
            } else {
                leagueNameButton?.setTitle("League Name", forState: .Normal)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leagueNameTapped(sender: AnyObject) {
        editLeagueName()
    }
    
    func editLeagueName() {
        let alertController = UIAlertController(title: "League Name", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            // TODO
        }
        let okAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
            if let text = alertController.textFields?.first?.text {
                self.leagueName = text
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func saveTapped(sender: AnyObject) {
        save()
    }
    
    func save() {
        if (leagueName.characters.count > 0) {
            let league = PFLeague(name: leagueName)
            league.saveInBackgroundWithBlock({ (success, error) -> Void in
                if (success) {
                    // TODO SHARE
                    self.navigationController?.popViewControllerAnimated(true)
                } else {
                    // TODO
                }
            })
        } else {
            // TODO
        }
    }
    
    /*
    func changeSport() {
        let alertController = UIAlertController(title: "League Sport", message: nil, preferredStyle: .Alert)
        for sport in sports {
            let sportAction = UIAlertAction(title: sport.name, style: .Default) { (action) -> Void in
                self.sport = sport
            }
            alertController.addAction(sportAction)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }*/

}

extension CreateLeagueViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SportCell", forIndexPath: indexPath)
        cell.textLabel?.text = "Sport"
        //cell.detailTextLabel?.text = sport?.name
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        //changeSport()
    }
    
}
