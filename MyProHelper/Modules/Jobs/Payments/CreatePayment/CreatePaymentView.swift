//
//  CreatePaymentView.swift
//  MyProHelper
//
//

import UIKit

private enum PaymentField: String {
    case CUSTOMER_NAME          = "CUSTOMER_NAME"
    case INVOICE                = "INVOICE"
    case DESCRIPTION            = "DESCRIPTION"
    case TOTAL_INVOICE_AMOUNT   = "TOTAL_INVOICE_AMOUNT"
    case AMOUNT_PAID            = "AMOUNT_PAID"
    case PAYMENT_TYPE           = "PAYMENT_TYPE"
    case TRANSACTION_ID         = "TRANSACTION_ID"
    case PAYMENT_NOTE           = "PAYMENT_NOTE"
    case ATTACHMENTS            = "ATTACHMENTS"

    func getStringValue() -> String {
        return self.rawValue.localize
    }
}

class CreatePaymentView: BaseCreateWithAttachmentView<CreatePaymentViewModel>, Storyboarded {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCustomers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func getCell(at indexPath: IndexPath) -> BaseFormCell {
        guard let cellType = PaymentField(rawValue:  cellData[indexPath.row].key) else {
            return BaseFormCell()
        }

        switch cellType {
        case .CUSTOMER_NAME:
            return instantiateTextCell(at: indexPath.row)
        case .INVOICE:
            return instantiateTextCell(at: indexPath.row)
        case .DESCRIPTION:
            return instantiateTextViewCell(at: indexPath.row)
        case .TOTAL_INVOICE_AMOUNT:
            return instantiateTextCell(at: indexPath.row)
        case .AMOUNT_PAID:
            return instantiateTextCell(at: indexPath.row)
        case .PAYMENT_TYPE:
            return instantiateDataPickerCell(at: indexPath.row)
        case .TRANSACTION_ID:
            return instantiateTextCell(at: indexPath.row)
        case .PAYMENT_NOTE:
            return instantiateTextViewCell(at: indexPath.row)
        case .ATTACHMENTS:
            return instantiateAttachmentCell()
        }
    }

