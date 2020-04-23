//
//  ImageCropperController.swift
//  ZuperFormsSdk
//
//  Created by Apple on 21/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import UIKit

public class UIImageCropper: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK:- Variable Declarataion
    public var cropRatio: CGFloat = 1
    public weak var delegate: UIImageCropperProtocol?
    public var cropButtonText: String = "Crop"
    public var cancelButtonText: String = "Retake"
    public var image: UIImage? {
        didSet {
            guard let image = self.image else {
                return
            }
            layoutDone = false
            ratio = image.size.height / image.size.width
            imageView.image = image
            self.view.layoutIfNeeded()
        }
    }
    public var cropImage: UIImage? {
        return crop()
    }
    public var autoClosePicker: Bool = true
    
    /// UIViews
    let topView = UIView()
    let fadeView = UIView()
    let imageView: UIImageView = UIImageView()
    let cropView: UIView = UIView()
    
    /// Constraints
    var topConst: NSLayoutConstraint?
    var leadConst: NSLayoutConstraint?
    var imageHeightConst: NSLayoutConstraint?
    var imageWidthConst: NSLayoutConstraint?
    var ratio: CGFloat = 1
    var layoutDone: Bool = false
    var orgHeight: CGFloat = 0
    var orgWidth: CGFloat = 0
    var topStart: CGFloat = 0
    var leadStart: CGFloat = 0
    var pinchStart: CGPoint = .zero
    
    //UIButtons
    let cropButton = UIButton(type: .custom)
    let cancelButton = UIButton(type: .custom)
    
    var attachmentArray: [AttachmentModel] = []
    var imageCropperViewModel: ImageCropperViewModel!
    
    //MARK: - inits
    /// initializer
    /// - parameter cropRatio
    /// Aspect ratio of the cropped image
    convenience public init(cropRatio: CGFloat) {
        self.init()
        self.cropRatio = cropRatio
    }
    
    //MARK: - overrides (View Controller LifeCycle)
    override public func viewDidLoad()
    {
        super.viewDidLoad()
        self.setDefaults()
        
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.cancelButton.setTitle(cancelButtonText, for: .normal)
        self.cropButton.setTitle(cropButtonText, for: .normal)
        
        if image == nil {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.imageCropperViewModel.viewDidLayoutSubviews()
    }
    
    private func maskFadeView() {
        self.imageCropperViewModel.maskFadeView()
    }
    
    //MARK: - Button actions
    /// Done action after cropping
    @objc func cropDone() {
        
        self.dismiss(animated: false, completion: {
            self.delegate?.didCropImage(originalImage: self.image, croppedImage: self.cropImage)
        })
        
    }
    
    /// Cancel the cropped image
    @objc func cropCancel() {
        
        self.dismiss(animated: false, completion: {
            self.delegate?.didCropImage(originalImage: nil, croppedImage: nil)
        })
        
    }
    
    //MARK: - Gsture handling
    @objc func pinch(_ pinch: UIPinchGestureRecognizer) {
        self.imageCropperViewModel.pinch(pinch: pinch)
    }
    
    @objc func pan(_ pan: UIPanGestureRecognizer) {
        self.imageCropperViewModel.pan(pan: pan)
    }
    
    //MARK: - Cropping done here
    private func crop() -> UIImage? {
        return self.imageCropperViewModel.crop()
    }
    
    /// Set defaults
    func setDefaults()
    {
        self.view.backgroundColor = UIColor.black
        self.imageCropperViewModel = ImageCropperViewModel(viewController: self)
        
        //main views
        topView.backgroundColor = UIColor.clear
        let bottomView = UIView()
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        self.view.addSubview(topView)
        self.view.addSubview(bottomView)
        topView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        let horizontalTopConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": topView])
        let horizontalBottomConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": bottomView])
        let verticalConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top]-(0)-[bottom(70)]-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["bottom": bottomView, "top": topView])
        self.view.addConstraints(horizontalTopConst + horizontalBottomConst + verticalConst)
        
        // image view
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(imageView)
        topConst = NSLayoutConstraint(item: imageView, attribute: .top, relatedBy: .equal, toItem: topView, attribute: .top, multiplier: 1, constant: 0)
        topConst?.priority = .defaultHigh
        leadConst = NSLayoutConstraint(item: imageView, attribute: .leading, relatedBy: .equal, toItem: topView, attribute: .leading, multiplier: 1, constant: 0)
        leadConst?.priority = .defaultHigh
        imageWidthConst = NSLayoutConstraint(item: imageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: 1)
        imageWidthConst?.priority = .required
        imageHeightConst = NSLayoutConstraint(item: imageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 1)
        imageHeightConst?.priority = .required
        imageView.addConstraints([imageHeightConst!, imageWidthConst!])
        topView.addConstraints([topConst!, leadConst!])
        imageView.image = self.image
        
        // imageView gestures
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        imageView.addGestureRecognizer(pinchGesture)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(pan))
        imageView.addGestureRecognizer(panGesture)
        imageView.isUserInteractionEnabled = true
        
        //fade overlay
        fadeView.translatesAutoresizingMaskIntoConstraints = false
        fadeView.isUserInteractionEnabled = false
        fadeView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        topView.addSubview(fadeView)
        let horizontalFadeConst = NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": fadeView])
        let verticalFadeConst = NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[view]-(0)-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["view": fadeView])
        topView.addConstraints(horizontalFadeConst + verticalFadeConst)
        
        // crop overlay
        cropView.translatesAutoresizingMaskIntoConstraints = false
        cropView.isUserInteractionEnabled = false
        topView.addSubview(cropView)
        let centerXConst = NSLayoutConstraint(item: cropView, attribute: .centerX, relatedBy: .equal, toItem: topView, attribute: .centerX, multiplier: 1, constant: 0)
        let centerYConst = NSLayoutConstraint(item: cropView, attribute: .centerY, relatedBy: .equal, toItem: topView, attribute: .centerY, multiplier: 1, constant: 0)
        let widthConst = NSLayoutConstraint(item: cropView, attribute: .width, relatedBy: .equal, toItem: topView, attribute: .width, multiplier: 0.9, constant: 0)
        widthConst.priority = .defaultHigh
        let heightConst = NSLayoutConstraint(item: cropView, attribute: .height, relatedBy: .lessThanOrEqual, toItem: topView, attribute: .height, multiplier: 0.9, constant: 0)
        let ratioConst = NSLayoutConstraint(item: cropView, attribute: .width, relatedBy: .equal, toItem: cropView, attribute: .height, multiplier: cropRatio, constant: 0)
        cropView.addConstraints([ratioConst])
        topView.addConstraints([widthConst, heightConst, centerXConst, centerYConst])
        cropView.layer.borderWidth = 1
        cropView.layer.borderColor = UIColor.white.cgColor
        cropView.backgroundColor = UIColor.clear
        
        var cropCenterXMultiplier: CGFloat = 1.0
        
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitle(cancelButtonText, for: .normal)
        cancelButton.addTarget(self, action: #selector(cropCancel), for: .touchUpInside)
        bottomView.addSubview(cancelButton)
        let centerCancelXConst = NSLayoutConstraint(item: cancelButton, attribute: .centerX, relatedBy: .equal, toItem: bottomView, attribute: .centerX, multiplier: 0.5, constant: 0)
        let centerCancelYConst = NSLayoutConstraint(item: cancelButton, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1, constant: 0)
        bottomView.addConstraints([centerCancelXConst, centerCancelYConst])
        cropCenterXMultiplier = 1.5
        
        // control buttons
        cropButton.translatesAutoresizingMaskIntoConstraints = false
        cropButton.addTarget(self, action: #selector(cropDone), for: .touchUpInside)
        bottomView.addSubview(cropButton)
        let centerCropXConst = NSLayoutConstraint(item: cropButton, attribute: .centerX, relatedBy: .equal, toItem: bottomView, attribute: .centerX, multiplier: cropCenterXMultiplier, constant: 0)
        let centerCropYConst = NSLayoutConstraint(item: cropButton, attribute: .centerY, relatedBy: .equal, toItem: bottomView, attribute: .centerY, multiplier: 1, constant: 0)
        bottomView.addConstraints([centerCropXConst, centerCropYConst])
        
        self.view.bringSubviewToFront(bottomView)
        
        bottomView.layoutIfNeeded()
        topView.layoutIfNeeded()
    }
}
