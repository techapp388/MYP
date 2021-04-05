//
//  DevicesCell.swift
//  MyProHelper
//
//

import UIKit
import SwiftDataTables

enum DeviceFields: String {
    case WORKER_NAME        = "WORKER_NAME"
    case DEVICE_NAME        = "DEVICE_NAME"
    case DEVICE_TYPE        = "DEVICE_TYPE"
    case DEVICE_CODE        = "DEVICE_CODE"
    case IS_DEVICE_SETUP    = "IS_DEVICE_SETUP"
    case CODE_EXPIRE_AT     = "CODE_EXPIRE_AT"
    
    func stringValue() -> String {
        return self.rawValue.localize
    }
}

class DevicesCell: UICollectionViewCell, SwiftDataTableDelegate {

    static let ID = String(describing: DevicesCell.self)
    
    @IBOutlet weak private var dataTableContainerView: UIView!
    private var dataTable: SwiftDataTable!
    
    private let dataTableFields: [DeviceFields] = [.WORKER_NAME,
                                           .DEVICE_NAME,
                                           .DEVICE_TYPE,
                                           .DEVICE_CODE,
                                           .IS_DEVICE_SETUP,
                                           .CODE_EXPIRE_AT]
    private var searchKey: String?
    private var sortType: SortType?
    private var sortField: DeviceFields?
    var isShowingWorker: Bool = false
    var showViewDelegate: ShowViewDelegate?
    
    
    var viewModel: CreateWorkerViewModel? {
        didSet {
            fetchDevices()
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        initializeDataTable()
        setupDataTableLayout()
    }

    private func initializeDataTable() {
        dataTable = SwiftDataTable(dataSource: self)
        dataTable.dataSource = self
        dataTable.delegate = self
        dataTable.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    private func setupDataTableLayout() {
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        dataTableContainerView.backgroundColor = UIColor.white
        dataTableContainerView.addSubview(dataTable)
        
        NSLayoutConstraint.activate([
            dataTable.topAnchor.constraint(equalTo: dataTableContainerView.topAnchor),
            dataTable.leadingAnchor.constraint(equalTo: dataTableContainerView.leadingAnchor),
            dataTable.bottomAnchor.constraint(equalTo: dataTableContainerView.bottomAnchor),
            dataTable.trailingAnchor.constraint(equalTo: dataTableContainerView.trailingAnchor),
        ])
    }
    
    private func fetchDevices() {
        viewModel?.fetchDevices(searchKey: searchKey,sortBy: sortField, sortType: sortType, completion: {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.dataTable.reload()
            }
        })
    }
    
    private func fetchMoreDevices() {
        viewModel?.fetchMoreDevices(searchKey: searchKey,sortBy: sortField, sortType: sortType, completion: {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.dataTable.reload()
            }
        })
    }
    
    private func showDevice(at index: Int) {
        guard let viewModel = viewModel else { return }
        let createDeviceView = CreateDeviceView.instantiate(storyboard: .DEVICES)
        createDeviceView.isEditingEnabled = false
        createDeviceView.bindDevice(device: viewModel.getDevice(at: index))
        showViewDelegate?.pushView(view: createDeviceView)
    }
    
    private func editDevice(at index: Int) {
        guard let viewModel = viewModel else { return }
        let createDeviceView = CreateDeviceView.instantiate(storyboard: .DEVICES)
        createDeviceView.isEditingEnabled = true
        createDeviceView.bindDevice(device: viewModel.getDevice(at: index))
        showViewDelegate?.pushView(view: createDeviceView)
    }
    
    private func deleteDevice(at index: Int) {
        guard let viewModel = viewModel else { return }
        let deleteTitle = "DELETE_DEVICE_TITLE".localize
        let deleteMessage = "DELETE_DEVICE_MESSAGE".localize
        let deleteAlert = GlobalFunction.showDeleteAlert(title: deleteTitle, message: deleteMessage) {
            viewModel.deleteDeviceAt(at: index) { [weak self] in
                guard let self = self else { return }
                self.fetchDevices()
            }
        }
        
        if viewModel.isDeviceRemoved(at: index) {
            viewModel.restoreDeviceAt(at: index) { [weak self] in
                guard let self = self else { return }
                self.fetchDevices()
            }
        }
        else {
            showViewDelegate?.presentView(view: deleteAlert, completion: { })
        }
    }
    
    private func getHeader(for columnIndex: NSInteger) -> String {
        return dataTableFields[columnIndex].stringValue()
    }

    private func createData(at index: NSInteger) -> [DataTableValueType] {
        guard let viewModel = viewModel else { return [] }
        let device = ["⚙️"] + viewModel.getDevice(at: index).getDataArray()
        return device.compactMap(DataTableValueType.init)
    }
    
    //MARK: - Implement data table delegate methods
    func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        guard !isShowingWorker else { return }
        guard let viewModel = viewModel else { return }
        guard let showViewDelegate = showViewDelegate else { return }
        let removeTitle = (viewModel.isDeviceRemoved(at: indexPath.section)) ? "UNDELETE".localize : "DELETE".localize
        let actionSheet = GlobalFunction.showListActionSheet(deleteTitle: removeTitle) { [weak self] (showAction) in
            guard let self = self else { return }
            self.showDevice(at: indexPath.section)
        }
        editHandler: { [weak self] (editAction) in
            guard let self = self else { return }
            self.editDevice(at: indexPath.section)
        }
        deleteHandler: { [weak self] (deleteAction) in
            guard let self = self else { return }
            self.deleteDevice(at: indexPath.section)
        }
        if let cell = dataTable.collectionView.cellForItem(at: indexPath) {
            showViewDelegate.showAlert?(alert: actionSheet, sourceView: cell)
        }

    }
    
    func didSearchForKey(_ dataTable: SwiftDataTable, Key: String) {
        searchKey = Key
        fetchDevices()
    }
    
    func willShowLastElement(_ collectionView: UICollectionView, indexPath: IndexPath) {
        fetchMoreDevices()
    }
    
    func heightForSectionFooter(in dataTable: SwiftDataTable) -> CGFloat {
        return 0
    }
}

//MARK: - Swift data source methods
extension DevicesCell: SwiftDataTableDataSource {

    func numberOfColumns(in: SwiftDataTable) -> Int {
        return dataTableFields.count + 1
    }

    func numberOfRows(in: SwiftDataTable) -> Int {
        return viewModel?.countDevices() ?? 0
    }

    func dataTable(_ dataTable: SwiftDataTable, dataForRowAt index: NSInteger) -> [DataTableValueType] {
        return createData(at: index)
    }

    func dataTable(_ dataTable: SwiftDataTable, headerTitleForColumnAt columnIndex: NSInteger) -> String {
        if columnIndex == 0 {
            return "ACTION".localize
        }
        return getHeader(for: columnIndex - 1)
    }

    func didTapSort(_ dataTable: SwiftDataTable, type: DataTableSortType, column: Int) {
        sortType  = (type == DataTableSortType.ascending) ? .ASCENDING : .DESCENDING
        sortField = dataTableFields[column - 1]
        fetchDevices()
        
    }
}
