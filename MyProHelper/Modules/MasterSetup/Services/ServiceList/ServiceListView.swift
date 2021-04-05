//
//  ServiceListView.swift
//  MyProHelper
//
//

import UIKit

enum ServiceField: String {
    case DESCRIPTION            = "DESCRIPTION"
    case PRICE_QUOTE            = "PRICE_QUOTE"
    case CREATED_DATE           = "CREATED_DATE"
}

class ServiceListView: BaseDataTableView<ServiceType, ServiceField>, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = ServiceListViewModel(delegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        super.addShowRemovedButton()
    }
    
    @objc override func handleAddItem() {
        let createService = CreateServiceView.instantiate(storyboard: .SERVICE)
        createService.setViewMode(isEditingEnabled: true)
        navigationController?.pushViewController(createService, animated: true)
    }
    
    override func setDataTableFields() {
        dataTableFields = [
            .DESCRIPTION,
            .PRICE_QUOTE,
            .CREATED_DATE
        ]
    }
    
    override func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].rawValue.localize
    }
    
    override func showItem(at indexPath: IndexPath) {
        let createService = CreateServiceView.instantiate(storyboard: .SERVICE)
        let service = viewModel.getItem(at: indexPath.section)
        createService.setViewMode(isEditingEnabled: false)
        createService.viewModel.setService(serviceType: service)
        navigationController?.pushViewController(createService, animated: true)
    }
    
    override func editItem(at indexPath: IndexPath) {
        let createService = CreateServiceView.instantiate(storyboard: .SERVICE)
        let service = viewModel.getItem(at: indexPath.section)
        createService.setViewMode(isEditingEnabled: true)
        createService.viewModel.setService(serviceType: service)
        navigationController?.pushViewController(createService, animated: true)
    }
}