    private func instantiateTextCell(at index: Int) -> TextFieldCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextFieldCell.ID) as? TextFieldCell else {
            return TextFieldCell()
        }
        cell.bindTextField(data: cellData[index])
        cell.delegate       = self
        cell.listDelegate   = self
        return cell
    }

    private func instantiateDataPickerCell(at index: Int) -> DataPickerCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DataPickerCell.ID) as? DataPickerCell else {
            return DataPickerCell()
        }
        cell.bindCell(data: cellData[index])
        cell.delegate = self
        return cell
    }

    private func instantiateTextViewCell(at index: Int) -> TextViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TextViewCell.ID) as? TextViewCell else {
            return TextViewCell()
        }
        cell.delegate = self
        cell.bindTextView(data: cellData[index])
        return cell
    }

    override func handleAddItem() {
        super.handleAddItem()
        setupCellsData()
        viewModel.savePayment { (error, isValidData) in
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

    func fetchCustomers() {
        viewModel.fetchCustomers {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.setupCellsData()
                self.tableView.reloadData()
            }
        }
    }

    func fetchInvoices() {
        viewModel.fetchInvoices {
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.setupCellsData()
                self.tableView.reloadData()

            }
        }
    }

    private func setupCellsData() {
        cellData = [
            .init(title: PaymentField.CUSTOMER_NAME.getStringValue(),
                  key: PaymentField.CUSTOMER_NAME.rawValue,
                  dataType: .ListView,
                  isRequired: true,
                  isActive: isEditingEnabled,
                  keyboardType: .default,
                  validation: viewModel.validateCustomer(),
                  text: viewModel.getCustomerName(),
                  listData: viewModel.getCustomers()),

            .init(title: PaymentField.INVOICE.getStringValue(),
                  key: PaymentField.INVOICE.rawValue,
                  dataType: .ListView,
                  isRequired: true,
                  isActive: isEditingEnabled,
                  keyboardType: .default,
                  validation: viewModel.validateInvoice(),
                  text: viewModel.getInvoice(),
                  listData: viewModel.getInvoices()),

            .init(title: PaymentField.DESCRIPTION.getStringValue(),
                  key: PaymentField.DESCRIPTION.rawValue,
                  dataType: .Text,
                  isRequired: false,
                  isActive: isEditingEnabled,
                  keyboardType: .default,
                  validation: .Valid,
                  text: viewModel.getDescription()),

            .init(title: PaymentField.TOTAL_INVOICE_AMOUNT.getStringValue(),
                  key: PaymentField.TOTAL_INVOICE_AMOUNT.rawValue,
                  dataType: .Text,
                  isRequired: false,
                  isActive: false,
                  keyboardType: .default,
                  validation: .Valid,
                  text: viewModel.getTotalAmount()),

            .init(title: PaymentField.AMOUNT_PAID.getStringValue(),
                  key: PaymentField.AMOUNT_PAID.rawValue,
                  dataType: .Text,
                  isRequired: true,
                  isActive: isEditingEnabled,
                  keyboardType: .numbersAndPunctuation,
                  validation: viewModel.validateAmountPaid(),
                  text: viewModel.getAmountPaid()),

            .init(title: PaymentField.PAYMENT_TYPE.getStringValue(),
                  key: PaymentField.PAYMENT_TYPE.rawValue,
                  dataType: .Text,
                  isRequired: true,
                  isActive: isEditingEnabled,
                  keyboardType: .default,
                  validation: viewModel.validatePaymentType(),
                  text: viewModel.getPaymentType(),
                  listData: viewModel.getPaymentTypes()),

            .init(title: PaymentField.TRANSACTION_ID.getStringValue(),
                  key: PaymentField.TRANSACTION_ID.rawValue,
                  dataType: .Text,
                  isRequired: false,
                  isActive: isEditingEnabled,
                  keyboardType: .default,
                  validation: .Valid,
                  text: viewModel.getTransactionId()),

            .init(title: PaymentField.PAYMENT_NOTE.getStringValue(),
                  key: PaymentField.PAYMENT_NOTE.rawValue,
                  dataType: .Text,
                  isRequired: false,
                  isActive: isEditingEnabled,
                  keyboardType: .default,
                  validation: .Valid,
                  text: viewModel.getPaymentNote()),

            .init(title: PaymentField.ATTACHMENTS.getStringValue(),
                  key: PaymentField.ATTACHMENTS.rawValue,
                  dataType: .Text,
                  isRequired: false,
                  isActive: isEditingEnabled,
                  validation: .Valid)
        ]
    }
}

extension CreatePaymentView: TextFieldCellDelegate {
    func didUpdateTextField(text: String?, data: TextFieldCellData) {
        guard let cellType = PaymentField(rawValue: data.key) else {
            return
        }
        switch cellType {
        case .DESCRIPTION:
            viewModel.setDescription(description: text)
        case .AMOUNT_PAID:
            viewModel.setAmountPaid(amount: text)
        case .TRANSACTION_ID:
            viewModel.setTransactionId(id: text)
        case .PAYMENT_NOTE:
            viewModel.setPaymentNote(note: text)
        default:
            break
        }
    }
}

extension CreatePaymentView: TextFieldListDelegate {
    func willAddItem(data: TextFieldCellData) {
        guard let cellType = PaymentField(rawValue: data.key) else {
            return
        }
        switch cellType {
        case .CUSTOMER_NAME:
            createCustomer()
        case .INVOICE:
            createInvoice()
        default:
            break
        }
    }

    func didChooseItem(at row: Int?, data: TextFieldCellData) {
        guard let cellType = PaymentField(rawValue: data.key) else {
            return
        }
        guard let row = row else { return }

        switch cellType {
        case .CUSTOMER_NAME:
            viewModel.setCustomer(at: row)
            fetchInvoices()
        case .INVOICE:
            viewModel.setInvoice(at: row)
            setupCellsData()
            tableView.reloadData()
        default:
            break
        }
    }

    private func createCustomer() {
        let createCustomerView = CreateCustomerView.instantiate(storyboard: .CUSTOMERS)
        createCustomerView.setViewMode(isEditingEnabled: true)
        createCustomerView.viewModel.customer.bind { [weak self] customer in
            guard let self = self else { return }
            self.viewModel.setCustomer(with: customer)
            self.tableView.reloadData()
        }
    }

    private func createInvoice() {
        print("CREATE INVOICE")
    }
}

extension CreatePaymentView: PickerCellDelegate {
    func didPickItem(at index: Int, data: TextFieldCellData) {
        viewModel.setPaymentType(with: index)
    }
}
