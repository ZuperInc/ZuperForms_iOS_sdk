//
//  MultilineCell.swift
//  ZuperFormsSdk
//
//  Created by Apple on 19/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit

class MultilineCell: UITableViewCell {

    @IBOutlet weak var textView: UITextView! {
        didSet{
            textView.textColor = getTextFieldTextColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
