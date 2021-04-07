//
//  Constants.swift
//  MyProHelper
//

import Foundation
import UIKit

///Constants
struct Constants {
    
    static let STANDARD_DATE                = "yyyy-MM-dd HH:mm:ss"
    static let STANDARD_DATE_WITHOUT_HOURS  = "yyyy-MM-dd"
    static let DATE_FORMAT                  = "yyyy-dd-MM"
    static let TIME_FORMAT                  = "hh:mm a"
    static let TIME_FRAME_FORMAT            = "HH:mm:ss"
    static let DATA_OFFSET                  = 10
    static let COMPANY_TIME_FRAME           = "00:30:00"
    
    
    enum Storyboard: String {
        case HOME                      = "Home"
        case AUTH                      = "Auth"
        case CUSTOMERS                 = "Customers"
        case VENDORS                   = "Vendors"
        case PART_LOCATION             = "PartLocation"
        case SUPPLY_LOCATION           = "SupplyLocation"
        case PART                      = "Part"
        case SUPPLY                    = "Supply"
        case SERVICE                   = "Service"
        case ASSET_TYPE                = "AssetType"
        case ASSET                     = "Asset"
        case WORKER                    = "WorkerList"
        case SCHEDULE_JOB              = "ScheduleJobs"
        case HELP                      = "Help"
        case DEVICES                   = "Devices"
        case HOLIDAYS                  = "Holidays"
        case JOB_HISTORY               = "JobHistory"
        case JOB_HISTORY_DETAILS_VIEW  = "JobHistoryDetailsView"
        case JOB_CONFIRMATION          = "JobConfirmation"
        case JOB_DECLINE               = "JobDecline"
        case QUOTES                    = "Quotes"
        case ESTIMATES                 = "Estimates"
        case CUSTOMER_JOB_HISTORY      = "CustomerJobHistoryView"
        case SHOW_JOB_HISTORY          = "ShowJobHistory"
        case QUOTES_ESTIMATES          = "QuotesEstimates"
        case INVOICE                   = "Invoice"
        case PAYMENT                   = "Payment"
        case RECEIPT                   = "Receipt"
        case ITEM_USED_CONFIRMATION    = "ItemUsedConfirmation"
        case JOB_DETAIL                = "JobDetail"
        case APPROVAL_LIST             = "ApprovalsList"
        case ADD_TIMEOFF               = "AddTimeOff"
        case ADDTIMEOFF               = "AddtimeShow"

    }
    
    struct magicValues {
        static var viewOffsetForKeyboard:CGFloat = 100
    }
    
    struct themeConfiguration {
        
        struct layer {
            static let theme:CGFloat = 10
            static let borderWidth:CGFloat = 1
            static let borderColor:CGColor = UIColor.lightGray.cgColor
        }
        
        struct textSize {
            static let small:CGFloat = 10
            static let medium:CGFloat = 12
            static let large:CGFloat = 18
        }
        
        struct font {
            static let smallFont = UIFont.systemFont(ofSize: textSize.small)
            static let mediumFont = UIFont.systemFont(ofSize: textSize.medium)
            static let largeFont = UIFont.systemFont(ofSize: textSize.large)
        }
        
    }
    
    struct Dimension {
        static let BUTTON_HEIGHT: CGFloat = 42
        static let TEXT_FIELD_BORDER_WIDTH: CGFloat = 0.5
    }

    struct  Colors {
        static let TEXT_FIELD_DEFAULT_COLOR     = UIColor(white: 0, alpha: 0.15)
        static let TEXT_FIELD_ERROR_COLOR       = UIColor.systemRed
        static let DARK_NAVIGATION              = UIColor(red: 31/255, green: 53/255, blue: 96/255, alpha: 1)
        static let NAVIGATION_BAR_TEXT_COLOR    = UIColor.white

    }
    
    struct Image {
        static let JOB_LIST             = "icons8-list-view-50"
        static let CALENDAR             = "icons8-person-calendar-50"
        static let CUSTOMERS            = "icons8-account-50"
        static let JOBS                 = "icons8-new-job-50"
        static let INVENTORY            = "icons8-warehouse-50"
        static let WORKERS              = "icons8-workers-50"
        static let PAYROLL              = "icons8-money-bag-50"
        static let APPROVALS            = "icons8-receipt-approved-50"
        static let REPORTS              = "icons8-pie-chart-50"
        static let MASTER_SETUP         = "icons8-phonelink-setup-50"
        static let HELP                 = "icons8-help-50"
        static let CIRCLE_CLOSE_BUTTON  = "icons8-macos-close-32"
    }
    
    
    struct Message {
        static let NAME_ERROR               = "Please enter a valid name"
        static let PHONE_ERROR              = "Please enter a valid phone number"
        static let EMAIL_ERROR              = "please enter a valid email"
        static let ADDRESS_ERROR            = "please enter a valid address"
        static let CITY_ERROR               = "please enter a valid city"
        static let STATE_ERROR              = "please enter a valid state"
        static let ZIP_CODE_ERROR           = "please enter a valid zip code"
        static let DATE_ERROR               = "please enter a valid date"
        static let DELETE_ROW               = "Are you sure you want to delete this row?"
        static let DELETE_CUSTOMER_ERROR    = "Failed to delete customer"
        static let DELETE_VENDOR            = "Are you sure you want to delete this vendor?"
        static let DELETE_VENDOR_ERROR      = "Failed to delete vendor"
        static let GENERIC_FIELD_ERROR      = "please enter a valid value"
        static let ACCOUNT_NUMBER_ERROR     = "please enter a valid account number"
        static let DESCRIPTION_ERROR        = "please enter a valid description"
        static let PRICE_ERROR              = "please enter a valid price"
        static let TYPE_ERRPR               = "please enter a valid type"
        static let INFO_ERROR               = "please enter a valid information"
        static let SERIAL_NUMBER_ERROR      = "please enter a valid serial number"
        static let TITLE_ERROR              = "Please provide title"
        static let SALARY_PER_TIME_ERROR    = "Please provide salary per time"
    }
}
