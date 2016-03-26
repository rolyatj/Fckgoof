//
//  CreateLeagueViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import SDWebImage

protocol CreateLeagueViewControllerDelegate {
    func didJoinLeague(league: PFLeague, shouldPromptShare: Bool)
}

class CreateLeagueViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    
    var league = PFLeague()
    var delegate: CreateLeagueViewControllerDelegate?

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
        let alertController = UIAlertController(title: "League Image", message: nil, preferredStyle: .Alert)
        alertController.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = "Image URL (ex: www.example.com/url.png)"
        }
        let okAction = UIAlertAction(title: "Save", style: .Default) { (action) -> Void in
            if let text = alertController.textFields?.first?.text {
                self.league.imageURL = text
                if let url = NSURL(string: text) {
                    self.imageView.sd_setImageWithURL(url)
                }
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
        if let errorMessage = league.isValid() {
            showErrorPopup(errorMessage, completion: nil)
        } else {
            performSegueWithIdentifier("toCreateTeam", sender: nil)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toCreateTeam") {
            if let createTeamVC = segue.destinationViewController as? CreateTeamViewController {
                createTeamVC.league = league
                createTeamVC.isNewLeague = true
                createTeamVC.delegate = delegate
            }
        }
    }

}

extension CreateLeagueViewController: UITableViewDataSource, UITableViewDelegate, TextFieldTableViewCellDelegate {

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InputCell", forIndexPath: indexPath) as! TextFieldTableViewCell
        cell.delegate = self
        if (indexPath.row == 0) {
            cell.textField.placeholder = "League Name"
        } else {
            cell.textField.placeholder = "Tagline (optional)"
        }
        
        return cell
    }
    
    func textChanged(cell: TextFieldTableViewCell, text: String?) {
        if let indexPath = self.tableView.indexPathForCell(cell) {
            if (indexPath.row == 0) {
                league.name = text
            } else {
                league.tagline = text
            }
        }
    }
    
}
