//
//  ImageMarkUpViewController.swift
//  ZuperFormsSdk
//
//  Created by Apple on 21/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit
/// Image MarkUp Delegate
protocol ImageMarkUpDelegate {
    func passImage(attachmentArray: [AttachmentModel])
}

class ImageMarkUpViewController: UIViewController
{
    //MARK:- @IBOutlet
    @IBOutlet weak var canvasView: UIView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet weak var canvasImageView: UIImageView!
    
    //MARK:- Variable Declaration
    public var image: UIImage?
    var drawColor: UIColor = UIColor.red
    var textColor: UIColor = UIColor.white
    var isDrawing: Bool = false
    var lastPoint: CGPoint!
    var swiped = false
    var imageMarkUpDelegate: ImageMarkUpDelegate?
    var attachmentArray:[AttachmentModel] = []
    
    //MARK:- View Controller LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.setImageView(image: image!)
    }
    
    /// set the image in the imageview
    /// - Parameter image: UIImage
    func setImageView(image: UIImage) {
        imageView.image = image
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>,with event: UIEvent?){
        swiped = false
        if let touch = touches.first {
            lastPoint = touch.location(in: self.canvasImageView)
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>,with event: UIEvent?)
    {
        // 6
        swiped = true
        if let touch = touches.first
        {
            let currentPoint = touch.location(in: canvasImageView)
            drawLineFrom(lastPoint, toPoint: currentPoint)
            
            // 7
            lastPoint = currentPoint
        }
        
    }
    
    override public func touchesEnded(_ touches: Set<UITouch>,with event: UIEvent?){
        
        if !swiped {
            // draw a single point
            drawLineFrom(lastPoint, toPoint: lastPoint)
        }
        
        
    }
    
    func drawLineFrom(_ fromPoint: CGPoint, toPoint: CGPoint) {
        // 1
        let canvasSize = canvasImageView.frame.integral.size
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, 0)
        if let context = UIGraphicsGetCurrentContext() {
            canvasImageView.image?.draw(in: CGRect(x: 0, y: 0, width: canvasSize.width, height: canvasSize.height))
            // 2
            context.move(to: CGPoint(x: fromPoint.x, y: fromPoint.y))
            context.addLine(to: CGPoint(x: toPoint.x, y: toPoint.y))
            // 3
            context.setLineCap( CGLineCap.round)
            context.setLineWidth(2.0)
            context.setStrokeColor(drawColor.cgColor)
            context.setBlendMode( CGBlendMode.normal)
            // 4
            context.strokePath()
            // 5
            canvasImageView.image = UIGraphicsGetImageFromCurrentImageContext()
        }
        UIGraphicsEndImageContext()
    }
    
    /// Clear the edited image
    /// - Parameter sender: UIBarButtonItem
    @IBAction func clearButtonTapped(_ sender: AnyObject) {
        //clear drawing
        canvasImageView.image = nil
        
    }
    
    /// Save the edited imafe
    /// - Parameter sender: UIBarButtonItem
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem)
    {
        let image = self.canvasView.toImage()
        let data = image.jpegData(compressionQuality: 0.5)
        let editedImage = UIImage(data: data!)
        let fileName = self.attachmentArray.first?.fileName
        let attachObj = AttachmentModel(fileName: fileName ?? EMPTY, image: editedImage, data: data)
        self.attachmentArray = []
        self.attachmentArray.append(attachObj)
        self.navigationController?.popViewController(animated: false)
        self.imageMarkUpDelegate?.passImage(attachmentArray: self.attachmentArray)
        
    }
    
}

extension UIView {
    /**
     Convert UIView to UIImage
     */
    func toImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.isOpaque, 0.0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: false)
        let snapshotImageFromMyView = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshotImageFromMyView!
    }
}
