//
//  LoginController.swift
//  ViewFrameWork
//
//  Created by Zuper on 17/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit
import EmptyStateKit

class LoginController: UIViewController {
    
    //MARK:- @IBOutlet
    @IBOutlet weak var lblEmail: UILabel! {
        didSet{
            lblEmail.textColor = getLabelTextColor()
        }
    }
    @IBOutlet weak var lblOTP: UILabel! {
        didSet{
            lblOTP.textColor = getLabelTextColor()
        }
    }
    @IBOutlet weak var txtEmail: UITextField!{
        didSet{
            txtEmail.textColor = getTextFieldTextColor()
        }
    }
    @IBOutlet weak var txtOTP: UITextField!{
        didSet{
            txtOTP.textColor = getTextFieldTextColor()
        }
    }
    @IBOutlet weak var otpView: UIView!
    @IBOutlet weak var otpViewHeight: NSLayoutConstraint!
    @IBOutlet weak var loginView: CornerRadiusView!{
        didSet{
            loginView.backgroundColor = getCardViewBackgroundColor()
        }
    }
    @IBOutlet weak var loginViewHeight: NSLayoutConstraint!
    @IBOutlet weak var loginBtn: CornerRadiusButton!{
        didSet{
            loginBtn.addTarget(self, action: #selector(loginAction(_:)), for: .touchUpInside)
            loginBtn.backgroundColor = getButtonColor()
            loginBtn.setTitleColor(getLoginButtonTextColor(), for: .normal)
        }
    }
    @IBOutlet weak var lblTop: UILabel!{
        didSet{
            lblTop.text = cmpName
        }
    }
    @IBOutlet weak var mainView: UIView!{
        didSet{
            mainView.backgroundColor = getViewBackgroundColor()
        }
    }
    @IBOutlet weak var headerImage: UIImageView!
    
    @IBOutlet weak var headerView: UIView!{
        didSet{
            headerView.backgroundColor = ZuperFormsTheme.primaryColor
        }
    }
    
    //MARK:- Variable Declaration
    var loginViewModel: LoginViewModel!
    public var delegate:UIViewController!
    var emptyStateTitle: String!
    var emptyStateMsg: String!
    var emptyStateImg: String!
    
    public init() {
        super.init(nibName: xibNames.loginController, bundle: Bundle(for: LoginController.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginViewModel = LoginViewModel(vc: self)
        self.loginViewModel?.setDefaults()
    }
    
    deinit {
        self.loginViewModel = nil
    }
    
    @objc func loginAction(_ sender:UIButton){
        self.loginViewModel.loginAction()
    }
    
    //    @IBAction func loginAction(_ sender: Any) {
    //        let storyBoard = UIStoryboard(name: StoryBoardName.Checklist, bundle: nil)
    //        let vc = storyBoard.instantiateViewController(withIdentifier: ViewcontrollerIdentifier.SectionListController) as! SectionListController
    //        self.navigationController?.pushViewController(vc, animated: true)
    //    }
}

