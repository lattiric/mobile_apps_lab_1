//
//  ModalSettingsViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/22/24.
//

import UIKit

protocol SettingsDelegate: AnyObject {
    func didChangeSettings(newText: String);
}

class ModalSettingsViewController: UIViewController {
    
    var delegate: SettingsDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didChangeSettings(newText: "Pranked!")        // Do any additional setup after loading the view.
        
        view.backgroundColor = UIColor.gray
        
        let closeSettings = UIButton()
        closeSettings.setTitle("Done", for: .normal)
        view.addSubview(closeSettings)
        closeSettings.frame = CGRect(x: 100, y: 300, width: 100, height: 50)
        closeSettings.addTarget(self, action: #selector(actCloseSettings), for: .touchUpInside)
        
    }
    
    
    @IBAction func actCloseSettings(_ sender: Any) {
        print("reached test")
        //        delegate?.didChangeSettings(newText: "Settings Again?")
        dismiss(animated: true, completion: nil)
    }
}
