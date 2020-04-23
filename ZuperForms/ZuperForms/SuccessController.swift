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
        
        
        imgView.setGIFImage(name: "tick", repeatCount: 1)
        imgView.image = returnImage("Success")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
//            self.imgView.stopAnimating()
//            self.imgView.set
//        }
        // Do any additional setup after loading the view.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
