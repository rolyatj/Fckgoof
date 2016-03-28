//
//  CreateTeamViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class CreateTeamViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var league: PFLeague!
    var duelTeam = PFDuelTeam()
    var delegate: CreateLeagueViewControllerDelegate?
    var isNewLeague = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func leagueImageTapped(sender: AnyObject) {
        changeLeagueImage()
    }
    
    func changeLeagueImage() {
        let alertController = UIAlertController(title: "Team Image", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Image URL (ex: www.example.com/url.png)"
        }
        let okAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
            if let text = alertController.textFields?.first?.text {
                self.duelTeam.imageURL = text
                if let url = NSURL(string: text) {
                    self.imageView.sd_setImageWithURL(url, placeholderImage: UIImage(named:"Camera-104"))
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    @IBAction func saveTapped(sender: AnyObject) {
        saveLeagueIfNeededThenTeam()
    }
    
    func saveLeagueIfNeededThenTeam() {
        if let errorMessage = duelTeam.errorMessageIfInvalid() {
            showErrorPopup(errorMessage, completion: nil)
        } else {
            if (isNewLeague) {
                league.commissioner = PFDueler.currentUser()!
                saveLeagueAndTeam()
            } else {
                trySaveTeam()
            }
        }

    }
    
    func trySaveTeam() {
        let query = PFDuelTeam.query()
        query?.whereKey("league", equalTo: league)
        query?.whereKey("dueler", equalTo: PFDueler.currentUser()!)
        query?.countObjectsInBackgroundWithBlock({ (count, error) -> Void in
            if (count > 0) {
                self.showErrorPopup("You have already joined this league. You can only have one team per user per league.", completion: {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                })
            } else {
                self.saveLeagueAndTeam()
            }
        })
    }
    
    func saveLeagueAndTeam() {
        duelTeam.league = league
        duelTeam.dueler = PFDueler.currentUser()!
        league.addUniqueObject(PFDueler.currentUser()!.objectId!, forKey: "duelers")
        PFObject.saveAllInBackground([duelTeam, league], block: { (success, error) in
            if (success) {
                self.navigationController?.popToRootViewControllerAnimated(true)
                self.delegate?.didJoinLeague(self.league, shouldPromptShare: self.isNewLeague)
            }
        })
    }
    
}

extension CreateTeamViewController: UITableViewDataSource, UITableViewDelegate, TextFieldTableViewCellDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath) as! TextFieldTableViewCell
        cell.delegate = self
        if (indexPath.row == 0) {
            cell.textField.placeholder = "Team Name"
        } else {
            cell.textField.placeholder = "Tagline (optional)"
        }
        
        return cell
    }
    
    func textChanged(cell: TextFieldTableViewCell, text: String?) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            if (indexPath.row == 0) {
                duelTeam.name = text
            } else {
                //team.tagline = text
            }
        }
    }
    
}