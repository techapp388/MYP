//
//  ViewFactory.swift
//  MyProHelper
//
//
//  Created by Benchmark Computing on 01/07/20.
//  Copyright © 2020 Benchmark Computing. All rights reserved.
//

import Foundation
import UIKit

public enum ControllerKeys:String,CaseIterable {
    case calendar = "Calendar"
    case jobList = "Job List"
    case customerList = "Customers List"
    case scheduleJobs = "Scheduled Jobs"
    case sales = "Sales"
    case parts = "Parts"
    case quotesAndEstimates = "Quotes/Estimates"
    case workersList = "Workers List"
    case masterSetup = "Master Setup"
    case technicalSupport = "Technical Support"
    case contactUs = "Contact Us"
    case adjustCompanySettings = "Adjust Company settings"
    case worker = "Worker"
    case serviceType = "ServiceType"
    case vendors = "Vendors"
    case partLocation = "PartLocation"
    case supplyLocation = "SupplyLocation"
    case assetType = "AssetType"
    case asset = "Asset"
    case aboutProgram = "AboutProgram"
    case holidays = "Holidays"
    case jobHistory = "Job History"
    case jobConfirmation = "Job Confirmation"
    case jobDecline = "Job Decline"
    case invoice = "Invoice"
    case payment = "payment"
    case jobDetail = "JobDetail"
    case receipt = "receipt"
    case timeoffapproval = "TimeOff Approval"
    case AddTimeOffApproval = "AddTimeOffApproval"
    
}

struct ControllerFactory {
    
    private var keys:[ControllerKeys] = []

    init(keys:[ControllerKeys]) {
        self.keys = keys
    }
    
    init(withAllkeys:[ControllerKeys] = ControllerKeys.allCases) {
        self.keys = withAllkeys
    }
    
    func instantiateControllers() -> [GenericViewController] {
        var viewControllers = [GenericViewController]()
        for key in keys {
          viewControllers.append(getViewController(from: key))
        }
        return viewControllers
      }
    
    func getViewController(from key:ControllerKeys) -> GenericViewController {
        switch key {
        case .calendar:
            return GenericViewController(viewController: CalendarViewController(),key: key)
        case .jobList:
            let jobList = JobListView.instantiate(storyboard: .SCHEDULE_JOB)
            return GenericViewController(viewController: jobList, key: key)
        case .customerList:
            let customerList = CustomerListView.instantiate(storyboard: .CUSTOMERS)
            return GenericViewController(viewController: customerList, key: key)
        case .scheduleJobs:
            let createJob = CreateJobView.instantiate(storyboard: .SCHEDULE_JOB)
            createJob.viewModel = CreateJobViewModel(attachmentSource: .SCHEDULED_JOB)
            createJob.setViewMode(isEditingEnabled: true)
            return GenericViewController(viewController: createJob, key: key)
        case .sales:
            return GenericViewController(viewController: GenericMenuSubmenuViewController(),key: key)
        case .parts:
            let partListView = PartListView.instantiate(storyboard: .PART)
            return GenericViewController(viewController: partListView, key: .parts)
        case .workersList:
            let workerListView = WorkerListView.instantiate(storyboard: .WORKER)
            return GenericViewController(viewController: workerListView,key: key)
        case .masterSetup:
            return GenericViewController(viewController: GenericMenuSubmenuViewController(),key: key)
        case .technicalSupport:
            return GenericViewController(viewController: GenericMenuSubmenuViewController(),key: key)
        case .contactUs:
            return GenericViewController(viewController: GenericMenuSubmenuViewController(),key: key)
        case .adjustCompanySettings:
            return GenericViewController(viewController: GenericMenuSubmenuViewController(),key: key)
        case .worker:
            return GenericViewController(viewController: GenericMenuSubmenuViewController(),key: key)
        case .vendors:
            let vendorList = VendorListView.instantiate(storyboard: .VENDORS)
            return GenericViewController(viewController: vendorList, key: key)
        case .partLocation:
            let partLocationList = PartLocationListView.instantiate(storyboard: .PART_LOCATION)
            return GenericViewController(viewController: partLocationList, key: key)
        case .supplyLocation:
            let supplyLocation = SupplyLocationListView.instantiate(storyboard: .SUPPLY_LOCATION)
            return GenericViewController(viewController: supplyLocation, key: key)
        case .serviceType:
            let serviceView = ServiceListView.instantiate(storyboard: .SERVICE)
            return GenericViewController(viewController: serviceView, key: key)
        case .assetType:
            let assetTypeView = AssetTypeListView.instantiate(storyboard: .ASSET_TYPE)
            return GenericViewController(viewController: assetTypeView, key: key)
        case .asset:
            let assetListView = AssetListView.instantiate(storyboard: .ASSET)
            return GenericViewController(viewController: assetListView, key: key)
        case .aboutProgram:
            let aboutView = AboutProgramView.instantiate(storyboard: .HELP)
            return GenericViewController(viewController: aboutView, key: key)
        case .holidays:
            let holidayListView = HolidayListView.instantiate(storyboard: .HOLIDAYS)
            return GenericViewController(viewController: holidayListView, key: key)
        case .jobHistory:
            let jobHistoryView = JobHistoryView.instantiate(storyboard: .JOB_HISTORY)
            return GenericViewController(viewController: jobHistoryView, key: key)
        case .jobConfirmation:
            let jobConfirmationView = JobConfirmationView.instantiate(storyboard: .JOB_CONFIRMATION)
            return GenericViewController(viewController: jobConfirmationView, key: key)
        case .jobDecline:
            let jobDeclineView = JobDeclineView.instantiate(storyboard: .JOB_DECLINE)
            return GenericViewController(viewController: jobDeclineView, key: key)
        case .quotesAndEstimates:
            let quotesEstimatesView = QuotesEstimatesView.instantiate(storyboard: .QUOTES_ESTIMATES)
            return GenericViewController(viewController: quotesEstimatesView, key: key)
        case .invoice:
            let invoiceListView = InvoiceListView.instantiate(storyboard: .INVOICE)
            return GenericViewController(viewController: invoiceListView, key: key)
        case .payment:
            let paymentListView = PaymentListView.instantiate(storyboard: .PAYMENT)
            return GenericViewController(viewController: paymentListView, key: key)
        case .jobDetail:
            let jobDetailListView = JobDetailListView.instantiate(storyboard: .JOB_DETAIL)
            return GenericViewController(viewController: jobDetailListView, key: key)
        case .receipt:
            let receiptListView = ReceiptListView.instantiate(storyboard: .RECEIPT)
            return GenericViewController(viewController: receiptListView, key: key)
        case .timeoffapproval:
            let timeOffView = TimeOffListView.instantiate(storyboard: .APPROVAL_LIST)
            return GenericViewController(viewController: timeOffView,key: key)
        case .AddTimeOffApproval:
            let AddTimeOff = AddTimeOffApprovalView.instantiate(storyboard: .APPROVAL_LIST)
            return GenericViewController(viewController: AddTimeOff, key: key)
        }
    }
}
