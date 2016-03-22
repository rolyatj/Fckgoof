//
//  PlayerPickerViewController.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/4/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import ParseUI

protocol PlayerPickerViewControllerDelegate {
    func playerPickerDidCancel()
    func playerPickerDidSelectPlayerEvent(playerEvent: PFPlayerEvent)
}

class PlayerPickerViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var isSearching = false {
        didSet {
            searchBar.hidden = !isSearching
            searchBar.text = nil
            if (isSearching) {
                searchBar.becomeFirstResponder()
                if let tableHeaderView = tableView.tableHeaderView {
                    tableView.scrollRectToVisible(tableHeaderView.frame, animated: true)
                }
            } else {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    var editableContestLineup: EditableContestLineup! {
        didSet {
            self.delegate = editableContestLineup
        }
    }

    var playerEvents = [PFPlayerEvent]() {
        didSet {
            self.filter(nil)
        }
    }
    var playerEventsFiltered = [PFPlayerEvent]() {
        didSet {
            self.tableView?.reloadData()
        }
    }
    var delegate: PlayerPickerViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        isSearching = false
    }
    
    @IBAction func searchingTapped(sender: AnyObject) {
        isSearching = !isSearching
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
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filter(searchText)
    }
    
    func filter(searchText: String?) {
        if let searchText = searchText?.lowercaseString where searchText.characters.count > 0 && isSearching {
            playerEventsFiltered = playerEvents.filter({ (playerEvent) -> Bool in
                let playerName = playerEvent.player?.name?.lowercaseString.containsString(searchText) ?? false
                return playerName
            })
        } else {
            playerEventsFiltered = playerEvents
        }
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        delegate?.playerPickerDidCancel()
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toSelectablePlayerEvent") {
            if let vc = segue.destinationViewController as? SelectablePlayerEventViewController {
                vc.playerEvent = sender as! PFPlayerEvent
                vc.delegate = self.delegate
                vc.editableContestLineup = editableContestLineup
            }
        }
    }
    
}

extension PlayerPickerViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playerEventsFiltered.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("SelectablePlayerEventCell", forIndexPath: indexPath) as! SelectablePlayerEventTableViewCell
        let playerEvent = playerEventsFiltered[indexPath.row]
        cell.configureWithPlayerEvent(playerEvent)
        cell.delegate = self
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let playerEvent = playerEventsFiltered[indexPath.row]
        performSegueWithIdentifier("toSelectablePlayerEvent", sender: playerEvent)
    }
    
}

extension PlayerPickerViewController: SelectablePlayerEventTableViewCellDelegate {
    func selectTapped(cell: SelectablePlayerEventTableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let playerEvent = playerEventsFiltered[indexPath.row]
            delegate?.playerPickerDidSelectPlayerEvent(playerEvent)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
}