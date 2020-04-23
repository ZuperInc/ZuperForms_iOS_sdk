//
//  LoginViewModel.swift
//  COVID-19
//
//  Created by Apple on 17/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import EmptyStateKit

class LoginViewModel
{
    var loginVC: LoginController!
    private var reachability:Reachability!
    
    init(vc: LoginController) {
        loginVC = vc
    }
    
    /// Set EmptyState View
    func setEmptyStateView(){
        setEmptyState(view: loginVC!.view)
        loginVC?.view.emptyState.delegate = loginVC
        loginVC?.view.emptyState.dataSource = loginVC
        
    }
    
    /// Set Default details like title for label and placeholder for textfields
    func setDefaults()
    {
        self.setEmptyStateView()
        loginVC.lblEmail.text = email
        loginVC.lblOTP.text = otp
        loginVC.txtEmail.placeholder = enterEmail
        loginVC.txtEmail.setBottomBorder()
        loginVC.txtOTP.placeholder = enterOTP
        loginVC.txtOTP.setBottomBorder()
        loginVC.view.backgroundColor = ZuperFormsTheme.backgroundColor
        self.showOrHideOTPView(show: false)
    }
    
    /// To show and hide otp view based on email address entry
    func showOrHideOTPView(show: Bool)
    {
        if show
        {
            if loginVC.otpView.isHidden == true
            {
                self.loginVC.otpView.isHidden = false
                self.loginVC.otpViewHeight.constant = 69.5
                self.loginVC.loginViewHeight.constant = self.loginVC.loginViewHeight.constant + 69.5
                self.loginVC.loginBtn.setTitle(login, for: .normal)
                self.loginVC.loginBtn.tag = 1
            }
        }
        else
        {
            if loginVC.otpView.isHidden == false
            {
                self.loginVC.otpView.isHidden = true
                self.loginVC.otpViewHeight.constant = 0
                self.loginVC.loginViewHeight.constant = self.loginVC.loginViewHeight.constant - 69.5
                self.loginVC.loginBtn.setTitle(sendOTP, for: .normal)
                self.loginVC.loginBtn.tag = 0
            }
        }
    }
    
    func loginAction()
    {
        self.loginVC.view.endEditing(true)
        if self.loginVC.loginBtn.tag == 0
        {
            generateOTPValidation()
        }
        else
        {
            loginValidation()
        }
    }
    
    func generateOTPValidation()
    {
        if self.loginVC.txtEmail.text == EMPTY
        {
            AlertView.showAlertView(title: "", message: emailEmpty,viewController: loginVC)
        }
        else
        {
            generateOTP()
        }
    }
    
    func loginValidation()
    {
        if self.loginVC.txtEmail.text == EMPTY
        {
            AlertView.showAlertView(title: "", message: emailEmpty,viewController: loginVC)
        }
        else if self.loginVC.txtOTP.text == EMPTY
        {
            AlertView.showAlertView(title: "", message: otpEmpty,viewController: loginVC)
        }
        else
        {
            loginUser()
        }
    }
    
    func generateOTP() {
        if isUserOnline(){
            
            showCommonLoader()
            let postData = ["email": self.loginVC.txtEmail.text ?? EMPTY]
            
            Services.shared.generateOTP(postData: postData, completion: { (apiResponse) in
                
                removeActivityIndicator()
                switch apiResponse
                {
                case .Success(let responseObj):
                    if responseObj["type"] as? String == success
                    {
                        self.showOrHideOTPView(show: true)
                        self.loginVC.txtOTP.becomeFirstResponder()
                    }
                case .ApiError(let apiError):
                    self.loginVC.emptyStateMsg = message
                    self.loginVC.emptyStateTitle = errorTitle
                    self.loginVC.emptyStateImg = "icon-issue"
                    self.loginVC.view.emptyState.show(MainState.errorMessage)
                    if let message = apiError[message] as? String
                    {
                        AlertView.showAlertView(title:errorTitle , message: message,viewController: self.loginVC)
                    }
                    
                case .Error( _):
                    
                    self.loginVC.view.emptyState.show(MainState.somethingWrong)
                }
            })
        }
        else{
            //NO Internet state
            loginVC.view.emptyState.show(MainState.noInternet)
        }
    }
    
