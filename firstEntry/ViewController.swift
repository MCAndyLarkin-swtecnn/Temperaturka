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
    
    @IBOutlet var redView: UIView!


    let CELSIUM_MAX: Double = 1000
    let CELSIUM_MIN: Double = -273.15
    lazy var FAHRENHEIT_MAX = Float(CELSIUM_MAX*9/5+32)
    lazy var FAHRENHEIT_MIN = Float(CELSIUM_MIN*9/5+32)
    lazy var KELVIN_MAX: Double = CELSIUM_MAX + 273.15
    lazy var KELVIN_MIN: Double = CELSIUM_MIN + 273.15
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        celciumTextField.font = .systemFont(ofSize: 40)
        
        kelvinStepper.maximumValue = KELVIN_MAX
        kelvinStepper.minimumValue = KELVIN_MIN

        fahrenheitSlider.maximumValue = FAHRENHEIT_MAX
        fahrenheitSlider.minimumValue = FAHRENHEIT_MIN
        
        fahrenheitSlider.value = FAHRENHEIT_MIN
        kelvinStepper.value = KELVIN_MIN
        
        redView.alpha = 0
        celciumTextField.textColor = UIColor.white
    }

    @IBAction func celciumTextFieldDidChanged(_ sender: Any){
        let str = celciumTextField.text
        if var kelvin = Double(str ?? "0.0"){
            if(kelvin <= CELSIUM_MAX && kelvin >= CELSIUM_MIN){

                let fahr = Float(kelvin*9/5 + 32)
                
                fahrenheitLabel.text = "\(round( fahr * 100) / 100) ° of Fahrenheit"
                fahrenheitSlider.value = Float(fahr)
                    
                kelvin += 273.15
                kelvin = round((kelvin) * 100) / 100
                
                kelvinLabel.text = "\(kelvin) " + "K"
                kelvinStepper.value = kelvin
                
                redView.alpha = CGFloat((kelvin-KELVIN_MIN)/(KELVIN_MAX-KELVIN_MIN))
            }else{
                celciumTextField.text = String(str!.prefix(str!.count-1))
            }
        }
    }
    @IBAction func fahrenheitSliderDidMoved(_ sender: Any){
        let fahr = fahrenheitSlider.value
        fahrenheitLabel.text = "\(round(fahr * 100) / 100) ° of Fahrenheit"
        
        let celsius = (fahr - 32)*5.0/9.0
        celciumTextField.text = "\(round(celsius * 100) / 100)"
        
        let kelvin: Double = round((Double(celsius) + 273.15) * 100) / 100
        kelvinLabel.text = "\(kelvin) K"
        kelvinStepper.value = kelvin
        
        redView.alpha = CGFloat((kelvin-KELVIN_MIN)/(KELVIN_MAX-KELVIN_MIN))
    }
    @IBAction func kelvinStepperDidPushed(_ sender: Any){
        let kelvin = round((kelvinStepper.value) * 100) / 100
        kelvinLabel.text = "\(kelvin) " + "K"
        
        let celsiumVal = kelvinStepper.value - 273.15
        celciumTextField.text = "\(round( celsiumVal * 100) / 100)"
        
        let fahr = celsiumVal*9/5 + 32
        fahrenheitLabel.text = "\(round( fahr * 100) / 100) ° of Fahrenheit"
        fahrenheitSlider.value = Float(fahr)
        
        redView.alpha = CGFloat((kelvin-KELVIN_MIN)/(KELVIN_MAX-KELVIN_MIN))
    }
}
