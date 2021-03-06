

import Foundation
import UIKit
protocol RDelegate {
        func rejectFunction()
       
    }
class rejectView: UIViewController,Storyboarded {
    var rejectdelegate: RDelegate!

    @IBOutlet weak var backgroundViewContainer: UIView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var DiscardButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var remarksTextField: UITextField!
    let timeOffApprovalservice = TimeOffApprovalService()
    var selectedWorker: Worker!
    var workersPickerDataSource: [Worker] = []
    var workername = String()
    var startdate = Date()
    var enddate = Date()
    var leavetype = String()
    var leavestatus = String()
    var descriptiontext = String()
    var remark = String()
    var workerID = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTapGesture()
        backgroundViewContainer.cornerRadius = 15
        
    }
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDismissView))
        backgroundViewContainer.addGestureRecognizer(tapGesture)
    }
    @objc private func handleDismissView() {
        dismiss(animated: true, completion: nil)
        //self.viewModel.fetchMoreData()
    
    }
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        handleDismissView()
    }
    @IBAction func saveAction(_sender :UIButton){
        if (remarksTextField.text == "") {
            print("name")
            // create the alert
                   let alert = UIAlertController(title: "Remarks", message: "Please fill the remarks", preferredStyle: UIAlertController.Style.alert)

                   // add an action (button)
                   alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                   // show the alert
                   self.present(alert, animated: true, completion: nil)
        }else{
            
             let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            var approvaldata = Approval()
            approvaldata.approvername = "Adam"
            approvaldata.approvedby = 1
            approvaldata.approveddate = Date()
            approvaldata.workerID = workerID
            approvaldata.workername = workername
            approvaldata.worker = selectedWorker
            approvaldata.startdate = startdate
            approvaldata.enddate = enddate
            approvaldata.typeofleave = leavetype
            approvaldata.status = "Rejected"
            approvaldata.description = descriptiontext
            approvaldata.remark = remarksTextField.text
            approvaldata.requesteddate = Date()
            approvaldata.removed = false
            approvaldata.removedDate = Date()
            timeOffApprovalservice.updateApproval(approvaldata, completion: { [weak self] (result) in
                guard self != nil else { return }
                switch result {
                case .success(_):
                    self!.rejectdelegate.rejectFunction()
                    self!.handleDismissView()
                    print("sucees while Fetching Workers")
                    
                case .failure( _):
                    self!.handleDismissView()
                    print("ERROR while Fetching Workers")
                }
               
            })
            


        }
    }
}
