//
//  Constants.swift
//  ZuperCovidFramework
//
//  Created by Zuper on 17/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation
import UIKit


/// Root Endpoint
var endpoint: String = ZuperEnvironments.local.rawValue

var companyUid: String! = EMPTY
var companyUrl: String! = EMPTY
var userEmail: String! = EMPTY
var companyImg: UIImage?
var cmpName: String! = EMPTY
var checklistUid: String! = EMPTY

//MARK:- Network Status
var networkStatus : Bool = false

var companyConfig:CompanyConfigData!

//MARK:- Status

let success = "success"
let message = "message"
let errorTitle = "Sorry"

struct xibNames {
    static var loginController = "LoginController"
    static var ZuperForm = "ZuperForm"
    static var SectionCell = "SectionCell"
    static var SingleTextFieldCell = "SingleTextFieldCell"
    static var MultilineCell = "MultilineCell"
    static var RadioTypeCell = "RadioTypeCell"
    static var CheckBoxTypeCell = "CheckBoxTypeCell"
    static var QuestionTypeCell = "QuestionTypeCell"
    static var ImageTypeCell = "ImageTypeCell"
}

struct TableViewIdentifier {
    static var SectionCell = "SectionCell"
    static var SingleTextFieldCell = "SingleTextFieldCell"
    static var MultilineCell = "MultilineCell"
    static var RadioTypeCell = "RadioTypeCell"
    static var CheckBoxTypeCell = "CheckBoxTypeCell"
    static var QuestionTypeCell = "QuestionTypeCell"
    static var ImageTypeCell = "ImageTypeCell"
}


struct StoryBoardName {
    static var Checklist = "Checklist"
    static var MediaLibrary = "MediaLibrary"
}

struct ViewcontrollerIdentifier {
    static var LoginController = "LoginController"
    static var SectionListController = "SectionListController"
    static var ChecklistDetailController = "ChecklistDetailController"
    static var ImageMarkUpViewController = "ImageMarkUpViewController"
    static var SuccessController = "SuccessController"
}

var EMPTY = ""

let Defaults = UserDefaults.standard
struct UserDefaultsKeys {
  static let accessToken = "ACCESS_TOKEN"
    static let userDetails = "USER_DETAILS"
}

/// Class used to customize the views.
public class ZuperFormsTheme {
   
    public static var primaryColor: UIColor = convertHextoUIColor(hexString: "#6633D2")
    /// Background color of the views
    public static var backgroundColor: UIColor = convertHextoUIColor(hexString: "#F7F6F6")
    /// Background used for the Card View
    public static var cardViewBackgroundColor: UIColor = .white
    /// Label color
    public static var labelTextColor: UIColor = .black
    /// TextField, TextView color
    public static var textFieldTextColor: UIColor = .black
    /// Button next and submit Background  color
    public static var buttonSubmitNextColor: UIColor = convertHextoUIColor(hexString: "#21C677")
    /// Button prev background  color
    public static var buttonPreviousColor: UIColor = .darkGray
    /// Button next and submit text color
    public static var buttonSubmitNextTextColor: UIColor = .white
    /// Button prev text color
    public static var buttonPreviousTextColor: UIColor = .white
    /// Error text color
    public static var errorColor: UIColor = .red
    /// Checklist View BackgroundColor
    public static var checklistViewBackgroundColor: UIColor = convertHextoUIColorWithAlpha(hexString: "#000000",alpha:0.8)
    /// Progress bar Color
    public static var progressBarColor: UIColor = convertHextoUIColor(hexString: "#60AE4D")
    /// Font
    public static var font: UIFont = UIFont.systemFont(ofSize: UIFont.systemFontSize)
     /// Navbartintcolor
    public static var navBarTintColor: UIColor = .white
}

struct ChecklistQuestionType {
    static let text = "TEXT"
    static let dropDown = "DROPDOWN"
    static let radio = "RADIO"
    static let image = "IMAGE"
    static let number = "NUMBER"
    static let checkBox = "CHECKBOX"
    
}














