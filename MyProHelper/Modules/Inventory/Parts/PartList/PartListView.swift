//
//  PartListView.swift
//  MyProHelper
//
//

import UIKit

enum PartField: String {
    case PART_NAME              = "PART_NAME"
    case DESCRIPTION            = "DESCRIPTION"
    case PURCHASED_FROM         = "PURCHASED_FROM"
    case PART_LOCATION          = "PART_LOCATION"
    case QUANTITY               = "QUANTITY"
    case PRICE_PAID             = "PRICE_PAID"
    case PRICE_TO_RESELL        = "PRICE_TO_RESELL"
    case WAITING_COUNT          = "WAITING_COUNT"
    case PURCHASED_DATE         = "PURCHASED_DATE"
    case ATTACHMENTS            = "ATTACHMENTS"
}

class PartListView: BaseDataTableView<Part, PartField>, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = PartListViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.addShowRemovedButton()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        super.hideShowRemovedButton()
    }
    
    private func openInventoryAction(for index: Int, with action: InventoryAction) {
        guard let stock = viewModel.getItem(at: index).stock else { return }
        let partInventoryView = PartInventoryView.instantiate(storyboard: .PART)
        partInventoryView.isEditingEnabled = true
        partInventoryView.bindData(stock: stock, action: action)
        navigationController?.pushViewController(partInventoryView, animated: true)
    }
    
    private func showWaitingForPart(at index : Int) {
        guard let viewModel = viewModel as? PartListViewModel else { return }
        if !viewModel.hasWaitingJobs(at: index) {
            let message = "NO_WAITING_FOR_MESSAGE".localize
            GlobalFunction.showMessageAlert(fromView: self, title: "", message: message)
        }
    }
    
    @objc override func handleAddItem() {
        let createPartView = CreatePartView.instantiate(storyboard: .PART)
        createPartView.viewModel = CreatePartViewModel(attachmentSource: .PART)
        createPartView.setViewMode(isEditingEnabled: true)
        navigationController?.pushViewController(createPartView, animated: true)
    }
    
    override func setDataTableFields() {
        dataTableFields = [
            .PART_NAME,
            .DESCRIPTION,
            .PURCHASED_FROM,
            .PART_LOCATION,
            .QUANTITY,
            .PRICE_PAID,
            .PRICE_TO_RESELL,
            .WAITING_COUNT,
            .PURCHASED_DATE,
            .ATTACHMENTS
        ]
    }
    
    override func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].rawValue.localize
    }
    
    override func showItem(at indexPath: IndexPath) {
        let createPartView = CreatePartView.instantiate(storyboard: .PART)
        let part = viewModel.getItem(at: indexPath.section)
        createPartView.viewModel = CreatePartViewModel(attachmentSource: .PART)
        createPartView.setViewMode(isEditingEnabled: false)
        createPartView.viewModel.setPart(part: part)
        navigationController?.pushViewController(createPartView, animated: true)
    }
    
    override func editItem(at indexPath: IndexPath) {
        let createPartView = CreatePartView.instantiate(storyboard: .PART)
        let part = viewModel.getItem(at: indexPath.section)
        createPartView.viewModel = CreatePartViewModel(attachmentSource: .PART)
        createPartView.setViewMode(isEditingEnabled: true)
        createPartView.viewModel.setPart(part: part)
        navigationController?.pushViewController(createPartView, animated: true)
    }
    
    override func setMoreAction(at indexPath: IndexPath) -> [UIAlertAction] {
        let addInventoryAction      = UIAlertAction(title: "ACTION_ADD_STOCK".localize, style: .default) { [unowned self] (action) in
            self.openInventoryAction(for: indexPath.section, with: .ADD_INVENTORY)
        }
        let removeInventoryAction   = UIAlertAction(title: "ACTION_REMOVE_INVENTORY".localize, style: .default) { [unowned self] (action) in
            self.openInventoryAction(for: indexPath.section, with: .REMOVE_INVENTORY)
        }
        let transferInventoryAction = UIAlertAction(title: "ACTION_TRANSFER_INVENTORY".localize, style: .default) { [unowned self] (action) in
            self.openInventoryAction(for: indexPath.section, with: .TRANSFER_INVENTORY)
        }
        let invoiceWaitingAction    = UIAlertAction(title: "ACTION_SHOW_INVOICES_WATING".localize, style: .default) { [unowned self] (action) in
            self.showWaitingForPart(at: indexPath.section)
        }
        return [addInventoryAction, removeInventoryAction, transferInventoryAction,invoiceWaitingAction]
    }
}
