//
//  ViewController.swift
//  ZuperFormsExample
//
//  Created by Zuper on 18/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//
import UIKit
import ZuperForms
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func submitAction(_ sender: UIButton) {
        
        /// To move directly to particular checklist
        if sender.tag == 1 {
            let zuperFroms = ZuperForms(companyId: "", companyName: "ZuperSoft Solutions",checklistId: "ae9e39e0-83f6-11ea-bdff-3b74ec04e036")
            zuperFroms.delegate = self
            ZuperForms.setEnvironment(environment:.staging)
            // let nav = UINavigationController(rootViewController: login)
            self.present(zuperFroms, animated: true, completion: nil)
        }
        else {
            /// To move into a list of checklists
            let zuperFroms = ZuperForms(companyId: "", companyName: "ZuperSoft Solutions")
            zuperFroms.delegate = self
            // let nav = UINavigationController(rootViewController: login)
            self.present(zuperFroms, animated: true, completion: nil)
            
        }
        
    }

}

