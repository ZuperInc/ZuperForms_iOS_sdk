//
//  ChecklistDetailController.swift
//  ZuperFormsSdk
//
//  Created by Zuper on 19/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit

class ChecklistDetailController: UIViewController {
    
    @IBOutlet weak var headerView: UIView!{
        didSet{
            headerView.backgroundColor = ZuperFormsTheme.primaryColor
        }
    }
    @IBOutlet weak var prevButton: UIButton!{
        didSet{
            prevButton.backgroundColor = ZuperFormsTheme.buttonPreviousColor
            prevButton.setTitleColor(ZuperFormsTheme.buttonPreviousTextColor, for: .normal)
            prevButton.addTarget(self, action: #selector(previousButAction(_:)), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var nextButton: UIButton!{
        didSet{
            nextButton.backgroundColor = ZuperFormsTheme.buttonSubmitNextColor
            nextButton.setTitleColor(ZuperFormsTheme.buttonSubmitNextTextColor, for: .normal)
            nextButton.addTarget(self, action: #selector(nextButAction(_:)), for: .touchUpInside)
        }
    }
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var progressView: UIProgressView!{
        didSet{
            progressView.trackTintColor = ZuperFormsTheme.backgroundColor
            progressView.tintColor = ZuperFormsTheme.progressBarColor
            let transform : CGAffineTransform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            progressView.transform = transform
            progressView.layer.cornerRadius = 6
            progressView.layer.masksToBounds = true
            progressView.setProgress(0.0, animated: false)
        }
    }
    @IBOutlet weak var lblPercentage: UILabel!{
        didSet{
            lblPercentage.text = "0% completed"
        }
    }
    @IBOutlet weak var lblUserName: UILabel!{
        didSet{
            lblUserName.text = "Hi, \(getUserName())"
        }
    }
    
    //MARK:- Variable Declaration
    var checklist: Checklist!
    var checklistQuestions:[ChecklistQuestion] = []
    var currentIndex: Int = 0
    var emptyStateTitle: String!
    var emptyStateMsg: String!
    var emptyStateImg: String!
    var attachmentArray:[AttachmentModel] = []
    var checkListDetailObj: CheckListDetailViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkListDetailObj = CheckListDetailViewModel(vc:self)
        checkListDetailObj.setDefaults()
        // Do any additional setup after loading the view.
    }
    
    
    /// Pervious Button Action
    /// - Parameter sender: sender
    @objc func previousButAction(_ sender:UIButton){
        checkListDetailObj.previousButAction()
    }
    
    
    /// Next Button Action
    /// - Parameter sender: sender
    @objc func nextButAction(_ sender:UIButton){
        checkListDetailObj.nextButAction()
    }
}

