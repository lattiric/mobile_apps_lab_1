//
//  Page3ViewController.swift
//  mobile_apps_lab_1_sink_or_swim
//
//  Created by Rick Lattin on 9/19/24.
//

import UIKit

class Page3ViewController: UIViewController {

    @IBOutlet weak var SwitchAction: UISwitch!
    
    @IBOutlet weak var slider: UISlider!
    
    @IBOutlet weak var timerBTN: UIButton!
    
    @IBOutlet weak var stopTimer: UIButton!
    
    var timer: Timer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
                
        stopTimer.addTarget(self, action: #selector(self.stopButtonClicked(_:)), for: UIControl.Event.touchUpInside)
        
            
        timerBTN.addTarget(self, action: #selector(self.buttonClicked(_:)), for: UIControl.Event.touchUpInside)
        
            SwitchAction.addTarget(self, action: #selector(self.valueChanged(_:)), for: UIControl.Event.valueChanged)
            
            slider.addTarget(self,action:#selector(self.sliderValueChanged(_:)),for:UIControl.Event.valueChanged)
            // Do any additional setup after loading the view.
        
       
            
        
        }
    
    @IBAction func buttonClicked(_ sender: Any){
        print("BUTTON CLICKED")
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            if(self.view.backgroundColor != UIColor.green){
                self.view.backgroundColor = UIColor.green
            }else{
                self.view.backgroundColor = UIColor.white
            }
            
        }
        timer.fire()
    }
    
    @IBAction func stopButtonClicked(_ sender: Any){
        
        timer.invalidate()
    }
        
        @IBAction func valueChanged(_ sender: Any) {
            print("HERE!!!")
            if SwitchAction.isOn {
                print("Switch is on")
                self.view.backgroundColor = UIColor.white
            } else {
                print("Switch is off")
                self.view.backgroundColor = UIColor.black
            }
            //timer.invalidate()
            
        }
        
        @IBAction func sliderValueChanged(_ sender: Any) {
            //timer.invalidate()
            print("Slider value: \(slider.value)")
            if (slider.value > 0 && slider.value <= 0.1) {
                self.view.backgroundColor = UIColor.white
            }else if (slider.value > 0.1  && slider.value <= 0.2){
                self.view.backgroundColor = UIColor.red
            }else if (slider.value > 0.2  && slider.value <= 0.3){
                self.view.backgroundColor = UIColor.orange
            }else if (slider.value > 0.3  && slider.value <= 0.4){
                self.view.backgroundColor = UIColor.yellow
            }else if (slider.value > 0.4  && slider.value <= 0.5){
                self.view.backgroundColor = UIColor.green
            }else if (slider.value > 0.5  && slider.value <= 0.6){
                self.view.backgroundColor = UIColor.blue
            }else if (slider.value > 0.6  && slider.value <= 0.7){
                self.view.backgroundColor = UIColor.cyan
            }else if (slider.value > 0.7  && slider.value <= 0.8){
                self.view.backgroundColor = UIColor.purple
            }else if (slider.value > 0.8  && slider.value <= 0.9){
                self.view.backgroundColor = UIColor.brown
            }else if (slider.value > 0.9  && slider.value <= 1){
                self.view.backgroundColor = UIColor.black
            }
            
        }
        
    

        /*
        // MARK: - Navigation

        // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            // Get the new view controller using segue.destination.
            // Pass the selected object to the new view controller.
        }
        */
    
    

}
