//
//  TextFieldCellData.swift
//  MyProHelper
//
//

import UIKit

enum DataType {
    case Text
    case Mobile
    case Date
    case Time
    case TimeFrame
    case ListView
    case PickerView
    case ZipCode
}

class TextFieldCellData {
    let title           : String
    let key             : String
    let type            : DataType
    let isRequired      : Bool
    let isActive        : Bool
    let keyboardType    : UIKeyboardType
    var validation      : ValidationResult
    var text            : String?
    var listData        : [String]
    var listItemIndex   : Int?
    
    init(title: String, key: String, dataType: DataType, isRequired: Bool = false, isActive: Bool = true, keyboardType: UIKeyboardType = .default, validation: ValidationResult,text: String? = nil, listData:[String] = []) {
        self.title          = title
        self.key            = key
        self.type           = dataType
        self.isRequired     = isRequired
        self.isActive       = isActive
        self.keyboardType   = keyboardType
        self.text           = text
        self.validation     = validation
        self.listData       = listData
    }
}
