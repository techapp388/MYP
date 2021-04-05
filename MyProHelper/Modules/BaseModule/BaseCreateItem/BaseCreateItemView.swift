//
//  BaseCreateItemView.swift
//  MyProHelper
//
//

import UIKit

class BaseCreateItemView: BaseViewController {

    private var isAddingItem    : Bool = false
    var didPerfromAdd   : Bool = false
    
    let tableView = UITableView()
    var cellData: [TextFieldCellData] = []
    var isEditingEnabled = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableViewLayout()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationBar()
    }
    
   
    private func setupNavigationBar() {
        if isEditingEnabled {
            let rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(handleAddItem))
            self.navigationItem.rightBarButtonItem = rightBarButtonItem
        }
    }
    
    private func setupTableViewLayout() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func setupTableView() {
        let tapGesture      = UILongPressGestureRecognizer(target: self, action: #selector(handleEndEditing))
        let textFieldCell   = UINib(nibName: TextFieldCell.ID, bundle: nil)
        let attachmentCell  = UINib(nibName: AttachmentViewCell.ID, bundle: nil)
        let dataTableCell   = UINib(nibName: DataTableViewCell.ID, bundle: nil)
        let textViewCell    = UINib(nibName: TextViewCell.ID, bundle: nil)
        let headerCell      = UINib(nibName: AppTableViewHeaderCell.ID, bundle: nil)
        let buttonCell      = UINib(nibName: ButtonCell.ID, bundle: nil)
        let checkboxCell    = UINib(nibName: CheckboxHeaderCell.ID, bundle: nil)
        let radioButtonCell = UINib(nibName: RadioButtonCell.ID, bundle: nil)
        let dataPickerCell  = UINib(nibName: DataPickerCell.ID, bundle: nil)

        tableView.allowsSelection   = false
        tableView.separatorStyle    = .none
        tableView.dataSource        = self
        tableView.delegate          = self
        
        tableView.register(textFieldCell, forCellReuseIdentifier: TextFieldCell.ID)
        tableView.register(attachmentCell, forCellReuseIdentifier: AttachmentViewCell.ID)
        tableView.register(dataTableCell, forCellReuseIdentifier: DataTableViewCell.ID)
        tableView.register(textViewCell, forCellReuseIdentifier: TextViewCell.ID)
        tableView.register(headerCell, forCellReuseIdentifier: AppTableViewHeaderCell.ID)
        tableView.register(buttonCell, forCellReuseIdentifier: ButtonCell.ID)
        tableView.register(checkboxCell, forCellReuseIdentifier: CheckboxHeaderCell.ID)
        tableView.register(radioButtonCell, forCellReuseIdentifier: RadioButtonCell.ID)
        tableView.register(dataPickerCell, forCellReuseIdentifier: DataPickerCell.ID)

        tableView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleEndEditing() {
        tableView.endEditing(true)
    }
    
    @objc func handleAddItem() {
        tableView.endEditing(true)
        isAddingItem = true
        for index in 0..<cellData.count {
            if let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? BaseFormCell {
                cell.bindData()
            }
        }
        isAddingItem = false
        didPerfromAdd = true
    }
    
    func getCell(at indexPath: IndexPath) -> BaseFormCell {
        return BaseFormCell()
    }
    
    func setViewMode(isEditingEnabled: Bool) {
        self.isEditingEnabled = isEditingEnabled
    }
}

extension BaseCreateItemView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
}

extension BaseCreateItemView: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getCell(at: indexPath)
        cell.showValidation = didPerfromAdd
        cell.indexPath = indexPath
        cell.validateData()
        cell.showViewDelegate = self
        cell.formCellDelegate = self
        return cell
    }
}


extension BaseCreateItemView: ShowViewDelegate {
    func presentView(view: UIViewController, completion: @escaping () -> ()) {
        present(view, animated: true, completion: completion)
    }

    func pushView(view: UIViewController) {
        navigationController?.pushViewController(view, animated: true)
    }
}

extension BaseCreateItemView: FormCellDelegate {
    
    func didEndEditing(indexPath: IndexPath?) {
//        guard !isAddingItem, let indexPath = indexPath else { return }
//        if indexPath.row < cellData.count - 1, let nextCell = tableView.cellForRow(at: IndexPath(row: indexPath.row + 1, section: 0)) as? TextFieldCell {
//            nextCell.setFirstResponder()
//        }
    }
}
