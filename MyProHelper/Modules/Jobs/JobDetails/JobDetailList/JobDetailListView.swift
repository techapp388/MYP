//
//  JobDetailListView.swift
//  MyProHelper
//
//

import UIKit
import SwiftDataTables

enum JobDetailListField: String {
    case CUSTOMER_NAME        = "CUSTOMER_NAME"
    case SHORT_DESCRIPTION    = "SHORT_DESCRIPTION"
    case DETAILS              = "DETAILS"
    case CREATED_DATE         = "CREATED_DATE"
    case ATTACHMENTS          = "ATTACHMENTS"
}

class JobDetailListView: BaseDataTableView<JobDetail, JobDetailListField>, Storyboarded {

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = JobDetailListViewModel(delegate: self)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.addShowRemovedButton()
    }
    
    override func setDataTableFields() {
        dataTableFields = [
            .CUSTOMER_NAME,
            .SHORT_DESCRIPTION,
            .DETAILS,
            .CREATED_DATE,
            .ATTACHMENTS
        ]
    }
    
    override func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].rawValue.localize
    }
    
    override func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let viewAction  = UIAlertAction(title: "View".localize, style: .default) { [unowned self] (action) in
           // Add model to view here
        }
        alert.addAction(viewAction)
        if let cell = dataTable.collectionView.cellForItem(at: indexPath) {
            presentAlert(alert: alert, sourceView: cell.contentView)
        }
    }
}
