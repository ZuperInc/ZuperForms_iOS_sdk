//
//  CheckListDetailViewModel.swift
//  ZuperFormsSdk
//
//  Created by Zuper on 21/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation
import UIKit
import EmptyStateKit
class CheckListDetailViewModel{
    
    var vc: ChecklistDetailController!
    
    init(vc: ChecklistDetailController) {
        self.vc = vc
    }
    
    /// Set EmptyState View
    func setEmptyStateView(){
        setEmptyState(view: vc!.view)
        vc?.view.emptyState.delegate = vc
        vc?.view.emptyState.dataSource = vc
        
    }
    
    /// Set Defaults
    func setDefaults()
    {
        self.setEmptyStateView()
        self.vc.view.backgroundColor = ZuperFormsTheme.backgroundColor
        self.vc.tableView.estimatedRowHeight = 100
        self.vc.tableView.estimatedSectionHeaderHeight = 100
        registerNibs()
        if checklistUid != nil && checklistUid != EMPTY {
            getChecklistDetails()
        }
        else {
            self.vc.title = self.vc.checklist.checklistName ?? EMPTY
           self.vc.checklistQuestions = self.vc.checklist.checklistQuestions ?? []
            setPreNextButtons()
            setFieldOptions()
        }
    }
    
    
    /// Register nib to load cell in tableview
    func registerNibs(){
        self.vc.tableView.register(UINib(nibName: xibNames.QuestionTypeCell, bundle: Bundle(for: QuestionTypeCell.self)), forCellReuseIdentifier: TableViewIdentifier.QuestionTypeCell)
        self.vc.tableView.register(UINib(nibName: xibNames.ImageTypeCell, bundle: Bundle(for: ImageTypeCell.self)), forCellReuseIdentifier: TableViewIdentifier.ImageTypeCell)
        self.vc.tableView.register(UINib(nibName: xibNames.SingleTextFieldCell, bundle: Bundle(for: SingleTextFieldCell.self)), forCellReuseIdentifier: TableViewIdentifier.SingleTextFieldCell)
        self.vc.tableView.register(UINib(nibName: xibNames.RadioTypeCell, bundle: Bundle(for: RadioTypeCell.self)), forCellReuseIdentifier: TableViewIdentifier.RadioTypeCell)
        self.vc.tableView.register(UINib(nibName: xibNames.CheckBoxTypeCell, bundle: Bundle(for: CheckBoxTypeCell.self)), forCellReuseIdentifier: TableViewIdentifier.CheckBoxTypeCell)
        self.vc.tableView.register(UINib(nibName: xibNames.MultilineCell, bundle: Bundle(for: MultilineCell.self)), forCellReuseIdentifier: TableViewIdentifier.MultilineCell)
    }
    
    func setPreNextButtons(){
        self.vc.currentIndex = 0
        self.vc.prevButton.isEnabled = true
        if self.vc.currentIndex == 0{
            self.vc.prevButton.isEnabled = false
        }
        if self.vc.checklistQuestions.count == 1{
            self.vc.nextButton.setTitle(submit, for: .normal)
            self.vc.prevButton.isHidden = true
        }
    }
    
    
    /// Previous Button logics(Progress view calculation, tableview data update)
    func previousButAction(){
        //if index is 0 -> disable previous button
        if self.vc.currentIndex == 0{
            self.vc.prevButton.isEnabled = false
        }else{
            //Decrease current index
            //Update progress view
            //update tableview
            self.vc.currentIndex -= 1
            self.setProgressView()
        }
        if vc?.checklistQuestions.count ?? 0 > self.vc.currentIndex{
            self.vc.nextButton.setTitle(next, for: .normal)
        }
        vc?.tableView.reloadData()
    }
    
