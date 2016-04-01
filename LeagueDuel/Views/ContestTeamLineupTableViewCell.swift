//
//  ContestTeamLineupTableViewCell.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import SDWebImage

class ContestTeamLineupTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    @IBOutlet weak var sportImageView: UIImageView!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var lineupLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var bgView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        bgView.layer.borderColor = UIColor.lightGrayColor().CGColor
        bgView.layer.borderWidth = 0.5
        bgView.layer.shadowRadius = 4
        bgView.layer.shadowOpacity = 0.4
        bgView.layer.shadowOffset = CGSizeMake(0,1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        teamImageView?.sd_cancelCurrentImageLoad()
    }

    func configureWithContestLineup(contestLineup: PFContestLineup) {
        nameLabel.text = contestLineup.lineup.duelTeam.name
        descriptionLabel.text = contestLineup.contest.league.name
        if let imageURL = contestLineup.lineup.duelTeam.imageURL, let url = NSURL(string: imageURL) {
            teamImageView?.sd_setImageWithURL(url, placeholderImage: UIImage(named:"Team-96"))
        }
        eventLabel.text = contestLineup.contest.event.name
        dateLabel.text = contestLineup.contest.event.dateString(false)
        lineupLabel.text = contestLineup.lineup.rosterString()
        progressView.progress = contestLineup.lineup.percentRemaining()
        pointsLabel.text = "\(contestLineup.lineup.points)"
        if let sport = contestLineup.dynamicType.sport() {
            sportImageView.image = UIImage(named: sport.imageName())
        }
    }
    
}
