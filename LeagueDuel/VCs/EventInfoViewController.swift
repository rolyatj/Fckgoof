//
//  EventInfoViewController.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/28/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class EventInfoViewController: UIViewController {

    @IBOutlet weak var textView: UITextView!
    var event: PFEvent!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupText()
        navigationItem.title = event.name
        navigationItem.prompt = event.dateString(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeTapped(sender: AnyObject?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func setupText() {
        var text = ""
        if let event = event, let sport = event.dynamicType.sport(), let dateString = event.dateString(true) {
            text += "--INFO--\n\n"
            text += "This is an \(sport.name()) event between the dates \(dateString). All games played during the event will score points for your chosen lineup. The team with the most points scored over the course of the event is the winner. All stats and scores are at the discretion of League  Duel. This is intended to be a fun way to follow the real season!\n\n"
        }
        text += "\n--SCORING--\n"
        text += "\nPITCHERS\n"
        text += "Wins (per game) +10\n"
        text += "Losses (per game) -10\n"
        text += "Strikeouts (per game) +2\n"
        text += "Earned Runs Allowed (per game) -3\n"
        text += "Walks Allowed (per game) -0.5\n"
        text += "Hits Allowed (per game) -0.5\n"
        text += "Innings Pitched (per game) +1\n"
        
        text += "\nHITTERS\n"
        text += "Hits (per game) +6\n"
        text += "Home Runs (per game) +12\n"
        text += "Runs Batted In (per game) +3\n"
        text += "Runs Scored (per game) +3\n"
        text += "Walks Taken (per game) +3\n"
        text += "Stolen Bases (per game) +6\n"
        text += "Hit By Pitch Taken (per game) +3\n"
        text += "\n* a game played is determined by at least one batter faced (for pitchers) or at least one at bat (for hitters)"
        
        textView.text = text
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
