//
//  Functions.swift
//  ZuperCovidFramework
//
//  Created by Zuper on 17/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation
import UIKit
import NVActivityIndicatorView
import EmptyStateKit


//MARK:- User network status
func isUserOnline() -> Bool
{
    return networkStatus
}
//Define all colors here


//MARK:- Loader Functions
func removeActivityIndicator()
{
    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
}

func showCommonLoader()
{
    if NVActivityIndicatorPresenter.sharedInstance.isAnimating
    {
        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
    }
    let presentingIndicatorTypes = {
        return NVActivityIndicatorType.allCases.filter { $0 != .blank }
    }()
    let size = CGSize(width: 70, height: 70)
    let activityData = ActivityData(size: size, message: "",type:presentingIndicatorTypes[23], color:UIColor.white,textColor: UIColor.white)
    
    // NVActivityIndicatorPresenter.sharedInstance.setMessage("Loading...")
    NVActivityIndicatorPresenter.sharedInstance.startAnimating(activityData)
    //showActivityIndicator(loaderText: commonLoaderText, isUserInteractionEnabled: false)
}

//MARK:- Convert Hex to UIColor
func convertHextoUIColor(hexString: String) -> UIColor
{
    let hexaString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let scanner = Scanner(string: hexaString)
    if (hexaString.hasPrefix("#")) {
        scanner.scanLocation = 1
    }
    var color: UInt32 = 0
    scanner.scanHexInt32(&color)
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
}
func convertHextoUIColorWithAlpha(hexString: String,alpha:CGFloat) -> UIColor
{
    let hexaString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    let scanner = Scanner(string: hexaString)
    if (hexaString.hasPrefix("#")) {
        scanner.scanLocation = 1
    }
    var color: UInt32 = 0
    scanner.scanHexInt32(&color)
    let mask = 0x000000FF
    let r = Int(color >> 16) & mask
    let g = Int(color >> 8) & mask
    let b = Int(color) & mask
    let red   = CGFloat(r) / 255.0
    let green = CGFloat(g) / 255.0
    let blue  = CGFloat(b) / 255.0
    return UIColor(red: red, green: green, blue: blue, alpha: 0.2)
}

//MARK:- Get Label Color
func getLabelTextColor() -> UIColor
{
    return ZuperFormsTheme.labelTextColor
}

func getTextFieldTextColor() -> UIColor
{
    return ZuperFormsTheme.textFieldTextColor
}

func getNextOrSubmitButtonColor() -> UIColor
{
    return ZuperFormsTheme.buttonSubmitNextColor
}

func getNextOrSubmitTextColor() -> UIColor
{
    return ZuperFormsTheme.buttonSubmitNextTextColor
}

func getPreviousButtonColor() -> UIColor
{
    return ZuperFormsTheme.buttonPreviousColor
}

func getPreviousButtonTextColor() -> UIColor
{
    return ZuperFormsTheme.buttonPreviousTextColor
}

func getHeaderColor() -> UIColor
{
    return ZuperFormsTheme.primaryColor
}

func getButtonColor() -> UIColor
{
    return ZuperFormsTheme.primaryColor
}

func getLoginButtonTextColor() -> UIColor
{
    return ZuperFormsTheme.buttonSubmitNextTextColor
}

func getViewBackgroundColor() -> UIColor
{
    return ZuperFormsTheme.backgroundColor
}

func getCardViewBackgroundColor() -> UIColor
{
    return ZuperFormsTheme.cardViewBackgroundColor
}

func getChecklistViewBackgroundColor() -> UIColor
{
    return ZuperFormsTheme.checklistViewBackgroundColor
}

//Save User Token
func saveUserToken(loginDetails: LoginDetails)
{
    Defaults.setValue(loginDetails.authToken, forKey: UserDefaultsKeys.accessToken)
}

// Get Access Token
func getAccesToken() -> String?
{
    if let token = Defaults.value(forKey: UserDefaultsKeys.accessToken)
    {
        return token as? String
    }
    return nil
}

//Save User Details
func saveUserDetails(loginDetails: LoginDetails){
    
    let encoder = JSONEncoder()
    if let encoded = try? encoder.encode(loginDetails) {
        Defaults.set(encoded , forKey: UserDefaultsKeys.userDetails)
    }
}


/// Get User details
func getUserDetails() -> LoginDetails?{
    if let user = Defaults.value(forKey: UserDefaultsKeys.userDetails) as? Data {
        let decoder = JSONDecoder()
        if let userObj = try? decoder.decode(LoginDetails.self, from: user) {
            return userObj
        }
    }
    
    return nil
}

/// Get User Full name
func getUserName() -> String{
    if let user = Defaults.value(forKey: UserDefaultsKeys.userDetails) as? Data {
        let decoder = JSONDecoder()
        if let userObj = try? decoder.decode(LoginDetails.self, from: user) {
            
            let firstName = userObj.companyAccount?.firstName ?? EMPTY
            let lastName = userObj.companyAccount?.lastName ?? EMPTY
            return "\(firstName) \(lastName)"
        }
    }
    
    return EMPTY
}

//MARK:- Empty State

func setEmptyState(view:UIView){
    
    view.emptyState.format = getEmptyStateFormat()
}



/// Get empty state format
func getEmptyStateFormat() -> EmptyStateFormat{
    var format = EmptyStateFormat()
    format.buttonColor = ZuperFormsTheme.primaryColor
    format.position = EmptyStatePosition(view: .top, text: .left, image: .top)
    format.verticalMargin = 20
    format.horizontalMargin = 40
    format.imageSize = CGSize(width: 80, height: 100)
    format.imageTintColor = ZuperFormsTheme.primaryColor
    format.buttonShadowRadius = 0
    
    return format
}

// Get current date
func getCurrentDateAndTime() -> Date
{
    return Date()
}

/// Get attributed String
/// - Parameter text: text to be added *
func getAttributedString(text: String) -> NSMutableAttributedString
{
    let attributedText = NSMutableAttributedString()
    attributedText.append(NSMutableAttributedString(string: text))
    attributedText.append(mandatoryText)
    return attributedText
    
}
