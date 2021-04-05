//
//  JobDetailListViewModel.swift
//  MyProHelper
//
//

import Foundation

class JobDetailListViewModel: BaseDataTableViewModel<JobDetail, JobDetailListField> {

    private let service = JobDetailService()

    override func reloadData() {
        hasMoreData = true
        fetchService(reloadData: true)
    }

    override func fetchMoreData() {
        fetchService(reloadData: false)
    }

    private func fetchService(reloadData: Bool) {
        guard hasMoreData else { return }
        let offset = (reloadData == false) ? data.count : 0
        service.fetchJobDetail(showRemoved: isShowingRemoved,
                             key: searchKey,
                             sortBy: sortWith?.sortBy,
                             sortType: sortWith?.sortType,
                             offset: offset) { [weak self] (result) in
            guard let self = self else { return }
            switch result {
            case .success(let JobDetails):
                self.hasMoreData = JobDetails.count == Constants.DATA_OFFSET
                if reloadData {
                    self.data = JobDetails
                }
                else {
                    self.data.append(contentsOf: JobDetails)
                }
                self.delegate.reloadView()
            case .failure(let error):
                self.delegate.showError(message: error.localizedDescription)
            }
        }
    }
}

