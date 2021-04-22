//
//  PurchaseOrderApprovals.swift
//  MyProHelper
//
//  Created by Sarvesh on 21/04/21.
//  Copyright © 2021 Benchmark Computing. All rights reserved.
//

import Foundation
import UIKit


enum PurchaseOrderApprovalField: String {
    
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




class PurchaseOrderApprovals: BaseDataTableView<Approval, PurchaseOrderApprovalField>, Storyboarded,ClassBDelegate,BDelegate, RDelegate {
    func rejectFunction() {
        viewModel.isShowingRemoved = true
         viewModel.reloadData()
    }
    
    func approveFunction() {
        viewModel.isShowingRemoved = true
         viewModel.reloadData()
    }
    
    
    
    func dummyFunction() {
       viewModel.isShowingRemoved = true
        viewModel.reloadData()
    }
    

    override func viewDidLoad() {
       // viewModel = PurchaseOrderModal(delegate: self)
      
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

   // private func showItem(at indexPath: IndexPath) {

    private func ApprovelAction(for index: Int, with action: ShowApprovelAction) {
        let createWorker = ApproveView.instantiate(storyboard: .APPROVEVIEW)
        let worker = viewModel.getItem(at:index)
       print("awsthi",worker)
        createWorker.workername = worker.workername!
        createWorker.startdate = worker.startdate!
        createWorker.enddate = worker.enddate!
        createWorker.leavetype = worker.typeofleave!
        createWorker.leavestatus = worker.status!
        createWorker.descriptiontext = worker.description!
        createWorker.remark = worker.remark!
        createWorker.workerID = worker.workerID!
        createWorker.codedelegate = self
        self.present(createWorker, animated: true, completion: nil)
        
        
    }
    private func RejectionAction(for index: Int, with action: ShowApprovelAction) {
        let createWorker = rejectView.instantiate(storyboard: .REJECTVIEW)
        let worker = viewModel.getItem(at:index)
        print("awsthi",worker)
        createWorker.workername = worker.workername!
        createWorker.startdate = worker.startdate!
        createWorker.enddate = worker.enddate!
        createWorker.leavetype = worker.typeofleave!
        createWorker.leavestatus = worker.status!
        createWorker.descriptiontext = worker.description!
        createWorker.remark = worker.remark!
        createWorker.workerID = worker.workerID!
        createWorker.rejectdelegate = self

        self.present(createWorker, animated: true, completion: nil)
        
        
    }
    override func setMoreAction(at indexPath: IndexPath) -> [UIAlertAction] {
        let addInventoryAction      = UIAlertAction(title: "Approve", style: .default) { [unowned self] (action) in
            self.ApprovelAction(for: indexPath.section, with: .APPROVE)
        }
        let removeInventoryAction   = UIAlertAction(title: "Reject", style: .default) { [unowned self] (action) in
            self.RejectionAction(for: indexPath.section, with: .REJECT)
        }
       
        return [addInventoryAction,removeInventoryAction]
    }
    override func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].rawValue.localize
    }
    
    override func showItem(at indexPath: IndexPath) {
        let createWorker = AddTimeShowView.instantiate(storyboard: .ADDTIMEOFF)
        let worker = viewModel.getItem(at: indexPath.section)
        createWorker.workername = worker.workername!
        createWorker.startdate = worker.startdate!
        createWorker.enddate = worker.enddate!
        createWorker.leavetype = worker.typeofleave!
        createWorker.leavestatus = worker.status!
        createWorker.descriptiontext = worker.description!
        createWorker.remark = worker.remark!
        
        self.present(createWorker, animated: true, completion: nil)
    }


    override func editItem(at indexPath: IndexPath) {
        let createWorker = AddTimeOffApprovalView.instantiate(storyboard: .ADD_TIMEOFF)
        let worker = viewModel.getItem(at: indexPath.section)
        print("hh",worker)
        createWorker.workername = worker.workername!
        createWorker.startdate = worker.startdate!
        createWorker.enddate = worker.enddate!
        createWorker.leavetype = worker.typeofleave!
        createWorker.leavestatus = worker.status!
        createWorker.descriptiontext = worker.description!
        createWorker.remark = worker.remark!
        self.present(createWorker, animated: true, completion: nil)
//            let createWorker = AddTimeOffApprovalView.instantiate(storyboard: .ADD_TIMEOFF)
//            createWorker.coddelegate = self
//
//            self.present(createWorker, animated: true, completion: nil)

    }
}
