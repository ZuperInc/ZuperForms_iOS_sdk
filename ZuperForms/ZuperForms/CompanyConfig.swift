//
//  CompanyConfig.swift
//  ZuperCovidFramework
//
//  Created by Zuper on 18/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation

/*
 {
     "type": "success",
     "data": {
         "mandate_signin": false,
         "enable_sso": false,
         "timezone": "India Standard Time",
         "date_format": "DD/MM/YYYY",
         "language": "English",
         "company": "5e99b80a700aa541c076f682"
     }
 }

 */


// MARK: - CompanyConfig
struct CompanyConfig: Codable {
    let type: String?
    let data: CompanyConfigData?
}

// MARK: - DataClass
struct CompanyConfigData: Codable {
    let mandateSignin, enableSso: Bool?
    let timezone, dateFormat, language, company: String?

    enum CodingKeys: String, CodingKey {
        case mandateSignin = "mandate_signin"
        case enableSso = "enable_sso"
        case timezone
        case dateFormat = "date_format"
        case language, company
    }
}