    /// Next Button logics(Progress view calculation, tableview data update)
    func nextButAction(){
        if self.vc.nextButton.titleLabel?.text == submit{
            //Form Submission action
            self.setProgressView()
            self.checklistValidation()
            return
        }
        else{
            if vc?.checklistQuestions.count ?? 0 > self.vc.currentIndex{
                //Increment current index
                //Update progress view
                //update tableview
                self.vc.currentIndex += 1
                if self.vc.currentIndex > 0{
                    self.vc.prevButton.isEnabled = true
                }
                if ((vc?.checklistQuestions.count ?? 0) - 1) == self.vc.currentIndex{
                    //last index
                    //Set button title as 'Submit'
                    self.vc.nextButton.setTitle(submit, for: .normal)
                }
                self.setProgressView()
            }
            else{
                if vc?.checklistQuestions.count == self.vc.currentIndex{
                    //last index
                    //Set button title as 'Submit'
                    self.vc.nextButton.setTitle(submit, for: .normal)
                }
                self.setProgressView()
            }
            vc?.tableView.reloadData()
        }
    }
    
    /// Set progress view
    func setProgressView(){
        //let completedListsCount = getCompletedQuestionsCount//self.vc.currentIndex + 1
        let progress = Float(getCompletedQuestionsCount()) / Float(self.vc.checklistQuestions.count)
        self.vc.progressView.setProgress(Float(progress), animated: true)
        self.vc.lblPercentage.text = "\(Int(progress * 100))% completed"
    }
    
    func getCompletedQuestionsCount() -> Int
    {
        let filtered = self.vc.checklistQuestions.filter{
            $0.fieldAnswer != EMPTY
        }
        
        return filtered.count
    }
    
    /// Set FieldOptionsArray
    func setFieldOptions()
    {
        var list:[ChecklistQuestion] = []
        for obj in vc.checklistQuestions
        {
            var listObj = obj
            listObj.optionsList = convertToFiledOption(strArray: obj.fieldOptions ?? [])
            list.append(listObj)
        }
        self.vc.checklistQuestions = list
    }
    
    /// Set answer for selected options
    func setFieldAnswersForRadioAndCheckBox()
    {
        let filtered = self.vc.checklistQuestions[self.vc.currentIndex].optionsList.filter{
            $0.isSelected == true
        }
        
        if filtered.count > 0 {
            
            var answer = EMPTY
            
            for (index,obj) in filtered.enumerated() {
                if index == 0 {
                    answer =  obj.option
                }
                else {
                    answer +=  ",\(obj.option ?? EMPTY)"
                }
            }
            self.vc.checklistQuestions[self.vc.currentIndex].fieldAnswer = answer
        }
        else {
            self.vc.checklistQuestions[self.vc.currentIndex].fieldAnswer = EMPTY
        }
    }
    
    //MARK:- Upload Attachment
    func uploadAttachment()
    {
        if isUserOnline()
        {
            showCommonLoader()
            
            /// Set url
            let urlString = endpoint + ApiPath.imageUpload + "IMAGE"
            let url = URL(string: urlString)
            
            /// Get data and file name
            let imageData = vc?.attachmentArray.first?.data
            let fileName = vc?.attachmentArray.first?.fileName
            
            /// Set extension path and mime type
            _ = vc?.attachmentArray.first?.fileName.components(separatedBy: ".").last
            let mimeType = "IMAGE" //+ "/" + extensionPath!
            
            Services.shared.uploadImage(url: url!, imageData: imageData!, accesToken: getAccesToken(), postData: nil, method: "POST", fileName: fileName!, type: mimeType) { (apiResponse) in
                
                removeActivityIndicator()
                
                switch apiResponse
                {
                case .Success(let response):
                    if response["type"] as! String == success
                    {
                        let responseDict = response["data"] as! [String:String]
                        if let url = responseDict["attachment_path"]
                        {
                            self.vc.checklistQuestions[self.vc.currentIndex].selectedImage = self.vc.attachmentArray[0].image
                            self.vc.checklistQuestions[self.vc.currentIndex].fieldAnswer = self.vc.attachmentArray[0].fileName
                            
                            self.vc.checklistQuestions[self.vc.currentIndex].fieldAnswer = url
                            self.vc.tableView.reloadData()
                            self.setProgressView()
                        }
                    }
                case .ApiError(let apiError):
                    if let message = apiError[message]
                    {
                        removeActivityIndicator()
                        self.vc.attachmentArray = []
                        AlertView.showAlertView(title: errorTitle, message: message as! String,viewController: self.vc)
                    }
                    
                case .Error(let error):
                    print(error)
                    removeActivityIndicator()
                    self.vc.attachmentArray = []
                }
                
            }
        }
        else
        {
            AlertView.showNoInternetAlert()
        }
    }
    //MARK:- Validation
    func checklistValidation()
    {
        if checkIfAnswerRequired()
        {
            self.submitChecklist()
        }
    }
    
