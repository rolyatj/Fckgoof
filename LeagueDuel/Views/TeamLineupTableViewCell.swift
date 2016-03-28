//
//  ContestLineupTableViewCell.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit


class ResultTeamLineupTableViewCell: TeamLineupTableViewCell {
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var rankProgressView: UIProgressView?
    @IBOutlet weak var contestLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func configureWithContestLineup(contestLineup: PFContestLineup, rank: Int, delegate: LineupTableViewCellDelegate?) {
        super.configureWithContestLineup(contestLineup, rank: rank, delegate: delegate)
        rankLabel.text = "\(rank)"
        scoreLabel.text = "\(contestLineup.lineup.points)"
        var percentRemaining : Float = 0.0
        let playerEvents = contestLineup.lineup.allPlayerEvents()
        for playerEvent in playerEvents {
            percentRemaining += playerEvent.percentRemaining
        }
        if (playerEvents.count > 0) {
            rankProgressView?.progress = percentRemaining/Float(playerEvents.count)
        }
        contestLabel?.text = contestLineup.contest.event.name
    }
    
}

protocol LineupTableViewCellDelegate {
    func lineupCellDropdownTapped(cell:UITableViewCell, selected:Bool)
}

class TeamLineupTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var duelTeamImageView: UIImageView!
    @IBOutlet weak var toggleButton: UIButton!
    var delegate: LineupTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        var rotation = CGAffineTransformMakeRotation(0)
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

    func configureWithContestLineup(contestLineup: PFContestLineup, rank: Int, delegate: LineupTableViewCellDelegate?) {
        if let imageURL = contestLineup.lineup.duelTeam.imageURL, let url = NSURL(string: imageURL) {
            duelTeamImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named:"Team-96"))
        }
        nameLabel.text = contestLineup.lineup.duelTeam.name
        self.delegate = delegate
    }

    @IBAction func lineupCellDropdownTapped(sender: UIButton) {
        delegate?.lineupCellDropdownTapped(self, selected: sender.selected)
    }
}
