//
//  SideMenuView.swift
//  MyProHelper
//
//

import UIKit
import ExpandableCell

fileprivate enum MainCell {
    case profile
    case JobList
    case Calendar
    case Customers
    case Jobs
    case Inventory
    case Workers
    case Payroll
    case Approvals
    case Reports
    case MasterSetup
    case Help
}

fileprivate enum SubCell {
    case ScheduledJobs
    case JobList
    case QuotesOrEstimates
    case Parts
    case WorkerList
    case ExpenseStatements
    case CreatePayroll
    case InvoiceApprovals
    case WorkOrderApprovals
    case PurchaseOrderApprovals
    case ExpenseStatementApprovals
    case Jobs
    case UnscheduledJobs
    case BalanceAmount
    case ReceivedAmount
    case technicalSupport
    case ContactUs
    case AuditTrail
    case ReferToFriend
    case AboutProgram
    case AdjustCompanySettings
    case CompanyInformation
    case AssetType
    case Assets
    case Services
    case RoleGroup
    case Devices
    case PartLocations
    case SupplyLocations
    case Vendors
    case TimeOffRules
    case Holidays
    case JobHistory
    case JobConfirmation
    case Invoices
    case Payments
    case Receipts
    case Supplies
    case PurchaseOrders
    case WorkOrders
    case CurrentTimeSheet
    case TimeSheetHistory
    case TimeOffRequest
    case Wages
    case TimeSheets
    case TimeOffApprovals
    case OpenJobDetails
    
}

class SideMenuView: UIViewController, Storyboarded {

    @IBOutlet weak private var expandableTableView: ExpandableTableView!
    private var mainTableCells: [MainCell] = [.profile,
                                              .JobList ,
                                              .Calendar,
                                              .Customers,
                                              .Jobs,
                                              .Inventory,
                                              .Workers,
                                              .Payroll,
                                              .Approvals,
                                              .Reports,
                                              .MasterSetup,
                                              .Help]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    private func setupTableView() {
        let mainCell = UINib(nibName: SideMenuCell.ID, bundle: nil)
        let profileCell = UINib(nibName: ProfileCell.ID, bundle: nil)
        let sideMenuSubCell = UINib(nibName: SideMenuSubCell.ID, bundle: nil)

        expandableTableView.expandableDelegate = self
        expandableTableView.animation = .automatic
        expandableTableView.expansionStyle = .multi
        expandableTableView.allowsSelection = true
        expandableTableView.separatorStyle = .none
        expandableTableView.showsVerticalScrollIndicator = false
        expandableTableView.register(sideMenuSubCell, forCellReuseIdentifier: SideMenuSubCell.ID)
        expandableTableView.register(mainCell, forCellReuseIdentifier: SideMenuCell.ID)
        expandableTableView.register(profileCell, forCellReuseIdentifier: ProfileCell.ID)
        expandableTableView.contentInset = UIEdgeInsets(top: 20,
                                                        left: 0,
                                                        bottom: 20,
                                                        right: 0)
    }

    private func getSupCellsFor(section: MainCell) -> [SubCell] {
        switch section {
        case .profile:
            return []
        case .JobList:
            return []
        case .Calendar:
            return []
        case .Customers:
            return []
        case .Jobs:
            return [.ScheduledJobs, .JobList, .OpenJobDetails, .JobConfirmation,
                    .JobHistory ,.QuotesOrEstimates, .Invoices,
                    .Payments, .Receipts]
        case .Inventory:
            return [.Parts,.Supplies,.PurchaseOrders,.WorkOrders]
        case .Workers:
            return [.WorkerList, .ExpenseStatements,.CurrentTimeSheet,
                    .TimeSheetHistory,.TimeOffRequest,.Wages]
        case .Payroll:
            return [.CreatePayroll,.TimeSheets]
        case .Approvals:
            return [.TimeOffApprovals,.InvoiceApprovals, .WorkOrderApprovals,
                    .PurchaseOrderApprovals, .ExpenseStatementApprovals]
        case .Reports:
            return [.Jobs ,.ScheduledJobs ,.UnscheduledJobs,
                    .BalanceAmount, .ReceivedAmount]
        case .MasterSetup:
            return [.AdjustCompanySettings, .CompanyInformation, .AssetType,
                    .Assets, .Services, .RoleGroup,
                    .Devices, .PartLocations, .SupplyLocations,
                    .Vendors, .TimeOffRules, .Holidays]
        case .Help:
            return [.technicalSupport, .ContactUs, .AuditTrail,
                    .ReferToFriend, .AboutProgram]
        }
    }
    
