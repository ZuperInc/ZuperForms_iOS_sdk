//
//  SectionListViewModel.swift
//  COVID-19
//
//  Created by Apple on 17/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import Foundation
import UIKit
import EmptyStateKit

class SectionListViewModel
{
    var sectionVC: SectionListController!
    
    init(vc: SectionListController) {
        sectionVC = vc
    }
    
    /// Set EmptyState View
    func setEmptyStateView(){
        setEmptyState(view: sectionVC!.view)
        sectionVC?.view.emptyState.delegate = sectionVC
        sectionVC?.view.emptyState.dataSource = sectionVC
        
    }
    
    /// Set Defaults
    func setDefaults()
    {
        setEmptyStateView()
        sectionVC?.view.backgroundColor = ZuperFormsTheme.backgroundColor
        sectionVC?.tableView.register(UINib(nibName: xibNames.SectionCell, bundle: Bundle(for: SectionCell.self)), forCellReuseIdentifier: TableViewIdentifier.SectionCell)
        sectionVC?.tableView.estimatedRowHeight = 120
        setThemeForNavigationBar()
        self.getChecklists()
    }
    
    func setThemeForNavigationBar()
    {
        
        // sectionVC?.navigationController?.navigationBar.barTintColor  = ZuperFormsTheme.backgroundColor
        // sectionVC?.navigationController?.navigationBar.tintColor = ZuperFormsTheme.backgroundColor
    }
    
    func getChecklists()
    {
        if isUserOnline(){
            
            showCommonLoader()
            
            Services.shared.getChecklists(completion: { (apiResponse) in
                
                removeActivityIndicator()
                switch apiResponse
                {
                case .Success(let checklistData):
                    if checklistData != nil
                    {
                        if let checklists = checklistData?.data
                        {
                            if checklists.count > 0{
                                self.sectionVC.sectionsList = checklists
                                self.sectionVC.tableView.reloadData()
                                
                            }
                            else{
                                self.sectionVC.emptyStateMsg = ""
                                self.sectionVC.emptyStateTitle = emptyStateMessage
                                self.sectionVC.emptyStateImg = "Box"
                                self.sectionVC.view.emptyState.show(MainState.errorMessage)
                            }
                        }
                    }
                case .ApiError(let apiError):
                    self.sectionVC.emptyStateMsg = message
                    self.sectionVC.emptyStateTitle = errorTitle
                    self.sectionVC.emptyStateImg = "icon-issue"
                    self.sectionVC.view.emptyState.show(MainState.errorMessage)
                    if let message = apiError[message] as? String
                    {
                        AlertView.showAlertView(title: errorTitle, message: message,viewController: self.sectionVC)
                    }
                    
                case .Error( _):
                    self.sectionVC.view.emptyState.show(MainState.somethingWrong)
                }
            })
        }
        else{
            sectionVC.view.emptyState.show(MainState.noInternet)
        }
    }
}


extension SectionListController:EmptyStateDelegate {
    
    func emptyState(emptyState: EmptyState, didPressButton button: UIButton) {
        view.emptyState.hide()
        self.viewDidLoad()
    }
}

extension SectionListController: EmptyStateDataSource {
    
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
