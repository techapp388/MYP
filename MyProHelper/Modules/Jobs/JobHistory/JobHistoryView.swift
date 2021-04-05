//
//  JobHistoryView.swift
//  MyProHelper
//
//

import UIKit
import SwiftDataTables

enum JobHistoryField: String {
    case CUSTOMER_NAME          = "CUSTOMER_NAME"
    case WORKER_NAME            = "WORKER_NAME"
    case SCHEDULED_DATE_TIME    = "SCHEDULED_DATE_TIME"
    case ADDRESS                = "ADDRESS"
    case CONTACT_PHONE          = "CONTACT_PHONE"
    case JOB_TITLE              = "JOB_TITLE"
    case DESCRIPTION            = "DESCRIPTION"
    case STATUS                 = "STATUS"
    case ATTACHMENTS            = "ATTACHMENTS"
}

class JobHistoryView: BaseDataTableView<JobHistory, JobHistoryField>, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = JobHistoryViewModel(delegate: self)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func setDataTableFields() {
        dataTableFields = [
            .CUSTOMER_NAME,
            .WORKER_NAME,
            .SCHEDULED_DATE_TIME,
            .ADDRESS,
            .CONTACT_PHONE,
            .JOB_TITLE,
            .DESCRIPTION,
            .STATUS,
            .ATTACHMENTS
        ]
    }
    
    override func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].rawValue.localize
    }
    
    override func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
    
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let viewAction  = UIAlertAction(title: "View".localize, style: .default) { [unowned self] (action) in
            self.displayJobs(at: indexPath)
        }
        alert.addAction(viewAction)
        if let cell = dataTable.collectionView.cellForItem(at: indexPath) {
            presentAlert(alert: alert, sourceView: cell.contentView)
        }
    }
    
     func displayJobs(at indexPath: IndexPath) {
        
        let customerJobHistoryView = CustomerJobHistoryView.instantiate(storyboard: .CUSTOMER_JOB_HISTORY)
        let job = viewModel.getItem(at: indexPath.section)

        customerJobHistoryView.viewModel = CustomerJobHistoryViewModel(delegate: customerJobHistoryView)
        guard let viewModel = customerJobHistoryView.viewModel as? CustomerJobHistoryViewModel else {
            print("RETURNED")
            return
        }
        
        viewModel.setCustomerJobHistory(jobHistory: job)
        navigationController?.pushViewController(customerJobHistoryView, animated: true)
    }
}
