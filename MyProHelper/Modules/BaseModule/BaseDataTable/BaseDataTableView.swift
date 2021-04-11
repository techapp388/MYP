//
//  BaseDataTableView.swift
//  MyProHelper
//
//

import UIKit
import SwiftDataTables


class BaseDataTableView<T:RepositoryBaseModel,F>: BaseViewController, SwiftDataTableDelegate {
    
    private var showRemovedButton: UIBarButtonItem?
    var dataTable: SwiftDataTable!
    var viewModel: BaseDataTableViewModel<T, F>!
    var dataTableFields: [F] = [ ]
    var hasGearIcon: Bool = true
    var heightConstraint: NSLayoutConstraint = NSLayoutConstraint()
    private let segmentedControlHeight: CGFloat = 50
    
    var segmentedControl: UISegmentedControl = {
         let control = UISegmentedControl(items: ["Quotes","Estimates"])
        control.selectedSegmentIndex = 0
        control.addTarget(self, action: #selector(handleSegmentedControlValueChanged(_:)), for: .valueChanged)
        return control
    }()

    
   @objc func handleSegmentedControlValueChanged(_ sender: UISegmentedControl) { }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpSegmentedControl()
        setDataTableFields()
        initializeDataTable()
        setupDataTableLayout()
        showHideSegmentedControl(isShown: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
        viewModel.reloadData()
    }
    
    func setUpSegmentedControl(){
        
        view.addSubview(segmentedControl)
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        heightConstraint = segmentedControl.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 8),
            segmentedControl.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            heightConstraint
       ])
    }
    
    func showHideSegmentedControl(isShown: Bool) {
        if isShown {
            segmentedControl.isHidden = false
            heightConstraint.constant = segmentedControlHeight
        }
        else {
            segmentedControl.isHidden = true
            heightConstraint.constant = 0
        }
        
    }
    
    private func setupNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddItem))
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem]
    }
    
    private func initializeDataTable() {
        dataTable = SwiftDataTable(dataSource: self)
        dataTable.dataSource = self
        dataTable.delegate = self
        dataTable.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    }
    
    private func setupDataTableLayout() {
        dataTable.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.addSubview(dataTable)
        NSLayoutConstraint.activate([
            dataTable.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 20),
            dataTable.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dataTable.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            dataTable.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        let deleteAlert = GlobalFunction.showDeleteAlert(title: title ?? "", message: Constants.Message.DELETE_ROW) { [weak self] in
            guard let self = self else { return }
            self.viewModel.deleteItem(at: indexPath.section)
           
        }
        present(deleteAlert, animated: true, completion: nil)
    }
    
    private func createData(at index: NSInteger) -> [DataTableValueType] {
        let gearIcon = (hasGearIcon) ? ["⚙️"] : []
        let userArray = viewModel.getItems().map { gearIcon + $0.getDataArray() }
        return userArray[index].compactMap(DataTableValueType.init)
    }
    
    private func setupShowButtonTitle() {
        if viewModel.isShowingRemoved {
            showRemovedButton?.title = "Hide removed"
        }
        else {
            showRemovedButton?.title = "Show removed"
        }
    }
    
    @objc private func handleShowRemovedData() {
        if viewModel.isShowingRemoved {
            viewModel.isShowingRemoved = false
        }
        else {
            viewModel.isShowingRemoved = true
        }
        setupShowButtonTitle()
        viewModel.reloadData()
    }
    
    final func addShowRemovedButton() {
        showRemovedButton = UIBarButtonItem(title: "SHOW_REMOVED".localize,
                                                        style: .plain, target: self,
                                                        action: #selector(handleShowRemovedData))
        setupShowButtonTitle()
        self.navigationItem.rightBarButtonItems?.append(showRemovedButton!)
    }
    
    final func hideShowRemovedButton() {
        let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddItem))
        self.navigationItem.rightBarButtonItems = [rightBarButtonItem]
    }

    final func removeLeftBarItems() {
        navigationItem.rightBarButtonItems = []
    }
    
    func getHeader(for columnIndex: NSInteger) -> String {
        return ""
    }
    
    func setDataTableFields() { }
    func showItem(at indexPath: IndexPath) { }
    func editItem(at indexPath: IndexPath) { }
    func setMoreAction(at indexPath: IndexPath) -> [UIAlertAction] {
        return []
    }
    
    @objc func handleAddItem() { }
    
    //MARK: - Implement data table delegate methods
    func didSelectItem(_ dataTable: SwiftDataTable, indexPath: IndexPath) {
        
        let moreAction = setMoreAction(at: indexPath)
        
        let removeTitle = (viewModel.isItemRemoved(at: indexPath.section)) ? "UNDELETE".localize : "DELETE".localize
        
        let actionSheet = GlobalFunction.showListActionSheet(deleteTitle: removeTitle ,customActions: moreAction) { [weak self] (showAction) in
            guard let self = self else { return }
            self.showItem(at: indexPath)
        }
        editHandler: { [weak self] (editAction) in
            guard let self = self else { return }
            self.editItem(at: indexPath)
        }
        deleteHandler: { [weak self] (deleteAction) in
            guard let self = self else { return }
            if self.viewModel.isItemRemoved(at: indexPath.section) {
                self.viewModel.undeleteItem(at: indexPath.section)
            }
            else {
                self.deleteItem(at: indexPath)
            }
        }
        if let cell = dataTable.collectionView.cellForItem(at: indexPath) {
            presentAlert(alert: actionSheet, sourceView: cell.contentView)
        }
    }
    
    func didSearchForKey(_ dataTable: SwiftDataTable, Key: String) {
        viewModel.setSearchKey(key: Key)
    }
    
    func willShowLastElement(_ collectionView: UICollectionView, indexPath: IndexPath) {
        viewModel.fetchMoreData()
    }
    
    func heightForSectionFooter(in dataTable: SwiftDataTable) -> CGFloat {
        return 0
    }
}

//MARK: - Swift data source methods
extension BaseDataTableView: SwiftDataTableDataSource {

    func numberOfColumns(in: SwiftDataTable) -> Int {
        if hasGearIcon {
            return dataTableFields.count + 1
        }
        return dataTableFields.count
    }

    func numberOfRows(in: SwiftDataTable) -> Int {
        return viewModel.countData()
    }

    func dataTable(_ dataTable: SwiftDataTable, dataForRowAt index: NSInteger) -> [DataTableValueType] {
        return createData(at: index)
    }

    func dataTable(_ dataTable: SwiftDataTable, headerTitleForColumnAt columnIndex: NSInteger) -> String {
        if hasGearIcon {
            return (columnIndex == 0) ? "ACTION".localize : getHeader(for: columnIndex - 1)
        }
        return getHeader(for: columnIndex)
    }

    func didTapSort(_ dataTable: SwiftDataTable, type: DataTableSortType, column: Int) {
        let sortType: SortType = (type == DataTableSortType.ascending) ? .ASCENDING : .DESCENDING
        let sortField = dataTableFields[column - 1]
        viewModel.setSortType(sortType: sortType, sortBy: sortField)
    }
}

extension BaseDataTableView: RefreshDelegate {
    
    func reloadView() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.dataTable.reload()
        }
    }
    
    func showError(message: String) {
        DispatchQueue.main.async {
            GlobalFunction.showMessageAlert(fromView: self, title: self.title ?? "",
                                            message: message)
        }
    }
}
