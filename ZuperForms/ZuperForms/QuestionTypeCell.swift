//
//  QuestionTypeCell.swift
//  ZuperFormsSdk
//
//  Created by Apple on 19/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit

class QuestionTypeCell: UITableViewCell {

    @IBOutlet weak var lblQuestion: UILabel! {
        didSet{
            lblQuestion.textColor = getLabelTextColor()
        }
    }
    @IBOutlet weak var lblQuestionDescription: UILabel! {
        didSet{
            lblQuestionDescription.textColor = getLabelTextColor()
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

    func setQuestionDetails(checklistQuestion: ChecklistQuestion)
    {
        lblQuestion.text = checklistQuestion.fieldName ?? EMPTY
        if checklistQuestion.isMandatory ?? false
        {
            lblQuestion.attributedText = getAttributedString(text: checklistQuestion.fieldName ?? EMPTY)
        }
        lblQuestionDescription.text = "Ensuring your safety"
        self.selectionStyle = .none
    }
}
