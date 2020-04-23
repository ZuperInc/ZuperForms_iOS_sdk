//
//  SectionListController.swift
//  COVID-19
//
//  Created by Apple on 17/04/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import UIKit

class SectionListController: UIViewController{
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            tableView.backgroundColor = .clear
            tableView.estimatedRowHeight = 100
            tableView.tableFooterView = UIView()
        }
    }
    
    @IBOutlet weak var lblTop: UILabel!{
        didSet{
            lblTop.text = cmpName
        }
    }
    @IBOutlet weak var headerImage: UIView!
    
    @IBOutlet weak var headerView: UIView!{
        didSet{
            headerView.backgroundColor = ZuperFormsTheme.primaryColor
        }
    }
    
    //MARK:- Variable Declaration
    var sectionListViewModel: SectionListViewModel!
    var sectionsList:[Checklist] = []
    var emptyStateTitle: String!
    var emptyStateMsg: String!
    var emptyStateImg: String!
    
    //MARK:- ViewController LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        sectionListViewModel = SectionListViewModel(vc: self)
        sectionListViewModel.setDefaults()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Hide the Navigation Bar
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        // Show the Navigation Bar
        self.navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    
    /// Deinitilize setionListObj
    deinit {
        sectionListViewModel = nil
    }
    
}

extension SectionListController: UITableViewDelegate,UITableViewDataSource{
    
    //MARK:- TableView Delegates
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.sectionsList.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: xibNames.SectionCell, for: indexPath) as! SectionCell
        cell.lblTitle.text = self.sectionsList[indexPath.row].checklistName ?? EMPTY
        cell.lblDescription.text = self.sectionsList[indexPath.row].checklistDescription ?? EMPTY
        cell.imageView?.tintColor = getLabelTextColor()
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let myBundle = Bundle(for: ChecklistDetailController.self)
        let storyBoard = UIStoryboard(name: StoryBoardName.Checklist, bundle: myBundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: ViewcontrollerIdentifier.ChecklistDetailController) as! ChecklistDetailController
        vc.checklist = self.sectionsList[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        UIView.animate(
            withDuration: 0.5,
            delay: 0.05 * Double(indexPath.row),
            animations: {
                cell.alpha = 1
        })
    }
}
