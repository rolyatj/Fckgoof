//
//  PlayerEventTableViewCell.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/22/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

protocol SelectablePlayerEventTableViewCellDelegate {
    func selectTapped(cell: SelectablePlayerEventTableViewCell)
}

class SelectablePlayerEventTableViewCell: PlayerEventTableViewCell {
    
    @IBOutlet weak var selectButton: UIButton!
    var delegate: SelectablePlayerEventTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func configureWithPlayerEvent(playerEvent: PFPlayerEvent) {
        super.configureWithPlayerEvent(playerEvent)
        statusLabel.text = "$\(playerEvent.salary)"
        infoLabel.text = playerEvent.player.team?.teamName
    }
    
    @IBAction func selectTapped(sender: AnyObject) {
        delegate?.selectTapped(self)
    }
    
}


class PlayerEventTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureWithPlayerEvent(playerEvent: PFPlayerEvent) {
        nameLabel.text = playerEvent.player.name
        positionLabel.text = playerEvent.player.position
        statusLabel.text = "\(playerEvent.result.PTS)"
        infoLabel.text = playerEvent.result.resultString()
        progressView?.progress = playerEvent.percentRemaining
    }

}
