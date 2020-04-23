//
//  ZuperForm.swift
//  ZuperFormsSdk
//
//  Created by Zuper on 18/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//


import UIKit

public class ZuperForms: UIViewController {
    
    
    var zuperFromObj: ZuperFormsViewModel!
    var emptyStateTitle: String!
    var emptyStateMsg: String!
    var emptyStateImg: String!
    public var delegate:UIViewController!
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        zuperFromObj = ZuperFormsViewModel(vc: self)
        zuperFromObj.setdefaults()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        zuperFromObj = nil
    }
    
    /// ZuperFrom intialize with company id
    /// - Parameters:
    ///   - companyId: CompanyID
    ///   - companyImage: ComanyImage(Image Url) - Optional
    ///   - email: EmailId - Optional
    public init(companyId:String?,companyImageUrl:String? = nil,companyName:String? = nil,email:String? = nil,checklistId: String? = nil) {
        companyUid = companyId
        companyUrl = companyImageUrl
        userEmail = email
        cmpName = companyName
        checklistUid = checklistId
        super.init(nibName:xibNames.ZuperForm, bundle: Bundle(for: ZuperForms.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

