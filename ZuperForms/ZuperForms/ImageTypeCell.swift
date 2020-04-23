//
//  ImageTypeCell.swift
//  ZuperFormsSdk
//
//  Created by Apple on 21/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit

class ImageTypeCell: UITableViewCell {

    @IBOutlet weak var mainView: CornerRadiusView!
    @IBOutlet weak var imageWrapperView: CornerRadiusView!
    @IBOutlet weak var addImageBtn: UIButton! {
        didSet{
            addImageBtn.tintColor = getLabelTextColor()
            addImageBtn.setTitleColor(getLabelTextColor(), for: .normal)
        }
    }
    @IBOutlet weak var deleteBtn: UIButton!
    @IBOutlet weak var selectedImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    /// Set Details in the cell for type "IMAGE"
    /// - Parameter checklistQuestion: ChecklistQuestion Object
    func setImageTypeView(checklistQuestion: ChecklistQuestion)
    {
        if checklistQuestion.fieldAnswer != EMPTY
        {
            mainView.isHidden = true
            imageWrapperView.isHidden = false
            selectedImageView.image = checklistQuestion.selectedImage
        }
        else
        {
            mainView.isHidden = false
            imageWrapperView.isHidden = true
            addImageBtn.setTitle(" Click to add the image", for: .normal)
        }
        self.selectionStyle = .none
    }

}
