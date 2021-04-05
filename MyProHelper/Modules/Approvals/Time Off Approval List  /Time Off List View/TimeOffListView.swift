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
    
    override func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].rawValue.localize
    }
    
    override func showItem(at indexPath: IndexPath) {
        let createWorker = CreateWorkerView.instantiate(storyboard: .ADD_TIMEOFF)
        let worker = viewModel.getItem(at: indexPath.section)
       // createWorker.isShowingWorker = true
//        createWorker.createWorkerViewModel.worker.bind { [weak self] (worker) in
//            guard let self = self else { return }
//            createWorker.createWorkerViewModel.setWorker(worker: worker)
        //createWorker.createWorkerViewModel.setWorker(worker: worker)
        createWorker.setViewMode(isEditingEnabled: false)
       // navigationController?.pushViewController(createWorker, animated: true)
        self.present(createWorker, animated: true, completion: nil)
        
   // }
    }


    override func editItem(at indexPath: IndexPath) {
        let createWorker = CreateWorkerView.instantiate(storyboard: .ADD_TIMEOFF)
        let worker = viewModel.getItem(at: indexPath.section)
       // createWorker.createWorkerViewModel.setWorker(worker: worker)
        createWorker.createWorkerViewModel.worker.bind { [weak self] (worker) in
            guard let self = self else { return }
            createWorker.createWorkerViewModel.setWorker(worker: worker)

        createWorker.setViewMode(isEditingEnabled: true)
      //  navigationController?.pushViewController(createWorker, animated: true)
        self.present(createWorker, animated: true, completion: nil)
    }
    }
}
