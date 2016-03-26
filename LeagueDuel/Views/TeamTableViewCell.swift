//
//  TeamTableViewCell.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/25/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit
import SDWebImage

class TeamTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var teamImageView: UIImageView!
    
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
        teamImageView.sd_cancelCurrentImageLoad()
    }
    
    func configureWithDuelTeam(duelTeam: PFDuelTeam) {
        nameLabel.text = duelTeam.name
        if let imageURL = duelTeam.imageURL, let url = NSURL(string: imageURL) {
            teamImageView.sd_setImageWithURL(url, placeholderImage: UIImage(named:"Team-96"))
        }
    }

    
}
