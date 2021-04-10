//
//  TimeOffListView.swift
//  MyProHelper
//
//  Created by Macbook pro on 16/03/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import UIKit


enum TimeOffApprovalField: String {
    
    case WORKER_NAME             = "Worker Name"
    case DESCRIPTION             = "Description"
    case START_DATE              = "Start Date"
    case END_DATE                = "End Date"
    case TYPEOF_LEAVE            = "Type Of Leave"
    case STATUS                  = "Status"
    case REMARK                  = "Remarks"
    case REQUESTED_DATE          = "Requested Date"
    case APPROVER_NAME           = "Approved By"
    case APPROVED_DATE           = "Approved Date"
    
}




class TimeOffListView: BaseDataTableView<Approval, TimeOffApprovalField>, Storyboarded,ClassBDelegate {
    
    
    func dummyFunction() {
       viewModel.isShowingRemoved = true
        viewModel.reloadData()
    }
    

    override func viewDidLoad() {
        viewModel = TimeOffListViewModel(delegate: self)
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.addShowRemovedButton()
    }
    
    @objc override func handleAddItem() {
    let createWorker = AddTimeOffApprovalView.instantiate(storyboard: .ADD_TIMEOFF)
        createWorker.coddelegate = self
        self.present(createWorker, animated: true, completion: nil)
    }

    override func setDataTableFields() {
        dataTableFields = [
            .WORKER_NAME,
            .DESCRIPTION,
            .START_DATE,
            .END_DATE,
            .TYPEOF_LEAVE,
            .STATUS,
            .REMARK,
            .REQUESTED_DATE,
            .APPROVER_NAME,
            .APPROVED_DATE
            
        ]
    }
    private func showWaitingForPart(at index : Int) {
//        guard let viewModel = viewModel as? PartListViewModel else { return }
//        if !viewModel.hasWaitingJobs(at: index) {
//            let message = "NO_WAITING_FOR_MESSAGE".localize
//            GlobalFunction.showMessageAlert(fromView: self, title: "", message: message)
//        }
    }
    private func openInventoryAction(for index: Int, with action: InventoryAction) {
//        guard let stock = viewModel.getItem(at: index).stock else { return }
//        let partInventoryView = PartInventoryView.instantiate(storyboard: .PART)
//        partInventoryView.isEditingEnabled = true
//        partInventoryView.bindData(stock: stock, action: action)
//        navigationController?.pushViewController(partInventoryView, animated: true)
    }
    override func setMoreAction(at indexPath: IndexPath) -> [UIAlertAction] {
        let addInventoryAction      = UIAlertAction(title: "Approve", style: .default) { [unowned self] (action) in
            self.openInventoryAction(for: indexPath.section, with: .ADD_INVENTORY)
        }
        let removeInventoryAction   = UIAlertAction(title: "Reject", style: .default) { [unowned self] (action) in
            self.openInventoryAction(for: indexPath.section, with: .REMOVE_INVENTORY)
        }
//        let transferInventoryAction = UIAlertAction(title: "ACTION_TRANSFER_INVENTORY".localize, style: .default) { [unowned self] (action) in
//            self.openInventoryAction(for: indexPath.section, with: .TRANSFER_INVENTORY)
//        }
       
        return [addInventoryAction,removeInventoryAction]
    }
    override func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].rawValue.localize
    }
    
    override func showItem(at indexPath: IndexPath) {
        let createWorker = AddTimeShowView.instantiate(storyboard: .ADDTIMEOFF)
        let worker = viewModel.getItem(at: indexPath.section)
       // print("hh",worker)
        //let bbb = worker.workername
        createWorker.workername = worker.workername!
        createWorker.startdate = worker.startdate!
        createWorker.enddate = worker.enddate!
        createWorker.leavetype = worker.typeofleave!
        createWorker.leavestatus = worker.status!
        createWorker.descriptiontext = worker.description!
        createWorker.remark = worker.remark!
        
       // createWorker.leaveStatusTxtField.text = "hh"
       self.present(createWorker, animated: true, completion: nil)
        
        
//        let createWorker = CreateWorkerView.instantiate(storyboard: .ADD_TIMEOFF)
//        let worker = viewModel.getItem(at: indexPath.section)
        //createWorker.isShowingWorker = true
//        createWorker.createWorkerViewModel.worker.bind { [weak self] (worker) in
//            guard let self = self else { return }
//            createWorker.createWorkerViewModel.setWorker(worker: worker)
        //createWorker.createWorkerViewModel.setWorker(worker: worker)
//        createWorker.setViewMode(isEditingEnabled: false)
//       // navigationController?.pushViewController(createWorker, animated: true)
       // self.present(createWorker, animated: true, completion: nil)
        
   // }
    }


    override func editItem(at indexPath: IndexPath) {
        let createWorker = AddTimeOffApprovalView.instantiate(storyboard: .ADD_TIMEOFF)
        let worker = viewModel.getItem(at: indexPath.section)
        print("hh",worker)
        self.present(createWorker, animated: true, completion: nil)

    }
}