    private func getTitleForSupCell(cell: SubCell) -> String {
        switch cell {
        
        case .ScheduledJobs:
            return "SCHEDULE_JOBS".localize
        case .JobList:
            return "JOB_LIST".localize
        case .QuotesOrEstimates:
            return "\("QOUTES".localize)/\("ESTIMATES".localize)"
        case .Parts:
            return "PARTS".localize
        case .WorkerList:
            return "WORKERS_LIST".localize
        case .ExpenseStatements:
            return "EXPENSE_STATEMENTS".localize
        case .CreatePayroll:
            return "CREATE_PAYROLL".localize
        case .InvoiceApprovals:
            return "INVOICE_APPROVALS".localize
        case .WorkOrderApprovals:
            return "WORK_ORDER_APPROVALS".localize
        case .PurchaseOrderApprovals:
            return "PURCHASE_ORDER_APPROVALS".localize
        case .ExpenseStatementApprovals:
            return "EXPENSE_STATEMENT_APPROVALS".localize
        case .Jobs:
            return "JOBS".localize
        case .UnscheduledJobs:
            return "UNSCHEDULED_JOBS".localize
        case .BalanceAmount:
            return "BALANCE_AMOUNT".localize
        case .ReceivedAmount:
            return "RECEIVED_AMOUNT".localize
        case .technicalSupport:
            return "TECHNICAL_SUPPORT".localize
        case .ContactUs:
            return "CONTACT_US".localize
        case .AuditTrail:
            return "AUDIT_TRAIL".localize
        case .ReferToFriend:
            return "REFER_A_FRIEND".localize
        case .AboutProgram:
            let appVersion = GlobalFunction.getAppVersion() ?? ""
            return "ABOUT_PROGRAM".localize + "\t v " + appVersion
        case .AdjustCompanySettings:
            return "ADJUST_COMPANY_SETTINGS".localize
        case .CompanyInformation:
            return "COMPANY_INFORMATION".localize
        case .AssetType:
            return "ASSET_TYPE".localize
        case .Assets:
            return "ASSETS".localize
        case .Services:
            return "SERVICES".localize
        case .RoleGroup:
            return "ROLES_GROUP".localize
        case .Devices:
            return "DEVICES".localize
        case .PartLocations:
            return "PART_LOCATIONS".localize
        case .SupplyLocations:
            return "SUPPLY_LOCATIONS".localize
        case .Vendors:
            return "VENDORS".localize
        case .TimeOffRules:
            return "TIME_OFF_RULES".localize
        case .Holidays:
            return "HOLIDAYS".localize
        case .JobHistory:
            return "JOB_HISTORY".localize
        case .JobConfirmation:
            return "JOB_CONFIRMATION".localize
        case .Invoices:
            return "INVOICES".localize
        case .Payments:
            return "PAYMENTS".localize
        case .Receipts:
            return "RECEIPTS".localize
        case .Supplies:
            return "SUPPLIES".localize
        case .PurchaseOrders:
            return "PURCHASE_ORDERS".localize
        case .WorkOrders:
            return "WORK_ORDERS".localize
        case .CurrentTimeSheet:
            return "CURRENT_TIME_SHEET".localize
        case .TimeSheetHistory:
            return "TIME_SHEET_HISTORY".localize
        case .TimeOffRequest:
            return "TIME_OFF_REQUEST".localize
        case .Wages:
            return "WAGES".localize
        case .TimeSheets:
            return "TIME_SHEETS".localize
        case .TimeOffApprovals:
            return "TIME_OFF_APPROVALS".localize
        case .OpenJobDetails:
            return "OPEN_JOB_DETAILS".localize
      
        }
    }
}

