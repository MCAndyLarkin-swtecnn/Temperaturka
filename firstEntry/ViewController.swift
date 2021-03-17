//
//  ViewController.swift
//  firstEntry
//
//  Created by user on 16.03.2021.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var celciumTextField: UITextField!
    
    @IBOutlet var fahrenheitSlider: UISlider!
    @IBOutlet var fahrenheitLabel: UILabel!
    
    @IBOutlet var kelvinStepper: UIStepper!
    @IBOutlet var kelvinLabel: UILabel!

    let FAHRENHEIT_MAX:Float = 1832
    let FAHRENHEIT_MIN: Float = -459.67
    let CELSIUM_MAX: Double = 1000
    let CELSIUM_MIN: Double = -273.15
    let KELVIN_MAX: Double = 1273.15
    let KELVIN_MIN: Double = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//         Do any additional setup after loading the view.
        
        celciumTextField.font = .systemFont(ofSize: 40)
        
        kelvinStepper.maximumValue = KELVIN_MAX
        kelvinStepper.minimumValue = KELVIN_MIN

        fahrenheitSlider.maximumValue = FAHRENHEIT_MAX
        fahrenheitSlider.minimumValue = FAHRENHEIT_MIN
        
        fahrenheitSlider.value = FAHRENHEIT_MIN
        kelvinStepper.value = KELVIN_MIN
    }

    @IBAction func celciumTextFieldDidChanged(_ sender: Any){
        let str = celciumTextField.text
        if var kelvin = Double(str ?? "0.0"){
            if(kelvin <= CELSIUM_MAX && kelvin >= CELSIUM_MIN){

                let fahr = Float(kelvin*9/5 + 32)
                
                fahrenheitLabel.text = "\(round( fahr * 100) / 100) ° of Fahrenheit"
                fahrenheitSlider.value = Float(fahr)
                    
                kelvin += 273.15
                
                kelvinLabel.text = "\(round((kelvin) * 100) / 100) " + "K"
                kelvinStepper.value = kelvin
            }else{
                celciumTextField.text = String(str!.prefix(str!.count-1))
            }
            
        }
    }
    @IBAction func fahrenheitSliderDidMoved(_ sender: Any){
        let fahr = fahrenheitSlider.value
        fahrenheitLabel.text = "\(fahr) ° of Fahrenheit"
        
        let celsius = (fahr - 32)*5.0/9.0
        celciumTextField.text = "\(round(celsius * 100) / 100)"
        
        let kelvin: Double = Double(celsius) + 273.15
        kelvinLabel.text = "\(round(kelvin * 100) / 100) K"
        kelvinStepper.value = kelvin
        
    }
    @IBAction func kelvinStepperDidPushed(_ sender: Any){
        kelvinLabel.text = "\(round( kelvinStepper.value * 100) / 100) " + "K"
        
        let celsiumVal = kelvinStepper.value - 273.15
        celciumTextField.text = "\(round( celsiumVal * 100) / 100)"
        
        let fahr = celsiumVal*9/5 + 32
        fahrenheitLabel.text = "\(round( fahr * 100) / 100) ° of Fahrenheit"
        fahrenheitSlider.value = Float(fahr)
    }

}
