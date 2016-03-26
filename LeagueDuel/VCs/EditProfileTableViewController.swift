//
//  EditProfileTableViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/25/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import Parse

class EditProfileTableViewController: UITableViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var pushNotificationsSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = PFDueler.currentUser()?.username?.uppercaseString
        usernameTextField.text = PFDueler.currentUser()?.username
        emailTextField.text = PFDueler.currentUser()?.email
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func pushNotificationsSwitchChanged(sender: UISwitch) {
        //TODO
    }
    
    @IBAction func saveTapped(sender: AnyObject) {
        if let user = PFDueler.currentUser() {
            user.username = usernameTextField.text?.lowercaseString
            user.email = emailTextField.text
            
            if let profileError = user.profileError() {
                self.showErrorPopup(profileError, completion: nil)
            } else {
                user.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if let error = error {
                        self.showErrorPopup(error.localizedDescription, completion: nil)
                    } else {
                        self.navigationController?.popViewControllerAnimated(true)
                    }
                })
            }
            
        }
    }
    
    @IBAction func logoutTapped(sender: AnyObject) {
        PFDueler.logOutInBackgroundWithBlock { (error) -> Void in
            PFQuery.clearAllCachedResults()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }

      /*
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
