//
//  PartInventoryViewModel.swift
//  MyProHelper
//
//

import Foundation

class PartInventoryViewModel {
    
    private var partLocations: [PartLocation] = []
    private var vendors: [Vendor] = []
    private var originalStock: PartFinder?
    private var stock: PartFinder?
    private var actionType: InventoryAction?
    private var quantity: Int = 0
    
    func setStock(stock: PartFinder, for action: InventoryAction) {
        self.originalStock  = stock
        self.stock          = stock
        self.actionType     = action
    }
    
    func getActionType() -> InventoryAction? {
        return actionType
    }
    
    func getLocationName() -> String? {
        return stock?.partLocation?.locationName
    }
    
    func getFromLocationName() -> String? {
        return originalStock?.partLocation?.locationName
    }
    
    func getPartLocations() -> [String] {
        return partLocations.compactMap({ $0.locationName })
    }
    
    func getVendors() -> [String] {
        return vendors.compactMap({ $0.vendorName })
    }
    
    func getVendorName() -> String? {
        return stock?.wherePurchased?.vendorName
    }
    
    func setPartLocation(at index: Int) {
        stock?.partLocation = partLocations[index]
    }
    
    func setPartLocation(partLocation: PartLocation) {
        stock?.partLocation = partLocation
    }
    
    func setVendor(at index: Int) {
        stock?.wherePurchased = vendors[index]
    }
    
    func setVendor(vendor: Vendor) {
        stock?.wherePurchased = vendor
    }
    
    func setQuanityt(value: String?) {
        guard let stringValue = value, let quantity = Int(stringValue) else { return }
        if quantity >= 0 {
            self.quantity = quantity
        }
        else {
            self.quantity = 0
        }
    }
    
    func setPricePaid(price: String?) {
        guard let price = price else {
            return
        }
        stock?.pricePaid = Double(price)
    }
    
    func setPriceToResell(price: String?) {
        guard let price = price else {
            return
        }
        stock?.priceToResell = Double(price)
    }
    
    func setLastPurchased(date: String?) {
        guard let date = date else {
            return
        }
        stock?.lastPurchased = DateManager.stringToDate(string: date)
    }
    
    func canEditVendor() -> Bool {
        return stock?.wherePurchased?.vendorID == nil
    }
    
    func getQuantity() -> Int {
        return quantity
    }
    
    func getQuantityString() -> String {
        return String(quantity)
    }
    
    func getPricePaid() -> String {
        guard let pricePaid = stock?.pricePaid else {
            return ""
        }
        return pricePaid.stringValue
    }
    
    func getPriceToResell() -> String {
        guard let priceToResell = stock?.priceToResell else {
            return ""
        }
        return priceToResell.stringValue
    }
    
    func getLastPurchasedDate() -> String {
        guard let date = stock?.lastPurchased else {
            return ""
        }
        return DateManager.getStandardDateString(date: date)
    }
    
    func getPartLocation() -> PartLocation? {
        return stock?.partLocation
    }
    
    func getVendor() -> Vendor? {
        return stock?.wherePurchased
    }
    
    func getPartLocations(completion: @escaping () -> ()) {
        let partLocationService = PartLocationService()
        partLocationService.fetchPartLocations(offset: 0) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let partLocations):
                self.partLocations = partLocations
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getVendors(completion: @escaping () -> ()) {
        let vendorService = VendorService()
        vendorService.fetchVendors(offset: 0) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let vendors):
                self.vendors = vendors
                completion()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func validateQuantity() -> ValidationResult {
        guard let quantity = stock?.quantity else {
            return .Valid
        }
        return Validator.validateIntegerValue(value: quantity)
    }
    
    func validatePricePaid() -> ValidationResult {
        guard let pricePaid = stock?.pricePaid else {
            return .Valid
        }
        return Validator.validatePrice(price: pricePaid)
    }
    
    func validatePriceToResell() -> ValidationResult {
        guard let priceToResell = stock?.priceToResell else {
            return .Valid
        }
        return Validator.validatePrice(price: priceToResell)
    }
    
    
    func isValidData() -> Bool {
        return
            validateQuantity()      == .Valid &&
            validatePricePaid()     == .Valid &&
            validatePriceToResell() == .Valid
    }
    func addStockQuantity(completion: @escaping (_ error: String?)->()) {
        guard var stock = stock else { return }
        guard isValidData() else {
            return
        }
        let service = PartFinderService()
        stock.increaseQuantity(by: quantity)
        if stock == originalStock {
            service.addStock(stock: stock) { (result) in
                switch result{
                case .success(_):
                    completion(nil)
                case .failure(let error):
                    completion(error.localizedDescription)
                }
            }
        }
        else {
            addOrUpdateStock(completion: completion)
        }
    }
    
    func removeStockQuantity(completion: @escaping (_ isValid: Bool,_ error: String?)->()) {
        guard var stock = stock else { return }
        guard validateQuantity() == .Valid else {
            return
        }
        let service = PartFinderService()
        let isSuccessRemove = stock.decreaseQuantity(by: quantity)
        if !isSuccessRemove {
            completion(false,nil)
            return
        }
        service.addStock(stock: stock) { (result) in
            switch result{
            case .success(_):
                completion(true,nil)
            case .failure(let error):
                completion(true,error.localizedDescription)
            }
        }
    }
    
    func transferStockQuantity(completion: @escaping (_ isValid: Bool,_ error: String?)->()) {
        guard let stock = stock, var originalStock = originalStock else { return }
        let service = PartFinderService()
        let isSuccessRemove = originalStock.decreaseQuantity(by: quantity)
        if !isSuccessRemove {
            completion(false,nil)
            return
        }
        if originalStock.partLocation == stock.partLocation {
            completion(false,nil)
            return
        }
        addOrUpdateStock { (error) in
            if let error = error {
                completion(true,error)
            }
            else {
                service.addStock(stock: originalStock) { (result) in
                    switch result {
                    case .success(_):
                    completion(true,nil)
                    case .failure(let error):
                        completion(true,error.localizedDescription)
                    }
                }
            }
        }
    }
    
    private func addOrUpdateStock(completion: @escaping (_ error: String?)->()) {
        guard let stock = stock, quantity >= 0 else { return }
        let service = PartFinderService()
        
        service.updateQuantity(stock: stock, quantity: quantity) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let isUpdated):
                if isUpdated {
                    completion(nil)
                }
                else {
                    var newStock = PartFinder(stock: stock)
                    newStock.increaseQuantity(by: self.quantity)
                    self.addStock(stock: newStock, completion: completion)
                }
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    private func addStock(stock: PartFinder, completion: @escaping (_ error: String?)->()) {
        let service = PartFinderService()
        service.addStock(stock: stock) { (result) in
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
