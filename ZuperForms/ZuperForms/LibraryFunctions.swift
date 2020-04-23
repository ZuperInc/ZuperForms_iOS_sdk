//
//  LibraryFunctions.swift
//  ZuperFormsSdk
//
//  Created by Apple on 21/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation
import Photos
import UIKit

let videoMaxFileSize = 20
let otherMediaMaxFileSize = 20
let attachmentMaxUploadCount = 1
let png = "png"

//MARK:- To know Ipad or Mobile
func isIpad() -> Bool
{
    if UIDevice.current.userInterfaceIdiom == .pad
    {
        return true
    }
    else
    {
        return false
    }
}


/// Get the size of the file in MB
/// - Parameter fileURL: URL
func getFileSizeInMB(fileURL: URL) -> Double
{
    let fileAttributes = try! FileManager.default.attributesOfItem(atPath: fileURL.path)
    let fileSizeNumber = fileAttributes[FileAttributeKey.size] as! NSNumber
    let fileSize = fileSizeNumber.int64Value
    var sizeMB = Double(fileSize / 1024)
    sizeMB = Double(sizeMB / 1024)
    
    return sizeMB
}


/// Get the size of the file in KB
/// - Parameter data: Data
func getFileSizeOfDataInKB(data: Data) -> String
{
    let bcf = ByteCountFormatter()
    bcf.allowedUnits = [.useKB] // optional: restricts the units to MB only
    bcf.countStyle = .file
    let kb = bcf.string(fromByteCount: Int64(data.count))
    return kb
}

/// Get the size of the file in MB
/// - Parameter fileURL: Data
func getFileSizeOfDataInMB(data: Data) -> String
{
    let bcf = ByteCountFormatter()
    bcf.allowedUnits = [.useMB] // optional: restricts the units to MB only
    bcf.countStyle = .file
    let mb = bcf.string(fromByteCount: Int64(data.count))
    return mb
}

/// Get a attachment obj from AttachmentModel
/// - Parameters:
///   - fileName: filename - String
///   - data: Data
///   - image: UIImage
func getAttachmentObj(fileName: String,data: Data,image: UIImage?) -> AttachmentModel
{
    let attachmentObj = AttachmentModel(fileName: fileName, image: image, data: data)
    return attachmentObj
}

/// Get filename
func getFileName() -> String
{
    var fileName: String = ""
    
    let formatter = DateFormatter()
    formatter.dateFormat = "ddMMyyyyhhmmssSSS"
    let timestamp:String = formatter.string(from: getCurrentDateAndTime())
    fileName = "\(timestamp)"
    
    return fileName
}

/// UIImage Extension
extension UIImage {
    /**
     Suitable size for specific height or width to keep same image ratio
     */
    func suitableSize(heightLimit: CGFloat? = nil,
                      widthLimit: CGFloat? = nil )-> CGSize? {
        
        if let height = heightLimit {
            
            let width = (height / self.size.height) * self.size.width
            
            return CGSize(width: width, height: height)
        }
        
        if let width = widthLimit {
            let height = (width / self.size.width) * self.size.height
            return CGSize(width: width, height: height)
        }
        
        return nil
    }
}


/// Navigate to image mark up controller
/// - Parameters:
///   - image: UIImage
///   - attachmentList: Array of AttachmentModel
///   - viewController: UIViewController from which we navigate
func navigateToImageMarkUpViewController(image: UIImage,attachmentList: [AttachmentModel],viewController: UIViewController)
{
    let myBundle = Bundle(for: ImageMarkUpViewController.self)
    let sb = UIStoryboard(name: StoryBoardName.MediaLibrary, bundle: myBundle)
    let vc = sb.instantiateViewController(withIdentifier: ViewcontrollerIdentifier.ImageMarkUpViewController) as! ImageMarkUpViewController
    vc.image = image
    vc.imageMarkUpDelegate = viewController as? ImageMarkUpDelegate
    vc.attachmentArray = attachmentList
    viewController.navigationController?.pushViewController(vc, animated: true)
}
