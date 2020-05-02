//
//  SuccessController.swift
//  ZuperFormsSdk
//
//  Created by Zuper on 23/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit

class SuccessController: UIViewController {
    
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lblValue: UILabel!{
        didSet{
            lblValue.textColor = ZuperFormsTheme.labelTextColor
            lblValue.text = "All done!! Thanks for cooperating to ensure your safety"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkView()
        imgView.setGIFImage(name: "tick", repeatCount: 1)
        imgView.image = ImageHelper.image("Success")
        
            //returnImage("Success")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
//            self.imgView.stopAnimating()
//            self.imgView.set
//        }
        // Do any additional setup after loading the view.
    }
    
    func checkView(){
        if isFromCheckListUid{
            //Hide back button
            //Show done button
            self.navigationItem.setHidesBackButton(true, animated: false)
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))

        }else{
            //Show back button
            //Hide done Button
            self.navigationItem.setHidesBackButton(false, animated: false);
            navigationItem.rightBarButtonItems = []
        }
    }
    
    @objc func doneAction(){
        viewDelegate.dismiss(animated: true, completion: nil)
    }
   
    
}
