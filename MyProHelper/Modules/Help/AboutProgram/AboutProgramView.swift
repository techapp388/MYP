//
//  AboutProgramView.swift
//  MyProHelper
//
//

import UIKit

class AboutProgramView: UIViewController, Storyboarded {

    @IBOutlet weak private var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let appVersion = GlobalFunction.getAppVersion() ?? ""
        versionLabel.text = "APP VERSION " + appVersion
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }

}
