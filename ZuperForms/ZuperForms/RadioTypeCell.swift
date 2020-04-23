//
//  RadioTypeCell.swift
//  ZuperFormsSdk
//
//  Created by Apple on 19/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit

class RadioTypeCell: UITableViewCell {

    @IBOutlet weak var imageTypeView: UIImageView! {
        didSet{
            imageTypeView.tintColor = getLabelTextColor()
        }
    }
    @IBOutlet weak var lblOption: UILabel! {
        didSet{
            lblOption.textColor = getLabelTextColor()
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

    /// Set Details in the cell for type "RADIO"
    /// - Parameter options: FieldOption Object
    func setRadioDetails(option: FieldOption)
    {
        lblOption.text = option.option
        if option.isSelected
        {
            imageTypeView.image = returnImage("icon-radioChecked")
        }
        else
        {
            imageTypeView.image = returnImage("icon-radio")
        }
        self.selectionStyle = .none
    }
}
