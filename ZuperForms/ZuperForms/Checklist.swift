//
//  Checklist.swift
//  ZuperCovidFramework
//
//  Created by Zuper on 18/04/20.
//  Copyright © 2020 Zuper. All rights reserved.
//

import Foundation
import UIKit

// MARK: - ChecklistData
struct ChecklistData: Codable {
    let type: String?
    let data: [Checklist]?
}

// MARK: - Checklist
struct Checklist: Codable {
    let isDeleted, isActive: Bool?
    let checklistName, checklistDescription: String?
    var checklistQuestions: [ChecklistQuestion]?
    let companyChecklistUid, createdAt, updatedAt: String?
    let v: Int?

    enum CodingKeys: String, CodingKey {
        case isDeleted = "is_deleted"
        case isActive = "is_active"
        case checklistName = "checklist_name"
        case checklistDescription = "checklist_description"
        case checklistQuestions = "checklist_questions"
        case companyChecklistUid = "company_checklist_uid"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case v = "__v"
    }
}

// MARK: - ChecklistQuestion
struct ChecklistQuestion: Codable {
    let fieldOptions: [String]?
    let isMandatory, isDependant: Bool?
    let id, fieldName, fieldKey, fieldType: String?
    let dependantKey, dependantValue: String?
    var fieldAnswer = EMPTY
    var selectedIndex:Int?
    var optionsList:[FieldOption] = []
    var selectedImage: UIImage!

    enum CodingKeys: String, CodingKey {
        case fieldOptions = "field_options"
        case isMandatory = "is_mandatory"
        case isDependant = "is_dependant"
        case id = "_id"
        case fieldName = "field_name"
        case fieldKey = "field_key"
        case fieldType = "field_type"
        case dependantKey = "dependant_key"
        case dependantValue = "dependant_value"
    }
}

struct FieldOption
{
    var option:String!
    var isSelected: Bool = false
    
    init(fieldOption: String) {
        option = fieldOption
    }
}


func convertToFiledOption(strArray:[String]) -> [FieldOption]{
    
    var fieldOptionArray:[FieldOption] = []
    
    for obj in strArray{
        let obj = FieldOption(fieldOption: obj)
        fieldOptionArray.append(obj)
    }
    
    return fieldOptionArray
    
}