// MARK: - Conforming to Expandable Delegate
extension SideMenuView: ExpandableDelegate {
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let mainCell = mainTableCells[indexPath.section]
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: SideMenuCell.ID) as? SideMenuCell else {
            return UITableViewCell()
        }
        switch mainCell {
        case .profile:
            guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: ProfileCell.ID) as? ProfileCell else {
                return UITableViewCell()
            }
            cell.didPressCloseButton = {
                self.dismiss(animated: true, completion: nil)
            }
            return cell
        case .JobList:
            let title = "JOB_LIST".localize
            let icon = UIImage(named: Constants.Image.JOB_LIST)
            cell.setupCell(title: title, icon: icon)
        case .Calendar:
            let title = "CALENDAR".localize
            let icon = UIImage(named: Constants.Image.CALENDAR)
            cell.setupCell(title: title, icon: icon)
        case .Customers:
            let title = "CUSTOMERS".localize
            let icon = UIImage(named: Constants.Image.CUSTOMERS)
            cell.setupCell(title: title, icon: icon)
        case .Jobs:
            let title = "JOBS".localize
            let icon = UIImage(named: Constants.Image.JOBS)
            cell.setupCell(title: title, icon: icon)
        case .Inventory:
            let title = "INVENTORY".localize
            let icon = UIImage(named: Constants.Image.INVENTORY)
            cell.setupCell(title: title, icon: icon)
        case .Workers:
            let title = "WORKERS".localize
            let icon = UIImage(named: Constants.Image.WORKERS)
            cell.setupCell(title: title, icon: icon)
        case .Payroll:
            let title = "PAYROLL".localize
            let icon = UIImage(named: Constants.Image.PAYROLL)
            cell.setupCell(title: title, icon: icon)
        case .Approvals:
            let title = "APPROVALS".localize
            let icon = UIImage(named: Constants.Image.APPROVALS)
            cell.setupCell(title: title, icon: icon)
        case .Reports:
            let title = "REPORTS".localize
            let icon = UIImage(named: Constants.Image.REPORTS)
            cell.setupCell(title: title, icon: icon)
        case .MasterSetup:
            let title = "MASTER_SETUP".localize
            let icon = UIImage(named: Constants.Image.MASTER_SETUP)
            cell.setupCell(title: title, icon: icon)
        case .Help:
            let title = "HELP".localize
            let icon = UIImage(named: Constants.Image.HELP)
            cell.setupCell(title: title, icon: icon)
        }
        if getSupCellsFor(section: mainCell).isEmpty {
            cell.hideExpandArrow()
        }
        else {
            cell.showExpandArrow()
        }
        return cell
        
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, expandedCellsForRowAt indexPath: IndexPath) -> [UITableViewCell]? {
        let mainCell = mainTableCells[indexPath.section]
        let subCells = getSupCellsFor(section: mainCell)
        var cells: [SideMenuSubCell] = []
        
        for subCell in subCells {
            let title = getTitleForSupCell(cell: subCell)
            if let cell = expandableTableView.dequeueReusableCell(withIdentifier: SideMenuSubCell.ID) as? SideMenuSubCell {
                cell.setTitle(title: title)
                cells.append(cell)
            }
        }
        return cells
    }
    
    func numberOfSections(in expandableTableView: ExpandableTableView) -> Int {
        return mainTableCells.count
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if mainTableCells[indexPath.section] == .profile {
            return 250
        }
        return 60
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, heightsForExpandedRowAt indexPath: IndexPath) -> [CGFloat]? {
        let mainCell = mainTableCells[indexPath.section]
        let subCells = getSupCellsFor(section: mainCell)
        var heights: [CGFloat] = []
        for _ in subCells {
            heights.append(40)
        }
        return heights
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = expandableTableView.cellForRow(at: indexPath) as? SideMenuCell {
            cell.animate()
        }

        let selectedCell = mainTableCells[indexPath.section]
        switch selectedCell {
        case .JobList:
            navigateToView(withKey: .jobList)
        case .Calendar:
            navigateToView(withKey: .calendar)
        case .Customers:
            navigateToView(withKey: .customerList)
        default:
            break
        }
    }
    
    func expandableTableView(_ expandableTableView: ExpandableTableView, didSelectExpandedRowAt indexPath: IndexPath) {
        let mainCell = mainTableCells[indexPath.section]
        let subCells = getSupCellsFor(section: mainCell)
        let subCell = subCells[indexPath.row - 1]
        navigateFromSubCell(withCell: subCell)
    }
 
    func expandableTableView(_ expandableTableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

// MARK: - Navigation Helpers
extension SideMenuView {
    private func navigateToView(withKey view: ControllerKeys) {
        let genericController = ControllerFactory().getViewController(from:view)
        if let viewController = genericController.viewController {
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }

    private func navigateFromSubCell(withCell cell: SubCell) {
        switch cell {
        case .ScheduledJobs:
            navigateToView(withKey: .scheduleJobs)
        case .JobList:
            navigateToView(withKey: .jobList)
        case .OpenJobDetails:
            navigateToView(withKey: .jobDetail)
        case .QuotesOrEstimates:
            navigateToView(withKey: .quotesAndEstimates)
        case .Invoices:
            navigateToView(withKey: .invoice)
        case .Payments:
            navigateToView(withKey: .payment)
        case .Receipts:
            navigateToView(withKey: .receipt)
        case .Parts:
            navigateToView(withKey: .parts)
        case .WorkerList:
            navigateToView(withKey: .workersList)
        case .ExpenseStatements:
            break
        case .CreatePayroll:
            break
        case .InvoiceApprovals:
            navigateToView(withKey: .invoice)
        case .WorkOrderApprovals:
            navigateToView(withKey: .WorkOrderApprovals)

            break
        case .PurchaseOrderApprovals:
            break
        case .ExpenseStatementApprovals:
            break
        case .Jobs:
            break
        case .UnscheduledJobs:
            break
        case .BalanceAmount:
            break
        case .ReceivedAmount:
            break
        case .technicalSupport:
            navigateToView(withKey: .technicalSupport)
        case .ContactUs:
            navigateToView(withKey: .contactUs)
        case .AuditTrail:
            break
        case .ReferToFriend:
            break
        case .AboutProgram:
            navigateToView(withKey: .aboutProgram)
            break
        case .AdjustCompanySettings:
            break
        case .CompanyInformation:
            break
        case .AssetType:
            navigateToView(withKey: .assetType)
        case .Assets:
            navigateToView(withKey: .asset)
        case .Services:
            navigateToView(withKey: .serviceType)
        case .RoleGroup:
            break
        case .Devices:
            break
        case .PartLocations:
            navigateToView(withKey: .partLocation)
        case .SupplyLocations:
            navigateToView(withKey: .supplyLocation)
        case .Vendors:
            navigateToView(withKey: .vendors)
        case .TimeOffRules:
            break
        case .Holidays:
            navigateToView(withKey: .holidays)
            break
        case .JobHistory:
            navigateToView(withKey: .jobHistory)
        case .JobConfirmation:
            navigateToView(withKey: .jobConfirmation)
        case .Supplies:
            break
        case .PurchaseOrders:
            break
        case .WorkOrders:
            
            break
        case .CurrentTimeSheet:
            break
        case .TimeSheetHistory:
            break
        case .TimeOffRequest:
            break
        case .Wages:
            break
        case .TimeSheets:
            break
        case .TimeOffApprovals:
            navigateToView(withKey: .timeoffapproval)
           
        }
    }
}
