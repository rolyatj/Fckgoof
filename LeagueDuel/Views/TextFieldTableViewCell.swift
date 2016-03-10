//
//  TextFieldTableViewCell.swift
//  LeagueDuel
//
//  Created by Kurt Jensen on 3/9/16.
//  Copyright © 2016 Arbor Apps LLC. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate {
    func textChanged(cell: TextFieldTableViewCell, text: String?)
}

class TextFieldTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    var delegate: TextFieldTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        let currentString = (textField.text ?? "") as NSString
        let text = currentString.stringByReplacingCharactersInRange(range, withString: string)
        delegate?.textChanged(self, text: text)
        return true
    }

}