    /// Check if all mandatory questions were answered
    fileprivate func checkIfAnswerRequired() -> Bool
    {
        for obj in vc!.checklistQuestions
        {
            let valueText = obj.fieldAnswer
            if obj.isMandatory ?? false
            {
                if valueText.count == 0
                {
                    AlertView.showAlertView(title: "", message: "\(mandatoryQuestionsAlertMessage) \"\(obj.fieldName ?? EMPTY)\" ",viewController: self.vc)
                    return false
                }
            }
        }
        return true
    }
    
    //MARK:- Submit Checklist
    
    /// Get the Post Data
    func getPostData() -> [String:Any]
    {
        var checklistAnswers:[[String:Any]] = []
        
        for obj in self.vc.checklistQuestions
        {
            checklistAnswers.append(["label":obj.fieldName ?? EMPTY,"value":obj.fieldAnswer,"type":obj.fieldType ?? EMPTY])
        }
        
        let checklistDict = ["checklist_name": self.vc.checklist.checklistName ?? EMPTY,
        "checklist_description": self.vc.checklist.checklistName ?? EMPTY,
        "company_checklist": self.vc.checklist.companyChecklistUid ?? EMPTY,
        "checklist_submission":checklistAnswers] as [String : Any]
        
        let mainDict = ["user_checklist": checklistDict]
        
        return mainDict
 
    }
    
    /// Submit checklist
    func submitChecklist() {
        if isUserOnline() {
            
            showCommonLoader()
            
            let postData = getPostData()
            let urlString = endpoint + ApiPath.submitChecklist
            
            Services.shared.submitChecklist(url: urlString, postData: postData, completion: { (apiResponse) in
                
                removeActivityIndicator()
                switch apiResponse
                {
                case .Success(let responseObj):
                    if responseObj["type"] as? String == success
                    {
                        self.navigateToSuccessView()
                    }
                case .ApiError(let apiError):
                    if let message = apiError[message] as? String
                    {
                        AlertView.showAlertView(title:errorTitle , message: message,viewController: self.vc)
                    }
                    
                case .Error( _):
                    
                    self.vc.view.emptyState.show(MainState.somethingWrong)
                }
            })
        }
        else{
            //NO Internet state
            vc.view.emptyState.show(MainState.noInternet)
        }
    }
    
    func navigateToSuccessView(){
        let myBundle = Bundle(for: SuccessController.self)
        let storyBoard = UIStoryboard(name: StoryBoardName.Checklist, bundle: myBundle)
        let successVC = storyBoard.instantiateViewController(withIdentifier: ViewcontrollerIdentifier.SuccessController) as! SuccessController
        DispatchQueue.main.async {
            if let nav = self.vc.navigationController
            {
                nav.popViewController(animated: false)
                nav.pushViewController(successVC, animated: true)
            }
        }
    }
    
