//
//  ViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/16/24.
//  Testing testing

import UIKit

class ViewController: UIViewController{
    
   
    @IBOutlet weak var logoView: UIImageView!
    
    @IBOutlet weak var fakeSettings: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.darkGray;
    
        self.logoView.image = UIImage.init(named: "logo")
    }

    
    @IBAction func enterApp(_ sender: Any) {
        
    }
    
    @IBAction func enterModal(_ sender: Any) {
        let destinationVC = ModalSettingsViewController()
        destinationVC.delegate = self
        present(destinationVC, animated: true, completion: nil)
    }
    
    
    @IBAction func enterSettings(_ sender: Any) {
    }
}

extension ViewController: SettingsDelegate {
    func didChangeSettings(newText: String){
//        settingsButton.setTitle(newText, for: .normal)
//        print("reached")
        fakeSettings.setTitle("Testing", for: .normal)

    }
}
