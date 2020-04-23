//
//  SingleTextFieldCell.swift
//  ZuperFormsSdk
//
//  Created by Apple on 19/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit

class SingleTextFieldCell: UITableViewCell {

    @IBOutlet weak var textField: UITextField! {
        didSet{
            textField.textColor = getTextFieldTextColor()
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

    
    /// Set Details in the cell for type "TEXT"
    /// - Parameter checklistQuestion: ChecklistQuestion Object
    func textDetails(checklistQuestion: ChecklistQuestion)
    {
        textField.keyboardType = .asciiCapable
        if checklistQuestion.fieldAnswer != EMPTY
        {
            textField.text = checklistQuestion.fieldAnswer
        }
        self.selectionStyle = .none
    }
    
    /// Set Details in the cell for type "NUMBER"
    /// - Parameter checklistQuestion: ChecklistQuestion Object
    func numberDetails(checklistQuestion: ChecklistQuestion)
    {
        textField.keyboardType = .numberPad
        if checklistQuestion.fieldAnswer != EMPTY
        {
            textField.text = checklistQuestion.fieldAnswer
        }
        self.selectionStyle = .none
    }
}