    /// Get checklist details by checklistId
    func getChecklistDetails()
    {
        if isUserOnline(){
            
            showCommonLoader()
            
            Services.shared.getChecklistDetail(checklistUid: checklistUid, completion: { (apiResponse) in
                removeActivityIndicator()
                switch apiResponse
                {
                case .Success(let checklistData):
                    if checklistData != nil
                    {
                        if let checklists = checklistData?.data
                        {
                            if checklists.count > 0 {
                                self.vc.checklist = checklists[0]
                                self.vc.checklistQuestions = self.vc.checklist.checklistQuestions ?? []
                                self.vc.title = self.vc.checklist.checklistName ?? EMPTY
                                self.setPreNextButtons()
                                self.setFieldOptions()
                                self.vc.tableView.reloadData()
                                
                            }
                            else{
                                self.vc.emptyStateMsg = ""
                                self.vc.emptyStateTitle = emptyStateMessage
                                self.vc.emptyStateImg = "Box"
                                self.vc.view.emptyState.show(MainState.errorMessage)
                            }
                        }
                    }
                case .ApiError(let apiError):
                    self.vc.emptyStateMsg = message
                    self.vc.emptyStateTitle = errorTitle
                    self.vc.emptyStateImg = "icon-issue"
                    self.vc.view.emptyState.show(MainState.errorMessage)
                    if let message = apiError[message] as? String
                    {
                        AlertView.showAlertView(title: errorTitle, message: message,viewController: self.vc)
                    }
                    
                case .Error( _):
                    self.vc.view.emptyState.show(MainState.somethingWrong)
                }
            })
        }
        else{
            vc.view.emptyState.show(MainState.noInternet)
        }
    }
}


extension ChecklistDetailController:EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        view.emptyState.hide()
        self.viewDidLoad()
    }
}

extension ChecklistDetailController: EmptyStateDataSource {
    
    func imageForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> UIImage? {
        switch state as! MainState {
        case .noInternet: return returnImage("icon_wifi")
        case .somethingWrong:
            return returnImage("icon-issue")
        case .errorMessage:
            return returnImage(emptyStateImg)
        case .emptyMessage:
            return returnImage(emptyStateImg)
            
        }
    }
    
    func titleForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState {
        case .noInternet:  return internetOfflineTitle
        case .somethingWrong:
            return "Oops, Something went wrong"
        case .errorMessage:
            return emptyStateTitle
        case .emptyMessage:
            return emptyStateTitle
        }
    }
    
    func descriptionForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState {
        case .noInternet: return internetOfflineMessage
        case .somethingWrong:
            return "Please try again later"
        case .errorMessage:
            return emptyStateMsg
        case .emptyMessage:
            return emptyStateMsg
        }
    }
    
    func titleButtonForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
        switch state as! MainState {
        case .noInternet: return "Try again?"
        case .somethingWrong:
            return "Try again?"
        case .errorMessage:
            return "Try again?"
        case .emptyMessage:
            return "Try again?"
        }
    }
}

extension ChecklistDetailController:  DocumentDelegate,AttachmentDelegate,ImageMarkUpDelegate
{
    /// Navigate To Camera or Gallery to select an image
    func chooseImage()
    {
        Library.shared.delegate = self
        Library.shared.viewController = self
        Library.shared.attachmentDelegate = self
        Library.shared.attachmentArray = []
        Library.shared.getVC = self
        Library.shared.showAttachmentActionSheet(viewController: self)
    }
    
    //MARK:- Attachment fetch delegate methods
    
    /// Passing the selected Attachment
    /// - Parameter attachementArray: Array passed from Library , array of AttachmentModel
    func passSelectedAttachment(attachementArray: [AttachmentModel]) {
        
        if attachementArray.count > 0
        {
            if let pickedImg = attachementArray.first?.image
            {
                
                navigateToImageMarkUpViewController(image: pickedImg,attachmentList: attachementArray,viewController: self)
                
            }
            else
            {
                if let image = UIImage(data: (attachementArray.first?.data)!)
                {
                    navigateToImageMarkUpViewController(image: image,attachmentList: attachementArray,viewController: self)
                }
                else
                {
                    self.attachmentArray = attachementArray
                    //self.uploadAttachment()
                }
            }
            
        }
    }
    
    //MARK:- Image Mark Up Delegate Methods
    /// Passing the selected image
    /// - Parameter attachementArray: Array passed from Library , array of AttachmentModel
    func passImage(attachmentArray: [AttachmentModel])
    {
        if attachmentArray.first?.data != nil
        {
            self.attachmentArray = attachmentArray
            self.checkListDetailObj.uploadAttachment()
        }
    }
}

