//
//  Library.swift
//  ZuperFormsSdk
//
//  Created by Apple on 21/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//


import Foundation
import UIKit
import Photos
import AssetsLibrary
import MobileCoreServices
import AVFoundation

/// Attachment Delegate
protocol AttachmentDelegate {
    func passSelectedAttachment(attachementArray: [AttachmentModel])
}

/// Document Delegate
@objc protocol DocumentDelegate {
    @objc optional func getDocumentResponse()
}

/// CapturedImageOrVideo Delegate
protocol CapturedImageOrVideoDelegate {
    func passCaptured(attachmentArray: [AttachmentModel])
}

class Library: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate
{
    static let shared = Library()
    
    //MARK:- Variable Declaration
    var delegate : DocumentDelegate?
    var selectedImages = [String]()
    var getVC : UIViewController!
    var cancel : UIBarButtonItem!
    var viewController: UIViewController?
    var attachmentArray: [AttachmentModel] = []
    var attachmentDelegate: AttachmentDelegate?
    var type:Int = 0
    
    //MARK:- Action sheet - Camera, Photo library & Document
    func showAttachmentActionSheet(viewController: UIViewController)
    {
        getVC = viewController
        
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        /// Capture Image
        let cameraAction = UIAlertAction(title: camera, style: .default, handler:{
            (alert: UIAlertAction) -> Void in
            self.captureImgFromCamera()
        })
        actionSheetController.addAction(cameraAction)
        
        /// Select Image from gallery
        let photoLibrary = UIAlertAction(title: library, style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            //            self.checkPhotoAccessEnabledStatus()
            self.uploadImageFromCamera()
        })
        actionSheetController.addAction(photoLibrary)
        
