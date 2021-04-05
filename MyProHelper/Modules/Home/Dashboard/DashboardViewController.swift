//
//  DashboardViewController.swift
//  MyProHelper
//
//

import UIKit
import SideMenu

class GenericDataSource<T>:NSObject {
    var data: DynamicValue<[T]> = DynamicValue([])
    var dataCopy: DynamicValue<[T]> = DynamicValue([])
    var dataArray: DynamicValue<[[T]]> = DynamicValue([])
    var selectedItems: DynamicValue<[T]> = DynamicValue([])
}


class DashboardViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var navigationView: NavigationView!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let service = ScheduleJobService()
    var viewModel:DashboardViewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    private func setUp() {
        self.navigationView.setTitle("Dashboard")
        self.navigationView.delegate = self
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "GenericTableViewCell", bundle: nil) , forCellReuseIdentifier: "GenericTableViewCell")
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 40, right: 0)

        }
}

extension DashboardViewController:NavigationViewDelegate {
    
    func menuButtonAction() {
        let sideMenuView = SideMenuView.instantiate(storyboard: .HOME)
        let menu = SideMenuNavigationController(rootViewController: sideMenuView)
        let screenWidth = UIScreen.main.bounds.width
        menu.leftSide = true
        menu.presentationStyle = .menuSlideIn
        menu.isNavigationBarHidden = true
        menu.menuWidth = (screenWidth > 400) ? 400 : screenWidth
        menu.sideMenuManager.addScreenEdgePanGesturesToPresent(toView: view)
        self.present(menu, animated: true, completion: nil)
    }
    
    func addButtonAction() {
        
    }
    
    func layoutButtonAction() {
        DispatchQueue.main.async {
            let layoutVC = DashboardLayoutViewController()
            layoutVC.modalPresentationStyle = .fullScreen
            layoutVC.layoutDelegate = self
            self.present(layoutVC, animated: true, completion: nil)
        }
    }
    
}

extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "GenericTableViewCell") as? GenericTableViewCell else {
            return UITableViewCell()
        }
        cell.calendarView.subviews.forEach({ $0.removeFromSuperview() })
        
        let genericController = CalendarViewController()
        guard let view = genericController.view else {
            return UITableViewCell()
        }
        cell.configure(with: view)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DashboardViewController: DashboardLayoutViewControllerDelegate{
    func updateLayout() {
        print("did add widget")
    }
}
