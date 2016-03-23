//
//  MenuViewController.swift
//  GreenFinance
//
//  Created by Kurt Jensen on 3/17/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import SDWebImage

enum SettingsType : Int {
    case Feedback = 0
    case LinkedIn
    case Facebook
    case Twitter
    case Website
    
    case count
}

class MenuViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

extension MenuViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingsType.count.rawValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingsCell", forIndexPath: indexPath)
        switch (SettingsType(rawValue: indexPath.row)!) {
        case .Feedback:
            break

        case .LinkedIn:
            break

        case .Facebook:
            break

        case .Twitter:
            break

        case .Website:
            break
        default:
            break
        }
        return cell
    }
    
}

extension MenuViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        switch (SettingsType(rawValue: indexPath.row)!) {
        case .Feedback:
            break
            
        case .LinkedIn:
            break
            
        case .Facebook:
            break
            
        case .Twitter:
            break
            
        case .Website:
            break
        default:
            break
        }

    }
}
