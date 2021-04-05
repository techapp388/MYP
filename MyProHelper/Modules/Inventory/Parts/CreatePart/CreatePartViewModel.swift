//
//  CreatePartViewModel.swift
//  MyProHelper
//
//

import Foundation

class CreatePartViewModel: BaseAttachmentViewModel {
    
    private var part = Part()
    private var isUpdatingPart = false
    private var partStock: [PartFinder] = []
    private var vendors: [Vendor] = []
    private var partLocations: [PartLocation] = []
    private var partService = PartsService()
    private var hasMoreStocks = false
    
    func setPart(part: Part) {
        self.isUpdatingPart = true
        self.part = part
        self.sourceId = part.partID
        self.part.updateModifyDate()
    }
    
    func countStock() -> Int {
        return partStock.count
    }
    
    func getStock(at index: Int) -> PartFinder? {
        guard partStock.count > index else { return nil }
        return partStock[index]
    }
    
    func getStocks() -> [PartFinder] {
        return partStock
    }
    
    func addStock(stock: PartFinder) {
        if let index = partStock.firstIndex(of: stock) {
            partStock[index].increaseQuantity(by: stock.quantity)
        }
        else {
            partStock.append(stock)
        }
    }
    
    func updateStock(stock: PartFinder) {
        if let index = partStock.firstIndex(where: { $0.partFinderId == stock.partFinderId }) {
            partStock[index] = stock
        }
    }
    
    func getPartName() -> String? {
        return part.partName
    }
    
    func getPartDescription() -> String? {
        return part.description
    }
    
    func setPartName(name: String?) {
        part.partName = name
    }
    
    func setPartDescription(description: String?) {
        part.description = description
    }
    
    func validateName() -> ValidationResult {
        return Validator.validateName(name: part.partName)
    }
    
    func validateDescription() -> ValidationResult {
        guard let description = part.description, !description.isEmpty else {
            return .Valid
        }
        return Validator.validateName(name: description)
    }
    
    func isValidData() -> Bool {
        return  validateName()          == .Valid &&
                validateDescription()   == .Valid
    }
    
    func getVendors(completion: @escaping () -> ()) {
        let vendorService = VendorService()
        vendorService.fetchVendors(offset: 0) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let vendors):
                self.vendors = vendors
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getPartLocations(completion: @escaping () -> ()) {
        let partLocationService = PartLocationService()
        partLocationService.fetchPartLocations(offset: 0) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let partLocations):
                self.partLocations = partLocations
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func getStocks(isReload: Bool = true, completion: @escaping () -> ()) {
        if !isReload && !hasMoreStocks {
            return
        }
        guard let partID = part.partID else {
            return
        }
        
        let offset = (isReload) ? 0 : partStock.count
        let stockService = PartFinderService()
        
        stockService.fetchStock(partID: partID, offset: offset) { (result) in
            switch result {
                
            case .success(let stocks):
                self.hasMoreStocks = stocks.count == Constants.DATA_OFFSET
                if isReload {
                    self.partStock = stocks
                }
                else {
                    self.partStock.append(contentsOf: stocks)
                }
                
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    func addPart(completion: @escaping (_ error: String?, _ isValidData: Bool) -> ()) {
        if !isValidData() {
            completion(nil,false)
            return
        }
        part.numberOfAttachments = numberOfAttachment
        if isUpdatingPart {
            updatePart { (error) in
                completion(error,true)
            }
        }
        else {
            savePart { (error) in
                completion(error,true)
            }
        }
        
    }
    
    private func savePart(completion: @escaping (_ error: String?) -> ()) {
        partService.createPart(part: part) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let partID):
                self.saveAttachment(id: Int(partID))
                self.saveStock(for: Int(partID)) { error in
                    completion(error)
                }
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    private func updatePart(completion: @escaping (_ error: String?) -> ()) {
        guard let partID = part.partID else {
            completion("an error has occurred")
            return
        }
        
        partService.updatePart(part: part) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.saveAttachment(id: partID)
                self.saveStock(for: partID) { (error) in
                    completion(error)
                }
                
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
    
    private func saveStock(for partID: Int, completion: @escaping (_ error: String?)->()) {
        let stockService = PartFinderService()
        var numberOfStocks = partStock.count
        
        if numberOfStocks == 0 {
            completion(nil)
            return
        }
        
        for var stock in partStock {
            stock.partID = partID
            stockService.addStock(stock: stock) { (result) in
                switch result {
                case .success(_):
                    numberOfStocks -= 1
                    if numberOfStocks == 0 {
                        completion(nil)
                    }
                case .failure(let error):
                    completion(error.localizedDescription)
                }
            }
        }
    }
    
    func deleteStock(stock: PartFinder, completion: @escaping (_ error: String?)->()) {
        let stockService = PartFinderService()
        stockService.delete(stock: stock) { (result) in
            switch result {
            case .success(_):
                completion(nil)
                
            case .failure(let error):
                completion(error.localizedDescription)
            }
        }
    }
}
