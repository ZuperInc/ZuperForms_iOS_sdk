//
//  SectionCell.swift
//  COVID-19
//
//  Created by Apple on 17/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SectionCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel! {
        didSet{
            lblTitle.textColor = getLabelTextColor()
        }
    }
    @IBOutlet weak var lblDescription: UILabel! {
        didSet{
            lblDescription.textColor = getLabelTextColor()
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