        /// Select image from iCLoud
        let documentLibrary = UIAlertAction(title: document, style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.showiCloudActionSheet()
        })
        actionSheetController.addAction(documentLibrary)
        
        /// Cancel Action
        let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        actionSheetController.addAction(cancelAction)
        
        
        if isIpad()
        {
            if let currentPopoverpresentioncontroller = actionSheetController.popoverPresentationController
            {
                currentPopoverpresentioncontroller.sourceView = viewController.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:viewController.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                viewController.present(actionSheetController, animated: true, completion: nil)
            }
            
        }
        else
        {
            viewController.present(actionSheetController, animated: true, completion: nil)
        }
    }
    
    
    //MARK:- Seperate iClouddrive action sheet
    func showiCloudActionSheet()
    {
        let actionSheetController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let iCloudDrive = UIAlertAction(title: "iCloud Library", style: .default, handler: {
            (alert: UIAlertAction) -> Void in
            self.uploadFilesFromiCloud()
        })
        actionSheetController.addAction(iCloudDrive)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:{
            (alert: UIAlertAction) -> Void in
            
        })
        actionSheetController.addAction(cancelAction)
        
        if !isIpad()
        {
            getVC.present(actionSheetController, animated: true, completion: nil)
        }
        else
        {
            if let currentPopoverpresentioncontroller = actionSheetController.popoverPresentationController{
                currentPopoverpresentioncontroller.sourceView = getVC.view
                currentPopoverpresentioncontroller.sourceRect = CGRect(x:getVC.view.frame.size.width-50,y:0, width:100,height:100)
                currentPopoverpresentioncontroller.permittedArrowDirections = UIPopoverArrowDirection.up
                getVC.present(actionSheetController, animated: true, completion: nil)
            }
        }
    }
    
    //MARK:- Get Image using Camera
    /// Take a new image
    func captureImgFromCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera)
        {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.camera
            image.allowsEditing = false
            image.mediaTypes = [kUTTypeImage as String]
            image.showsCameraControls = true
            getVC.present(image, animated: true, completion: nil)
        }
    }
    
    /// Select from photos or existing
    func uploadImageFromCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary)
        {
            let image = UIImagePickerController()
            image.delegate = self
            image.sourceType = UIImagePickerController.SourceType.photoLibrary
            image.allowsEditing = false
            image.mediaTypes = [kUTTypeImage as String]
            getVC.present(image, animated: true, completion: nil)
        }
    }
    
    
    /// Rotate the image to proper orientation
    /// - Parameters:
    ///   - imageSource: UIImage
    ///   - maxResolution: CGFloat
    func rotateCameraImageToProperOrientation(imageSource : UIImage, maxResolution : CGFloat = 1024) -> UIImage? {
        
        guard let imgRef = imageSource.cgImage else {
            return nil
        }
        
        let width = CGFloat(imgRef.width)
        let height = CGFloat(imgRef.height)
        
        var bounds = CGRect(x: 0, y: 0, width: width, height: height)
        
        var scaleRatio : CGFloat = 1
        if (width > maxResolution || height > maxResolution) {
            
            scaleRatio = min(maxResolution / bounds.size.width, maxResolution / bounds.size.height)
            bounds.size.height = bounds.size.height * scaleRatio
            bounds.size.width = bounds.size.width * scaleRatio
        }
        
        var transform = CGAffineTransform.identity
        let orient = imageSource.imageOrientation
        let imageSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))
        
        switch(imageSource.imageOrientation) {
        case .up:
            transform = .identity
        case .upMirrored:
            transform = CGAffineTransform
                .init(translationX: imageSize.width, y: 0)
                .scaledBy(x: -1.0, y: 1.0)
        case .down:
            transform = CGAffineTransform
                .init(translationX: imageSize.width, y: imageSize.height)
                .rotated(by: CGFloat.pi)
        case .downMirrored:
            transform = CGAffineTransform
                .init(translationX: 0, y: imageSize.height)
                .scaledBy(x: 1.0, y: -1.0)
        case .left:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: 0, y: imageSize.width)
                .rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .leftMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: imageSize.height, y: imageSize.width)
                .scaledBy(x: -1.0, y: 1.0)
                .rotated(by: 3.0 * CGFloat.pi / 2.0)
        case .right :
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(translationX: imageSize.height, y: 0)
                .rotated(by: CGFloat.pi / 2.0)
        case .rightMirrored:
            let storedHeight = bounds.size.height
            bounds.size.height = bounds.size.width;
            bounds.size.width = storedHeight;
            transform = CGAffineTransform
                .init(scaleX: -1.0, y: 1.0)
                .rotated(by: CGFloat.pi / 2.0)
        }
        
        UIGraphicsBeginImageContext(bounds.size)
        if let context = UIGraphicsGetCurrentContext() {
            if orient == .right || orient == .left {
                context.scaleBy(x: -scaleRatio, y: scaleRatio)
                context.translateBy(x: -height, y: 0)
            } else {
                context.scaleBy(x: scaleRatio, y: -scaleRatio)
                context.translateBy(x: 0, y: -height)
            }
            
            context.concatenate(transform)
            context.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        let imageCopy = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return imageCopy
    }
    
    //MARK:- Image picker delegates
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    {
        let maxuploadValue = 1
        var fileCount = Int()
        
        fileCount = 0
        
        /// Check if its lesser than max upload count
        if fileCount < maxuploadValue
        {
            if  let pickedImage = info[.originalImage] as? UIImage
            {
                let pickedImageFormat = rotateCameraImageToProperOrientation(imageSource: pickedImage)
                if let imgData = pickedImageFormat!.jpegData(compressionQuality: 0.5)
                {
                    
                    print(getFileSizeOfDataInMB(data: pickedImageFormat!.pngData()!))
                    print(getFileSizeOfDataInKB(data: imgData))
                    
                    let imageSize = getFileSizeOfDataInMB(data: imgData)
                    
                    let size = imageSize.components(separatedBy: " ")
                    let fileSize = Double(size[0])!
                    
                    /// Check if filesize is lesser than otherMediaMaxFileSize,if greater show alert
                    if fileSize > Double(otherMediaMaxFileSize)
                    {
                        self.getVC.dismiss(animated: true, completion: nil)
                        AlertView.showAlertView(title: fileSizeExceeded, message: otherDocFileSizeExceeded)
                    }
                    else
                    {
                        let imageFileName = "\(getFileName()).\(png)"
                        let image = UIImage(data: imgData)
                        self.attachmentArray.append(getAttachmentObj(fileName: imageFileName, data: imgData, image: image))
                        self.getVC.dismiss(animated: false, completion: {
                            self.attachmentDelegate?.passSelectedAttachment(attachementArray: self.attachmentArray)
                        })
                    }
                }
                
            }
        }
    }
    
    
    //MARK:- Get Image using iCloud Drive
    func uploadFilesFromiCloud()
    {
        let valueType: [String] = [String(kUTTypeImage)]
        let documentPickerController = UIDocumentPickerViewController(documentTypes:valueType, in: .import)
        documentPickerController.delegate = self
        documentPickerController.navigationController?.navigationBar.topItem?.title = " "
        getVC.present(documentPickerController, animated: true, completion: nil)
        
    }
    
    //MARK:- Document picker delegates
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL)
    {
        let maxuploadValue = attachmentMaxUploadCount
        let fileCount = self.attachmentArray.count
        
        /// Check if its lesser than max upload count
        if fileCount < maxuploadValue
        {
            if let getData = NSData(contentsOf: url)
            {
                var fileSize = Float(getData.length)
                fileSize = fileSize/(1024*1024)
                let urlPath = url.path
                let fileSplittedString = urlPath.components(separatedBy: "/")
                
                /// Check if fileSize is lesser than otherMediaMaxFileSize, if greater show alert
                if fileSize > Float(otherMediaMaxFileSize)
                {
                    AlertView.showAlertView(title: fileSizeExceeded, message: otherDocFileSizeExceeded)
                }
                else
                {
                    if fileSplittedString.count > 0
                    {
                        let fileName = fileSplittedString.last!
                        let modifiedFileName = "\(getFileName()).\(fileName)"
                        self.attachmentArray.append(getAttachmentObj(fileName: modifiedFileName, data: getData as Data, image: nil))
                        self.attachmentDelegate?.passSelectedAttachment(attachementArray: self.attachmentArray)
                        self.getVC.dismiss(animated: true, completion: nil)
                        
                        
                    }
                }
                
            }
        }
    }
    
    
}

extension AVURLAsset {
    var fileSize: Int? {
        let keys: Set<URLResourceKey> = [.totalFileSizeKey, .fileSizeKey]
        let resourceValues = try? url.resourceValues(forKeys: keys)
        
        return resourceValues?.fileSize ?? resourceValues?.totalFileSize
    }
}



//MARK:- Delay in calling methods
func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
        completion()
    }
}

