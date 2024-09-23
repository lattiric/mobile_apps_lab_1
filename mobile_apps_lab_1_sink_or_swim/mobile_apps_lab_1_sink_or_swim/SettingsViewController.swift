//
//  SettingsViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/19/24.
//

import UIKit

protocol SettingsDelegate: AnyObject {
    func didChangeSettings(newText: String);
}

//extension UIViewController: SettingsDelegate {
//    
//}

class SettingsViewController: UIViewController {

    var delegate: SettingsDelegate?
    
    @IBOutlet weak var ligthDarkMode: UISegmentedControl!
    
    lazy var lightDarkModel:LightDarkModel = {
        return LightDarkModel.sharedInstance()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        lazy var isLightOrDark = lightDarkModel.getLightOrDark();
        if(isLightOrDark == 0){
            view.backgroundColor = UIColor.gray
        }else{
            view.backgroundColor = UIColor.white
        }
        
    }
    

    @IBAction func closeSettings(_ sender: Any) {
        print("reached test")
        delegate?.didChangeSettings(newText: "Settings Again?")
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setLight(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0{
            view.backgroundColor = UIColor.gray
        }else if sender.selectedSegmentIndex == 1{
            view.backgroundColor = UIColor.white
        }
//        lightDarkModel.setLightOrDark(0);
    }
    
//

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
