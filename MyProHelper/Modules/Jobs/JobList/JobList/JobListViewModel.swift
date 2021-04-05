//
//  JobListViewModel.swift
//  MyProHelper
//
//

import Foundation

class JobListViewModel: BaseDataTableViewModel<Job, JobField> {
    
    let service = ScheduleJobService()
    
    override func reloadData() {
        hasMoreData = true
        FetchJob(reloadData: true)
    }
    
    override func fetchMoreData() {
        FetchJob(reloadData: false)
    }
    
    override func deleteItem(at row: Int) {
        let job = data[row]
        service.deleteJob(job: job) { [weak self] (result) in
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
        let job = data[row]
        service.restoreJob(job) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success:
                self.reloadData()
            case .failure(let error):
                self.delegate.showError(message: error.localizedDescription)
            }
        }
    }
    
    private func FetchJob(reloadData: Bool) {
        guard hasMoreData else { return }
        let offset = (reloadData == false) ? data.count : 0
        service.fetchJobs(showRemoved: isShowingRemoved, key: searchKey, sortBy: sortWith?.sortBy, sortType: sortWith?.sortType, offset: offset) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let workers):
                self.hasMoreData = workers.count == Constants.DATA_OFFSET
                if reloadData {
                    self.data = workers
                }
                else {
                    self.data.append(contentsOf: workers)
                }
                self.delegate.reloadView()
            case .failure(let error):
                self.delegate.showError(message: error.localizedDescription)
            }
        }
    }
}
