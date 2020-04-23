//
//  ImageCropperViewModel.swift
//  ZuperFormsSdk
//
//  Created by Apple on 21/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation
import UIKit

/// Image Cropper Delegate
@objc public protocol UIImageCropperProtocol: class {
    /// Called when user presses crop button (or when there is unknown situation (one or both images will be nil)).
    /// - parameter originalImage
    ///   Orginal image from camera/gallery
    /// - parameter croppedImage
    ///   Cropped image in cropRatio aspect ratio
    func didCropImage(originalImage: UIImage?, croppedImage: UIImage?)
    /// (optional) Called when user cancels the picker. If method is not available picker is dismissed.
    @objc optional func didCancel()
}

struct ImageCropperViewModel
{
    var vc: UIImageCropper?
    
    init(viewController: UIViewController) {
        vc = viewController as? UIImageCropper
    }
    
    /// Set the main views
    func setMainViews()
    {
        //main views
        vc!.view.backgroundColor = UIColor.black
        vc!.topView.backgroundColor = UIColor.clear
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        vc!.view.addSubview(vc!.topView)
        vc!.view.addSubview(bottomView)
        vc!.topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalTopConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": vc!.topView])
        let horizontalBottomConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": bottomView])
        let verticalConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top]-(0)-[bottom(70)]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["bottom": bottomView, "top": vc!.topView])
        vc!.view.addConstraints(horizontalTopConst + horizontalBottomConst + verticalConst)
        self.setImage()
        self.setFadeOveralay()
        self.cropOverlay(bottomView: bottomView)
    }
    
    /// Set the image into canvas view
    func setImage()
    {
        vc!.imageView.contentMode = .scaleAspectFit
        vc!.imageView.translatesAutoresizingMaskIntoConstraints = false
        vc!.topView.addSubview(vc!.imageView)
        vc!.topConst = NSLayoutConstraint(item: vc!.imageView, attribute: .top, relatedBy: .equal, toItem: vc!.topView, attribute: .top, multiplier: 1, constant: 0)
        vc!.topConst?.priority = .defaultHigh
        vc!.leadConst = NSLayoutConstraint(item: vc!.imageView, attribute: .leading, relatedBy: .equal, toItem: vc!.topView, attribute: .leading, multiplier: 1, constant: 0)
        vc!.leadConst?.priority = .defaultHigh
        vc!.imageWidthConst = NSLayoutConstraint(item: vc!.imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 1)
        vc!.imageWidthConst?.priority = .required
        vc!.imageHeightConst = NSLayoutConstraint(item: vc!.imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 1)
        vc!.imageHeightConst?.priority = .required
        vc!.imageView.addConstraints([vc!.imageHeightConst!, vc!.imageWidthConst!])
        vc!.topView.addConstraints([vc!.topConst!, vc!.leadConst!])
        vc!.imageView.image = vc!.image
    }
    
    /// Fade overlay
    func setFadeOveralay()
    {
        vc!.fadeView.translatesAutoresizingMaskIntoConstraints = false
        vc!.fadeView.isUserInteractionEnabled = false
        vc!.fadeView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        vc!.topView.addSubview(vc!.fadeView)
        let horizontalFadeConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": vc!.fadeView])
        let verticalFadeConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": vc!.fadeView])
        vc!.topView.addConstraints(horizontalFadeConst + verticalFadeConst)
    }
    
    
    /// Crop the overlay
    /// - Parameter bottomView: UIView
    func cropOverlay(bottomView: UIView)
    {
        var cropCenterXMultiplier: CGFloat = 1.0
        
        vc!.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        vc!.cancelButton.setTitle(vc!.cancelButtonText, for: .normal)
        bottomView.addSubview(vc!.cancelButton)
        let centerCancelXConst = NSLayoutConstraint(item: vc!.cancelButton, attribute: .centerX, relatedBy: .equal, toItem: bottomView, attribute: .centerX, multiplier: 0.5, constant: 0)
        let centerCancelYConst = NSLayoutConstraint(item: vc!.cancelButton, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1, constant: 0)
        bottomView.addConstraints([centerCancelXConst, centerCancelYConst])
        cropCenterXMultiplier = 1.5
        
        vc!.cropView.translatesAutoresizingMaskIntoConstraints = false
        vc!.cropView.isUserInteractionEnabled = false
        vc!.topView.addSubview(vc!.cropView)
        let centerXConst = NSLayoutConstraint(item: vc!.cropView, attribute: .centerX, relatedBy: .equal, toItem: vc!.topView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConst = NSLayoutConstraint(item: vc!.cropView, attribute: .centerY, relatedBy: .equal, toItem: vc!.topView, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConst = NSLayoutConstraint(item: vc!.cropView, attribute: .width, relatedBy: .equal, toItem: vc!.topView, attribute: .width, multiplier: 0.9, constant: 0)
        widthConst.priority = .defaultHigh
        let heightConst = NSLayoutConstraint(item: vc!.cropView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: vc!.topView, attribute: .height, multiplier: 0.9, constant: 0)
        let ratioConst = NSLayoutConstraint(item: vc!.cropView, attribute: .width, relatedBy: .equal, toItem: vc!.cropView, attribute: .height, multiplier: vc!.cropRatio, constant: 0)
        vc!.cropView.addConstraints([ratioConst])
        vc!.topView.addConstraints([widthConst, heightConst, centerXConst, centerYConst])
        vc!.cropView.layer.borderWidth = 1
        vc!.cropView.layer.borderColor = UIColor.white.cgColor
        vc!.cropView.backgroundColor = UIColor.clear
        let centerCropXConst = NSLayoutConstraint(item: vc!.cropButton, attribute: .centerX, relatedBy: .equal, toItem: bottomView, attribute: .centerX, multiplier: cropCenterXMultiplier, constant: 0)
        let centerCropYConst = NSLayoutConstraint(item: vc!.cropButton, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1, constant: 0)
        bottomView.addConstraints([centerCropXConst, centerCropYConst])
        
        vc!.view.bringSubviewToFront(bottomView)
        
        bottomView.layoutIfNeeded()
        vc!.topView.layoutIfNeeded()
    }
    
    /// Set layout subviews
    func viewDidLayoutSubviews()
    {
        guard !(vc!.layoutDone) else {
            return
        }
        vc!.layoutDone = true
        
        if  vc!.ratio < 1 {
            vc!.imageWidthConst?.constant =  vc!.cropView.frame.height /  vc!.ratio
            vc!.imageHeightConst?.constant =  vc!.cropView.frame.height
        } else {
            vc!.imageWidthConst?.constant =  vc!.cropView.frame.width
            vc!.imageHeightConst?.constant =  vc!.cropView.frame.width *  vc!.ratio
        }
        
        let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(<=\( vc!.cropView.frame.origin.x))-[view]-(<=\( vc!.cropView.frame.origin.x))-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view":  vc!.imageView])
        let vertical = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(<=\( vc!.cropView.frame.origin.y))-[view]-(<=\( vc!.cropView.frame.origin.y))-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view":  vc!.imageView])
        vc!.topView.addConstraints(horizontal + vertical)
        
        maskFadeView()
        vc!.orgWidth =  vc!.imageWidthConst!.constant
        vc!.orgHeight =  vc!.imageHeightConst!.constant
    }
    
    
    /// Set fade and mask for view
    func maskFadeView()
    {
        let path = UIBezierPath(rect: vc!.cropView.frame)
        path.append(UIBezierPath(rect: vc!.fadeView.frame))
        let mask = CAShapeLayer()
        mask.fillRule = CAShapeLayerFillRule.evenOdd
        mask.path = path.cgPath
        vc!.fadeView.layer.mask = mask
    }
    
    /// Pinch Gesture on imageview
    /// - Parameter pinch: UIPinchGestureRecognizer
    func pinch(pinch: UIPinchGestureRecognizer)
    {
        if pinch.state == .began {
            vc!.orgWidth = vc!.imageWidthConst!.constant
            vc!.orgHeight = vc!.imageHeightConst!.constant
            vc!.pinchStart = pinch.location(in: vc!.view)
        }
        let scale = pinch.scale
        let height = max(vc!.orgHeight * scale, vc!.cropView.frame.height)
        let width = max(vc!.orgWidth * scale, vc!.cropView.frame.height / vc!.ratio)
        vc!.imageHeightConst?.constant = height
        vc!.imageWidthConst?.constant = width
    }
    
    
    /// Pan Gesture
    /// - Parameter pan: UIPanGestureRecognizer
    func pan(pan: UIPanGestureRecognizer)
    {
        if pan.state == .began {
            vc!.topStart = vc!.topConst!.constant
            vc!.leadStart = vc!.leadConst!.constant
        }
        let trans = pan.translation(in: vc!.view)
        vc!.leadConst?.constant = vc!.leadStart + trans.x
        vc!.topConst?.constant = vc!.topStart + trans.y
    }
    
    /// Function to the crop the image
    func crop() -> UIImage? {
        guard let image = vc?.image else {
            return nil
        }
        let imageSize = image.size
        let width = vc!.cropView.frame.width / vc!.imageView.frame.width
        let height = vc!.cropView.frame.height / vc!.imageView.frame.height
        let x = (vc!.cropView.frame.origin.x - vc!.imageView.frame.origin.x) / (vc?.imageView.frame.width)!
        let y = (vc!.cropView.frame.origin.y - vc!.imageView.frame.origin.y) / (vc?.imageView.frame.height)!
        
        let cropFrame = CGRect(x: x * imageSize.width, y: y * imageSize.height, width: imageSize.width * width, height: imageSize.height * height)
        if let cropCGImage = image.cgImage?.cropping(to: cropFrame) {
            let cropImage = UIImage(cgImage: cropCGImage, scale: 1, orientation: .up)
            return cropImage
        }
        return nil
    }
}
