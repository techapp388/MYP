//
//  CreatePaymentViewModel.swift
//  MyProHelper
//
//

import Foundation

class CreatePaymentViewModel: BaseAttachmentViewModel {

    private var isUpdatingPayment: Bool = false
    private var customers   : [Customer]    = []
    private var invoices    : [Invoice]     = []

    private let paymentService = PaymentService()
    private let paymentTypes: [PaymentType] = [.cash,
                                               .creditCard,
                                               .debitCard,
                                               .netbanking]
    let payment = Box(Payment())
    var receipt = Receipt()

    func setPayment(payment: Payment) {
        self.payment.value = payment
        self.sourceId = payment.paymentId
        isUpdatingPayment = true
    }
    
    func setReceipt() {
        receipt.customerId            = payment.value.customer?.customerID
        receipt.paymentId             = payment.value.paymentId
        receipt.invoiceId             = payment.value.invoice?.invoiceID
        receipt.amount                = payment.value.amountPaid
        receipt.paymentNote           = payment.value.noteAboutPayment
        receipt.numberOfAttachment    = payment.value.numberOfAttachment
        switch payment.value.status {
        case .paidInFull:
            receipt.paidInFull     = true
            receipt.partialPayment = false
        case .partialPayment:
            receipt.paidInFull     = false
            receipt.partialPayment = true
        default:
            break
        }
    }

    // MARK: - Getters
    func getCustomerName() -> String? {
        return payment.value.customer?.customerName
    }

    func getInvoice() -> String? {
        return payment.value.invoice?.job?.jobShortDescription
    }

    func getDescription() -> String? {
        return payment.value.description
    }

    func getTotalAmount() -> String? {
        return String(payment.value.totalInvoiceAmount ?? 0)
    }

    func getAmountPaid() -> String? {
        return String(payment.value.amountPaid ?? 0)
    }

    func getPaymentType() -> String? {
        return payment.value.paymentType?.rawValue
    }

    func getTransactionId() -> String? {
        return payment.value.transactionId
    }

    func getPaymentNote() -> String? {
        return payment.value.noteAboutPayment
    }

    func getCustomers() -> [String] {
        return customers.compactMap({ $0.customerName })
    }

    func getInvoices() -> [String] {
        return invoices.compactMap({ $0.job?.jobShortDescription })
    }

    func getPaymentTypes() -> [String] {
        return paymentTypes.compactMap({ $0.rawValue })
    }

    // MARK: - Setters
    func setCustomer(at index: Int) {
        let customer = customers[index]
        payment.value.customer = customer
    }

    func setCustomer(with customer: Customer) {
        payment.value.customer = customer
    }

    func setInvoice(at index: Int) {
        let invoice = invoices[index]
        payment.value.invoice = invoice
        payment.value.totalInvoiceAmount = invoice.totalInvoiceAmount
    }

    func setInvoice(with invoice: Invoice) {
        payment.value.invoice = invoice
        payment.value.totalInvoiceAmount = invoice.totalInvoiceAmount
    }

    func setDescription(description: String?) {
        payment.value.description = description
    }

    func setTotalAmount(amount: String?) {
        guard let amountString = amount else { return }
        let amountValue = Float(amountString)
        payment.value.totalInvoiceAmount = amountValue
    }

    func setAmountPaid(amount: String?) {
        guard let amountString = amount else { return }
        let amountValue = Float(amountString)
        payment.value.amountPaid = amountValue
        if amountValue == payment.value.totalInvoiceAmount {
            payment.value.status = .paidInFull
        }
        else {
            payment.value.status = .partialPayment
        }
    }

    func setPaymentType(with index: Int) {
        payment.value.paymentType = paymentTypes[index]
    }

    func setTransactionId(id: String?) {
        payment.value.transactionId = id
    }

    func setPaymentNote(note: String?) {
        payment.value.noteAboutPayment = note
    }

    //MARK: - Validation
    func validateCustomer() -> ValidationResult {
        let errorMessage = "CHOOSE_CUSTOMER_ERROR".localize
        if let customer = payment.value.customer, customer.customerID != nil {
            return .Valid
        }
        return .Invalid(message: errorMessage)
    }

    func validateInvoice() -> ValidationResult {
        let errorMessage = "CHOOSE_INVOICE_ERROR".localize
        if let invoice = payment.value.invoice, invoice.invoiceID != nil {
            return .Valid
        }
        return .Invalid(message: errorMessage)
    }

    func validateAmountPaid() -> ValidationResult {
        let errorMessage = "CHOOSE_AMOUNT_PAID_ERROR".localize
        guard let totalAmount = payment.value.totalInvoiceAmount else {
            return .Invalid(message: errorMessage)
        }
        if let amount = payment.value.amountPaid, amount > 0 && amount <= totalAmount {
            return .Valid
        }
        return .Invalid(message: errorMessage)
    }

    func validatePaymentType() -> ValidationResult {
        let errorMessage = "CHOOSE_PAYMENT_TYPE_ERROR".localize
        if payment.value.paymentType != nil {
            return .Valid
        }
        return .Invalid(message: errorMessage)
    }

    func fetchCustomers(completion: @escaping () -> Void) {
        let customerService = CustomersService()
        customerService.fetchCustomers(offset: 0) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let customers):
                self.customers = customers
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchInvoices(completion: @escaping () -> Void) {
        guard let customerId = payment.value.customer?.customerID else {
            invoices.removeAll()
            completion()
            return
        }
        let invoiceService = InvoiceService()

        invoiceService.fetchInvoices(offset: 0) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let invoices):
                self.invoices = invoices.filter({ $0.customerID == customerId})
                completion()
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func savePayment(completion: @escaping (_ error: String?, _ isValidData: Bool) -> ()) {
        if !isValidData() {
            completion(nil, false)
            return
        }
        if isUpdatingPayment {
            updatePayment { (error) in
                completion(error, true)
            }
        }
        else {
            createPayment { (error) in
                completion(error, true)
            }
        }
    }

    private func isValidData() -> Bool {
        return validateCustomer()   == .Valid &&
            validateInvoice()       == .Valid &&
            validateAmountPaid()    == .Valid &&
            validatePaymentType()   == .Valid
    }

    private func updatePayment(completion: @escaping (_ error: String?)->()) {
        paymentService.updatePayment(payment: payment.value) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(_):
                if let paymentId = self.payment.value.paymentId {
                    self.saveAttachment(id: paymentId)
                    self.setReceipt()
                    self.addNewReceipt()
                }
                completion(nil)

            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }

    private func createPayment(completion: @escaping (_ error: String?)->()) {
        paymentService.createPayment(payment: payment.value) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let paymentId):
                self.payment.value.paymentId = Int(paymentId)
                self.saveAttachment(id: Int(paymentId))
                self.setReceipt()
                self.addNewReceipt()
                completion(nil)
                
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    private func addNewReceipt() {
        createReceipt { (error) in }
    }
    
    private func createReceipt(completion: @escaping (_ error: String?)->()) {
        let receiptService = ReceiptService()
            
        receiptService.createReceipt(receipt: receipt) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let receiptId):
                self.receipt.receiptId = Int(receiptId)
                // How to save receipt attachemnt ?!
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
