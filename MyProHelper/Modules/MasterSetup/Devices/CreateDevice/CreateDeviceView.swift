//
//  CreateDeviceView.swift
//  MyProHelper
//
//

import UIKit

private enum CreateDeviceFields: String {
    case DEVICE_NAME    = "DEVICE_NAME"
    case DEVICE_TYPE    = "DEVICE_TYPE"
    case WORKER_NAME    = "WORKER_NAME"
    
    func getString() -> String {
        return self.rawValue.localize
    }
}

class CreateDeviceView: BaseCreateItemView, Storyboarded {
    private var canEditWorker = false
    let viewModel = CreateDeviceViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCellsData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchWorkers()
    }
    
    override func getCell(at indexPath: IndexPath) -> BaseFormCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.ID) as? TextFieldCell else {
             return BaseFormCell()
         }
         cell.bindTextField(data: cellData[indexPath.row])
         cell.delegate = self
         return cell
    }
    
    override func handleAddItem() {
        super.handleAddItem()
        setupCellsData()
        viewModel.saveDevice { (error, isValidData) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                let title = self.title ?? ""
                if let error = error {
                    GlobalFunction.showMessageAlert(fromView: self, title: title, message: error)
                }
                else if isValidData {
                    self.navigationController?.popViewController(animated: true)
                }
                else {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    private func setupCellsData() {
        cellData = [
            .init(title: CreateDeviceFields.DEVICE_NAME.getString(),
                  key: CreateDeviceFields.DEVICE_NAME.rawValue,
                  dataType: .Text,
                  isRequired: true,
                  isActive: isEditingEnabled,
                  validation: viewModel.validateDeviceName(),
                  text: viewModel.getDeviceName()),
            
            .init(title: CreateDeviceFields.DEVICE_TYPE.getString(),
                  key: CreateDeviceFields.DEVICE_TYPE.rawValue,
                  dataType: .Text,
                  isRequired: true,
                  isActive: isEditingEnabled,
                  validation: viewModel.validateDeviceType(),
                  text: viewModel.getDeviceType()),
            
            .init(title: CreateDeviceFields.WORKER_NAME.getString(),
                  key: CreateDeviceFields.WORKER_NAME.rawValue,
                  dataType: .ListView,
                  isRequired: true,
                  isActive: isEditingEnabled && canEditWorker,
                  validation: viewModel.validateWorker(),
                  text: viewModel.getWorkerName(),
                  listData: viewModel.getWorkers())
            
        ]
    }
    
    func fetchWorkers() {
        viewModel.fetchWorkers { [weak self] in
            guard let self = self else { return }
            self.setupCellsData()
            self.tableView.reloadData()
        }
    }
    
    func bindDevice(device: Device?, worker: Worker? = nil, canEditWorker: Bool = false) {
        if let device = device {
            viewModel.setDevice(device: device)
        }
        if let worker = worker {
            viewModel.setWorker(worker: worker)
        }
        self.canEditWorker = canEditWorker
    }
}

extension CreateDeviceView: TextFieldCellDelegate {
    func didUpdateTextField(text: String?, data: TextFieldCellData) {
        guard let field = CreateDeviceFields(rawValue: data.key) else {
            return
        }
        
        switch field {
        
        case .DEVICE_NAME:
            viewModel.setDeviceName(name: text)
        case .DEVICE_TYPE:
            viewModel.setDeviceType(type: text)
        default:
            break
        }
    }
    
    func present(view: UIViewController) {
        present(view, animated: true, completion: nil)
    }
}

extension CreateDeviceView: TextFieldListDelegate {
    func willAddItem(data: TextFieldCellData) {
        
    }
    
    func didChooseItem(at row: Int?, data: TextFieldCellData) {
        guard let field = CreateDeviceFields(rawValue: data.key) else {
            return
        }
        guard let index = row else { return }
        switch field {
        
        case .WORKER_NAME:
            viewModel.setWorker(at: index)
        default:
            break
        }
    }
    
    
}
