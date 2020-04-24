//
//  ZuperFormsViewModel.swift
//  ZuperFormsSdk
//
//  Created by Zuper on 18/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation
import IQKeyboardManagerSwift
import EmptyStateKit

class ZuperFormsViewModel {
    
    var vc: ZuperForms!
    private var reachability:Reachability!
    
    init(vc:ZuperForms) {
        self.vc = vc
    }
    
    func setdefaults(){
        iQkeboardSetUp()
        addInternetCheckObserver()
        setEmptyStateView()
        setUpViews()
    }
    
    func setUpViews()
    {
        if getAccesToken() != nil{
        //Get CompanyConfig Details
            
        ///If checklistId is not empty, then open the checklist directly
            if checklistUid != EMPTY && checklistUid != nil
            {
                navigateToChecklistDetail()
            }
            else
            {
                navigateToSection()
            }
        }else{
            //Redirect to Login View
            navigateToLoginView()
        }
    }
    
    /// Set EmptyState View
    func setEmptyStateView(){
        setEmptyState(view: vc!.view)
        vc?.view.emptyState.delegate = vc
        vc?.view.emptyState.dataSource = vc
        
    }
    
    /// Setup IQkeyboard
    func iQkeboardSetUp(){
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.disabledToolbarClasses = []
        IQKeyboardManager.shared.toolbarTintColor = ZuperFormsTheme.primaryColor
        IQKeyboardManager.shared.toolbarBarTintColor = .white
    }
    
    //MARK :- Internet Connection Methods
       func addInternetCheckObserver()
       {
           reachability = Reachability.reachabilityForInternetConnection()!
           
           if reachability != nil
           {
               networkStatus = reachability.isReachable()
           }
           
           NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: ReachabilityChangedNotification), object: nil)
           
           NotificationCenter.default.addObserver(self, selector:#selector(self.checkForReachability), name: NSNotification.Name(rawValue: ReachabilityChangedNotification), object: nil);
           
           _ = reachability.startNotifier()
       }
       
       @objc func checkForReachability(notification:NSNotification)
       {
           if let networkReachability = notification.object as? Reachability
           {
               
               networkStatus = networkReachability.isReachable()
               
           }
       }
    
    
    /// Get company congig data
//    func getCompanyConfig(){
//        
//        if isUserOnline(){
//            showCommonLoader()
//            Services.shared.getCompanyConfig(companyUid: companyUid) {(response) in
//                removeActivityIndicator()
//                switch response
//                {
//                case .Success(let responseData):
//                    if responseData != nil
//                    {
//                        print(responseData ?? nil)
//                    }
//                    
//                case .ApiError( let apiError):
//                    if let message = apiError[message] as? String
//                    {
//                        AlertView.showAlertView(title: errorTitle, message: message,viewController: self.vc)
//                    }else{
//                        self.vc.view.emptyState.show(MainState.somethingWrong)
//                    }
//                    
//                case .Error( _):
//                    self.vc.view.emptyState.show(MainState.somethingWrong)
//                }
//            }
//        }
//        else{
//            
//        }
//    }
    
    
    /// Navigate to Login viewController
    func navigateToLoginView()
    {
        //LoginController
        DispatchQueue.main.async {
        self.vc.dismiss(animated: false) {
            let loginVc = LoginController()
            loginVc.delegate = self.vc.delegate
            self.vc.delegate.present(loginVc, animated: true, completion: nil)
        }
        }
    }
    
    func navigateToSection()
    {
        let myBundle = Bundle(for: SectionListController.self)
        let storyBoard = UIStoryboard(name: StoryBoardName.Checklist, bundle: myBundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewcontrollerIdentifier.SectionListController) as! SectionListController
        DispatchQueue.main.async {
            self.vc.dismiss(animated: false) {
                let nav = UINavigationController(rootViewController: vc)
                UINavigationBar.appearance().barTintColor = ZuperFormsTheme.primaryColor
                UINavigationBar.appearance().tintColor = ZuperFormsTheme.navBarTintColor
                UINavigationBar.appearance().isTranslucent = false
                nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ZuperFormsTheme.navBarTintColor]
                // Remove the background color.
                nav.navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
                
                // Set the shadow color.
                nav.navigationController?.navigationBar.shadowImage = UIColor.gray.as1ptImage()
                self.vc.delegate.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    func navigateToChecklistDetail()
    {
        let myBundle = Bundle(for: ChecklistDetailController.self)
        let storyBoard = UIStoryboard(name: StoryBoardName.Checklist, bundle: myBundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewcontrollerIdentifier.ChecklistDetailController) as! ChecklistDetailController
        DispatchQueue.main.async {
            self.vc.dismiss(animated: false) {
                let nav = UINavigationController(rootViewController: vc)
                UINavigationBar.appearance().barTintColor = ZuperFormsTheme.primaryColor
                UINavigationBar.appearance().tintColor = ZuperFormsTheme.navBarTintColor
                UINavigationBar.appearance().isTranslucent = false
                nav.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ZuperFormsTheme.navBarTintColor]
                // Remove the background color.
                nav.navigationController?.navigationBar.setBackgroundImage(UIColor.clear.as1ptImage(), for: .default)
                
                // Set the shadow color.
                nav.navigationController?.navigationBar.shadowImage = UIColor.gray.as1ptImage()
                self.vc.delegate.present(nav, animated: true, completion: nil)
            }
        }
    }
}



extension ZuperForms:EmptyStateDelegate {
    
    public func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        view.emptyState.hide()
        self.viewDidLoad()
    }
}

extension ZuperForms: EmptyStateDataSource {
    
    public func imageForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> UIImage? {
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
    
    public func titleForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
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
    
    public func descriptionForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
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
    
    public func titleButtonForState(_ state: CustomState, inEmptyState emptyState: EmptyState) -> String? {
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
