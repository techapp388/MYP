//
//  InvoiceListView.swift
//  MyProHelper
//
//

import Foundation
import SwiftDataTables


enum InvoiceField: String {
    case CUSTOMER_NAME          = "CUSTOMER_NAME"
    case DESCRIPTION            = "DESCRIPTION"
    case TOTAL_AMOUNT           = "TOTAL_AMOUNT"
    case PRICE_QUOTED           = "PRICE_QUOTED"
    case ADJUSTMENT_AMOUNT      = "ADJUSTMENT_AMOUNT"
    case PRICE_ESTIMATE         = "PRICE_ESTIMATE"
    case STATUS                 = "STATUS"
    case FIXED_PRICE            = "FIXED_PRICE"
    case ATTACHMENTS            = "ATTACHMENTS"
    case QUOTE_EXPIRATION       = "QUOTE_EXPIRATION"
    case COMPLETED_DATE         = "COMPLETED_DATE"
}

class InvoiceListView:  BaseDataTableView<Invoice, InvoiceField>, Storyboarded  {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = InvoiceListViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.addShowRemovedButton()
    }
    
    override func setDataTableFields() {
        dataTableFields = [
            .CUSTOMER_NAME,
            .DESCRIPTION,
            .TOTAL_AMOUNT,
            .PRICE_QUOTED,
            .ADJUSTMENT_AMOUNT,
            .PRICE_ESTIMATE,
            .STATUS,
            .FIXED_PRICE,
            .ATTACHMENTS,
            .QUOTE_EXPIRATION,
            .COMPLETED_DATE
        ]
    }
    
    override func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].rawValue.localize
    }
    
    @objc override func handleAddItem() {
        let createInvoiceView = CreateInvoiceView.instantiate(storyboard: .INVOICE)
        createInvoiceView.viewModel = CreateInvoiceViewModel(attachmentSource: .INVOICE)
        createInvoiceView.setViewMode(isEditingEnabled: true)
        navigationController?.pushViewController(createInvoiceView, animated: true)
    }
    
    
    override func showItem(at indexPath: IndexPath) {
        let createInvoiceView = CreateInvoiceView.instantiate(storyboard: .INVOICE)
        let invoice = viewModel.getItem(at: indexPath.section)
        createInvoiceView.viewModel = CreateInvoiceViewModel(attachmentSource: .INVOICE)
        createInvoiceView.setViewMode(isEditingEnabled: false)
        createInvoiceView.viewModel.setInvoice(invoice: invoice)
        navigationController?.pushViewController(createInvoiceView, animated: true)
    }

    override func editItem(at indexPath: IndexPath) {
        let createInvoiceView = CreateInvoiceView.instantiate(storyboard: .INVOICE)
        let invoice = viewModel.getItem(at: indexPath.section)
        createInvoiceView.viewModel = CreateInvoiceViewModel(attachmentSource: .INVOICE)
        createInvoiceView.setViewMode(isEditingEnabled: true)
        createInvoiceView.viewModel.setInvoice(invoice: invoice)
        navigationController?.pushViewController(createInvoiceView, animated: true)
    }
}
