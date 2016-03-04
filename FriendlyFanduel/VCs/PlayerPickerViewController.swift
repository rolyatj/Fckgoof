//
//  PlayerPickerViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

protocol PlayerPickerViewControllerDelegate {
    func didSelectPlayerEvent(playerEvent: PFPlayerEvent)
}

class PlayerPickerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    var event: PFEvent!
    var disabledPlayerEventIds = [String]()
    var filterType = 0
    var playerEvents = [PFPlayerEvent]() {
        didSet {
            self.filter()
        }
    }
    var playerEventsFiltered = [PFPlayerEvent]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var delegate: PlayerPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchPlayerEvents()
    }
     /*
        let headerHeight = self.tableView.tableHeaderView?.bounds.height ?? 0
        self.tableView.contentInset = UIEdgeInsetsMake(-headerHeight, 0, 0, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-headerHeight, 0, 0, 0);
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if let frame = self.tableView.tableHeaderView?.frame {
            let intersect = CGRectIntersectsRect(frame, view.frame)
            let headerHeight = self.tableView.tableHeaderView?.bounds.height ?? 0
            if (intersect) {
                self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            } else {
                self.tableView.contentInset = UIEdgeInsetsMake(-headerHeight, 0, 0, 0);
                self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(-headerHeight, 0, 0, 0);
            }
        }

    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var contentOffset = self.tableView.contentOffset
        let headerHeight = self.tableView.tableHeaderView?.bounds.height ?? 0
        contentOffset.y += headerHeight
        self.tableView.contentOffset = contentOffset
    }
    */
    
    func fetchPlayerEvents() {
        if let playerQuery = PFPlayer.query() {
            playerQuery.fromLocalDatastore()
            playerQuery.whereKey("type", equalTo: filterType)
            let query = PFPlayerEvent.queryWithIncludes()
            query?.fromLocalDatastore()
            query?.whereKey("objectId", notContainedIn: disabledPlayerEventIds)
            query?.whereKey("player", matchesQuery: playerQuery)
            query?.findObjectsInBackgroundWithBlock({ (playerEvents, error) -> Void in
                if let playerEvents = playerEvents as? [PFPlayerEvent] {
                    self.playerEvents = playerEvents
                }
            })
        }
    }
    
    @IBAction func searchTextFieldChanged(sender: AnyObject) {
        filter()
    }
    
    func filter() {
        if let text = searchTextField.text?.lowercaseString where text.characters.count > 0 {
            playerEventsFiltered = playerEvents.filter({ (playerEvent) -> Bool in
                let playerName = playerEvent.player?.name?.lowercaseString.containsString(text) ?? false
                return playerName
            })
        } else {
            playerEventsFiltered = playerEvents
        }
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

extension PlayerPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerEventsFiltered.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("PlayerCell", forIndexPath: indexPath)
        let playerEvent = playerEventsFiltered[indexPath.row]
        cell.textLabel?.text = playerEvent.player.name
        cell.detailTextLabel?.text = "\(playerEvent.salary)"
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let playerEvent = playerEventsFiltered[indexPath.row]
        delegate?.didSelectPlayerEvent(playerEvent)
        navigationController?.popViewControllerAnimated(true)
    }
    
}