//MARK:- UITableView Delegates
extension ChecklistDetailController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        if checklistQuestions.count > 0
        {
        return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if checklistQuestions.count > 0
        {
            /// If type is RADIO,CHECKBOX ,DROPDOWN count is the number of fieldOPtions
            if checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.radio || checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.checkBox || checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.dropDown
            {
                return checklistQuestions[self.currentIndex].optionsList.count
            }
            /// Others count - 1
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifier.QuestionTypeCell) as! QuestionTypeCell
        cell.setQuestionDetails(checklistQuestion: checklistQuestions[self.currentIndex])
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.text
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifier.SingleTextFieldCell) as! SingleTextFieldCell
            cell.textDetails(checklistQuestion: checklistQuestions[self.currentIndex])
            cell.textField.delegate = self
            return cell
        }
        else if checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.number
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifier.SingleTextFieldCell) as! SingleTextFieldCell
            cell.numberDetails(checklistQuestion: checklistQuestions[self.currentIndex])
            cell.textField.delegate = self
            return cell
        }
        else if checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.image
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifier.ImageTypeCell) as! ImageTypeCell
            cell.setImageTypeView(checklistQuestion: checklistQuestions[self.currentIndex])
            cell.addImageBtn.tag = self.currentIndex
            cell.deleteBtn.tag = self.currentIndex
            cell.addImageBtn.addTarget(self, action: #selector(self.addImage(sender:)), for: .touchUpInside)
            cell.deleteBtn.addTarget(self, action: #selector(self.deleteImage(sender:)), for: .touchUpInside)
            return cell
        }
        else if checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.radio || checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.dropDown
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifier.RadioTypeCell) as! RadioTypeCell
            cell.setRadioDetails(option: self.checklistQuestions[self.currentIndex].optionsList[indexPath.row])
            return cell
        }
        else if checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.checkBox
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: TableViewIdentifier.CheckBoxTypeCell) as! CheckBoxTypeCell
            cell.setCheckBoxDetails(option: self.checklistQuestions[self.currentIndex].optionsList[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  self.checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.checkBox
        {
            self.checklistQuestions[self.currentIndex].optionsList[indexPath.row].isSelected.toggle()
            self.checkListDetailObj.setFieldAnswersForRadioAndCheckBox()
            self.tableView.reloadData()
           self.checkListDetailObj.setProgressView()
        }
        else if self.checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.radio || self.checklistQuestions[self.currentIndex].fieldType == ChecklistQuestionType.dropDown
        {
            for (index,_) in self.checklistQuestions[self.currentIndex].optionsList.enumerated()
            {
                self.checklistQuestions[self.currentIndex].optionsList[index].isSelected = false
            }
            self.checklistQuestions[self.currentIndex].optionsList[indexPath.row].isSelected = true
            self.checkListDetailObj.setFieldAnswersForRadioAndCheckBox()
            self.tableView.reloadData()
            self.checkListDetailObj.setProgressView()
        }
        
    }
    
    /// Add new image for a checklist question
    /// - Parameter sender: UIButton
    @objc func addImage(sender: UIButton)
    {
        chooseImage()
    }
    
    /// Delete the image for a checklist question
    /// - Parameter sender: UIButton
    @objc func deleteImage(sender: UIButton)
    {
        self.checklistQuestions[sender.tag].fieldAnswer = EMPTY
        self.checklistQuestions[sender.tag].selectedImage = nil
        self.attachmentArray = []
        self.tableView.reloadData()
    }
}

//MARK:- TextField Delegates
extension ChecklistDetailController : UITextFieldDelegate
{
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text != nil
        {
            if textField.text != EMPTY
            {
                self.checklistQuestions[self.currentIndex].fieldAnswer = textField.text ?? EMPTY
            }
            else
            {
                self.checklistQuestions[self.currentIndex].fieldAnswer = EMPTY
            }
            self.checkListDetailObj.setProgressView()
        }
    }
}
