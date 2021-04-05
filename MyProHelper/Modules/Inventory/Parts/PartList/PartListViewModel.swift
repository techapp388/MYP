//
//  PartListViewModel.swift
//  MyProHelper
//
//

import Foundation

class PartListViewModel: BaseDataTableViewModel<Part, PartField> {
    
    private let service = PartsService()
    private let stockService = PartFinderService()
    
    func hasWaitingJobs(at index: Int) -> Bool{
//        guard let partUsed = data[index].partUsed else {
//            return false
//        }
//        return partUsed.waitingForPart ?? false
        return false
    }
    
    override func reloadData() {
        hasMoreData = true
        fetchParts(reloadData: true)
    }
    
    override func fetchMoreData() {
        fetchParts(reloadData: false)
    }
    
    override func deleteItem(at row: Int) {
        let part = data[row]
        service.deletePart(part: part) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.reloadData()
            case .failure(let error):
                self.delegate.showError(message: error.localizedDescription)
            }
        }
    }
    
    override func undeleteItem(at row: Int) {
        let part = data[row]
        service.undeletePart(part: part) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.reloadData()
            case .failure(let error):
                self.delegate.showError(message: error.localizedDescription)
            }
        }
    }
    
    private func fetchParts(reloadData: Bool) {
        guard hasMoreData else { return }
        let offset = (reloadData == false) ? data.count : 0
        
        service.fetchParts(showRemoved: isShowingRemoved,key: searchKey, sortBy: sortWith?.sortBy, sortType: sortWith?.sortType, offset: offset) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let partArray):
                self.hasMoreData = partArray.count == Constants.DATA_OFFSET
                if reloadData {
                    self.data = partArray
                }
                else {
                    self.data.append(contentsOf: partArray)
                }
                self.delegate.reloadView()
            case .failure(let error):
                self.delegate.showError(message: error.localizedDescription)
            }
        }
    }
}
