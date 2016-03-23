//
//  ContestTableViewCell.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

class ContestTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureWithContestLineup(contestLineup: PFContestLineup) {
        nameLabel.text = contestLineup.lineup.duelTeam.name
        descriptionLabel.text = contestLineup.contest.league.name
    }
    
    func configureWithContest(contest: PFContest) {
        nameLabel.text = contest.event.name
        descriptionLabel.text = contest.league.name
    }
    
}
