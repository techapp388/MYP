//
//  VendorListView.swift
//  MyProHelper
//
//

import UIKit
import SwiftDataTables

enum VendorField: String {
    case VENDOR_NAME            = "VENDOR_NAME"
    case PHONE                  = "PHONE"
    case EMAIL                  = "EMAIL"
    case CONTACT_NAME           = "CONTACT_NAME"
    case ACCOUNT_NUMBER         = "ACCOUNT_NUMBER"
    case RECENT_CONTACT         = "RECENT_CONTACT"
    case ATTACHMENTS            = "ATTACHMENTS"
}

class VendorListView: BaseDataTableView<Vendor, VendorField>,Storyboarded {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = VendorListViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.addShowRemovedButton()
    }
    
    @objc override func handleAddItem() {
        let createVendorView = CreateVendorView.instantiate(storyboard: .VENDORS)
        createVendorView.viewModel = CreateVendorViewModel(attachmentSource: .VENDOR)
        createVendorView.setViewMode(isEditingEnabled: true)
        navigationController?.pushViewController(createVendorView, animated: true)
    }
    
    override func setDataTableFields() {
        dataTableFields = [
            .VENDOR_NAME,
            .PHONE,
            .EMAIL,
            .CONTACT_NAME,
            .ACCOUNT_NUMBER,
            .RECENT_CONTACT,
            .ATTACHMENTS
        ]
    }
    
    override func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].rawValue.localize
    }
    
    override func showItem(at indexPath: IndexPath) {
        let createVendorView = CreateVendorView.instantiate(storyboard: .VENDORS)
        let vendor = viewModel.getItem(at: indexPath.section)
        createVendorView.viewModel = CreateVendorViewModel(attachmentSource: .VENDOR)
        createVendorView.setViewMode(isEditingEnabled: false)
        createVendorView.viewModel.setVendor(vendor: vendor)
        navigationController?.pushViewController(createVendorView, animated: true)
    }
    
    override func editItem(at indexPath: IndexPath) {
        let createVendorView = CreateVendorView.instantiate(storyboard: .VENDORS)
        let vendor = viewModel.getItem(at: indexPath.section)
        createVendorView.viewModel = CreateVendorViewModel(attachmentSource: .VENDOR)
        createVendorView.setViewMode(isEditingEnabled: true)
        createVendorView.viewModel.setVendor(vendor: vendor)
        navigationController?.pushViewController(createVendorView, animated: true)
    }
}
