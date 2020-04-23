//
//  Login.swift
//  ZuperCovidFramework
//
//  Created by Zuper on 18/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation

// MARK: - LoginDetails
struct LoginDetails: Codable {
    let authToken, expiresAt, type: String?
    let companyAccount: CompanyAccount?

    enum CodingKeys: String, CodingKey {
        case authToken = "auth_token"
        case expiresAt = "expires_at"
        case type
        case companyAccount = "company_account"
    }
}

// MARK: - CompanyAccount
struct CompanyAccount: Codable {
    let firstName, lastName, designation, email: String?
    let role, phoneNo, profilePicture, companyAccountUid: String?
    let createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case designation, email, role
        case phoneNo = "phone_no"
        case profilePicture = "profile_picture"
        case companyAccountUid = "company_account_uid"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case v = "__v"
    }
}
