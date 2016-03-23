//
//  LineupTableViewCell.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit


class ResultLineupTableViewCell: LineupTableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankProgressView: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func configureWithLineup(lineup: PFLineup, delegate: LineupTableViewCellDelegate?) {
        super.configureWithLineup(lineup, delegate: delegate)
        rankLabel.text = "\(lineup.rank)"
        scoreLabel.text = "\(lineup.score)"
        var percentRemaining : Float = 0.0
        let playerEvents = lineup.allPlayerEvents()
        for playerEvent in playerEvents {
            percentRemaining += playerEvent.percentRemaining
        }
        if (playerEvents.count > 0) {
            rankProgressView.progress = percentRemaining/Float(playerEvents.count)
        }
    }
    
}

protocol LineupTableViewCellDelegate {
    func lineupCellDropdownTapped(cell:UITableViewCell, selected:Bool)
}

class LineupTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var sportLabel: UILabel?
    @IBOutlet weak var descriptionLabel: UILabel?
    @IBOutlet weak var toggleButton: UIButton!
    var delegate: LineupTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        var rotation = CGAffineTransformMakeRotation(CGFloat(0))
        if (selected) {
            rotation = CGAffineTransformMakeRotation(CGFloat(-M_PI))
        }
        
        self.layoutIfNeeded()
        if (animated) {
            UIView.animateWithDuration(0.3) { () -> Void in
                self.toggleButton.transform = rotation
            }
        } else {
            self.toggleButton.transform = rotation
        }
    }

    func configureWithLineup(lineup: PFLineup, delegate: LineupTableViewCellDelegate?) {
        nameLabel.text = lineup.duelTeam.name
        sportLabel?.text = "TODO"//lineup.event.sport.name
        descriptionLabel?.text = "TODO"
        self.delegate = delegate
    }

    @IBAction func lineupCellDropdownTapped(sender: UIButton) {
        delegate?.lineupCellDropdownTapped(self, selected: sender.selected)
    }
}
