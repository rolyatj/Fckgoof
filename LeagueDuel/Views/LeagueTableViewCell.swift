//
//  LeagueTableViewCell.swift
//  FriendlyFanduel
//
//  Created by Kurt Jensen on 3/3/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import SDWebImage

class LeagueTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var leagueImageView: UIImageView!
    
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
        leagueImageView.sd_cancelCurrentImageLoad()
    }
    
    func configureWithLeague(league: PFLeague) {
        nameLabel.text = league.name
        descriptionLabel.text = league.tagline
        if let imageURL = league.imageURL, let url = NSURL(string: imageURL) {
            leagueImageView.sd_setImageWithURL(url)
        }
    }

}