    func loginUser() {
        if isUserOnline() {
            
            showCommonLoader()
            let otp = self.loginVC.txtOTP.text ?? "0"
            let postData = ["email": self.loginVC.txtEmail.text ?? EMPTY,"otp": Int(otp) ?? 0] as [String : Any]
            
            Services.shared.verifyOTP(postData: postData, completion: { (apiResponse) in
                
                removeActivityIndicator()
                switch apiResponse
                {
                case .Success(let loginDetails):
                    if loginDetails != nil
                    {
                        saveUserDetails(loginDetails: loginDetails!)
                        saveUserToken(loginDetails: loginDetails!)
                        FormDetails.shared.userDetails = loginDetails!
                        self.setNavigation()
                    }
                    else{
                        self.loginVC.view.emptyState.show(MainState.somethingWrong)
                    }
                case .ApiError(let apiError):
                    if let message = apiError[message] as? String
                    {
                        AlertView.showAlertView(title: errorTitle, message: message,viewController: self.loginVC)
                    }else{
                        self.loginVC.view.emptyState.show(MainState.somethingWrong)
                    }
                    
                case .Error( _):
                    self.loginVC.view.emptyState.show(MainState.somethingWrong)
                }
            })
        }
        else{
            // No Internet State
            loginVC.view.emptyState.show(MainState.noInternet)
        }
    }
    
    func setNavigation()
    {
        if checklistUid != nil && checklistUid != EMPTY
        {
            navigateToChecklistDetail()
        }
        else
        {
            navigateToSection()
        }
    }
    func navigateToSection()
    {
        let myBundle = Bundle(for: SectionListController.self)
        let storyBoard = UIStoryboard(name: StoryBoardName.Checklist, bundle: myBundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewcontrollerIdentifier.SectionListController) as! SectionListController
        DispatchQueue.main.async {
            self.loginVC.dismiss(animated: false) {
                let nav = UINavigationController(rootViewController: vc)
                UINavigationBar.appearance().barTintColor = ZuperFormsTheme.primaryColor
                UINavigationBar.appearance().tintColor = ZuperFormsTheme.navBarTintColor
                UINavigationBar.appearance().isTranslucent = false
                nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ZuperFormsTheme.navBarTintColor]
                // Remove the background color.
                nav.navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
                
                // Set the shadow color.
                nav.navigationController?.navigationBar.shadowImage = UIColor.gray.as1ptImage()
                self.loginVC.delegate.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func navigateToChecklistDetail()
    {
        let myBundle = Bundle(for: ChecklistDetailController.self)
               let storyBoard = UIStoryboard(name: StoryBoardName.Checklist, bundle: myBundle)
               let vc = storyBoard.instantiateViewController(withIdentifier: ViewcontrollerIdentifier.ChecklistDetailController) as! ChecklistDetailController
               DispatchQueue.main.async {
                   self.loginVC.dismiss(animated: false) {
                       let nav = UINavigationController(rootViewController: vc)
                       UINavigationBar.appearance().barTintColor = ZuperFormsTheme.primaryColor
                       UINavigationBar.appearance().tintColor = ZuperFormsTheme.navBarTintColor
                       UINavigationBar.appearance().isTranslucent = false
                       nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ZuperFormsTheme.navBarTintColor]
                       // Remove the background color.
                       nav.navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
                       
                       // Set the shadow color.
                       nav.navigationController?.navigationBar.shadowImage = UIColor.gray.as1ptImage()
                       self.loginVC.delegate.present(nav, animated: true, completion: nil)
                   }
               }
    }
}

//MARK:- TextField Delegates
extension LoginController : UITextFieldDelegate
{
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.txtEmail {
            self.txtOTP.becomeFirstResponder()
        }
        if textField == self.txtOTP {
            self.txtOTP.resignFirstResponder()
        }
        return true
    }
    
    public func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.txtEmail {
            if textField.text != ""
            {
                if textField.text?.isValidEmail() ?? false
                {
                    self.loginViewModel?.showOrHideOTPView(show: true)
                }
            }
        }
        if textField == self.txtOTP {
        }
    }
}



extension LoginController:EmptyStateDelegate {
    
    public func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        view.emptyState.hide()
        self.viewDidLoad()
    }
}

extension LoginController: EmptyStateDataSource {
    
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



public func returnImage(_ named:String) -> UIImage {
    let myBundle = Bundle.init(identifier: "com.zuper.ZuperForms")
    if #available(iOS 13.0, *) {
        let imagePath = UIImage(named: named, in: myBundle, compatibleWith: .current)
         return imagePath!
    } else {
        // Fallback on earlier versions
        let imagePath = UIImage(named: named, in: myBundle, compatibleWith: .init())
         return imagePath!
    }
}
