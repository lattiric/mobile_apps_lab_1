//
//  ViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/16/24.
//  Testing testing

import UIKit

class ViewController: UIViewController, SettingsDelegate {

    
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var logoView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.darkGray;
    
        self.logoView.image = UIImage.init(named: "logo")
        
        let destinationVC = SettingsViewController()
        destinationVC.delegate = self
    }

    func didChangeSettings(newText: String){
//        settingsButton.setTitle(newText, for: .normal)
        settingsButton.setTitle("Testing", for: .normal)

    }
    
    @IBAction func enterApp(_ sender: Any) {
        
    }
    
    @IBAction func enterSettings(_ sender: Any) {
        
    }
}

