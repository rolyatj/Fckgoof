//
//  ContestTableViewCell.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import SDWebImage

class ContestTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
    }
    
    func configureWithContest(contest: PFContest) {
        nameLabel.text = contest.event.name
        descriptionLabel.text = contest.league.name
    }
    
}
