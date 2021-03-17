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


    let CELSIUM_MAX: Double = 1000
    let CELSIUM_MIN: Double = -273.15
    lazy var FAHRENHEIT_MAX = Float(CELSIUM_MAX*9/5+32)
    lazy var FAHRENHEIT_MIN = Float(CELSIUM_MIN*9/5+32)
    lazy var KELVIN_MAX: Double = CELSIUM_MAX + 273.15
    lazy var KELVIN_MIN: Double = CELSIUM_MIN + 273.15
    
    var reflection :ReflectionTransition!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        celciumTextField.font = .systemFont(ofSize: 40)
        
        kelvinStepper.maximumValue = KELVIN_MAX
        kelvinStepper.minimumValue = KELVIN_MIN

        fahrenheitSlider.maximumValue = FAHRENHEIT_MAX
        fahrenheitSlider.minimumValue = FAHRENHEIT_MIN
        
        fahrenheitSlider.value = FAHRENHEIT_MIN
        kelvinStepper.value = KELVIN_MIN
        
        let blue = celciumTextField.textColor!.rgb()!
        let orange = /*orange*/4294939904
        
//        4294939904 - orange
//        4284139770 - blue
        reflection =
            ReflectionTransition(sourcePairOfLimits: (KELVIN_MIN, KELVIN_MAX), targetPairOfLimits: (Double( blue ), Double( orange )))
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
                
                applyNewColor(kelvin: kelvin)
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
        
        applyNewColor(kelvin: kelvin)
    }
    @IBAction func kelvinStepperDidPushed(_ sender: Any){
        let kelvin = round((kelvinStepper.value) * 100) / 100
        kelvinLabel.text = "\(kelvin) " + "K"
        
        let celsiumVal = kelvinStepper.value - 273.15
        celciumTextField.text = "\(round( celsiumVal * 100) / 100)"
        
        let fahr = celsiumVal*9/5 + 32
        fahrenheitLabel.text = "\(round( fahr * 100) / 100) ° of Fahrenheit"
        fahrenheitSlider.value = Float(fahr)
        
        applyNewColor(kelvin: kelvin)
    }
    func applyNewColor(kelvin: Double){
        if let color = reflection.getTargetValue(kelvin){
            view.backgroundColor = UIColor.fromRgb(rgb: Int(color))
            celciumTextField.textColor = UIColor.fromRgb(rgb: Int(color))
        }
    }
//    func iDebuq() {
//        print("Debug")
//        print(view.backgroundColor)
//        let rgb = view.backgroundColor!.rgb()!
//        print(rgb)
//        print(UIColor.fromRgb(rgb: rgb))
//    }

}
extension UIColor {

    func rgb() -> Int? {
        
        var fRed : CGFloat = 0
        var fGreen : CGFloat = 0
        var fBlue : CGFloat = 0
        var fAlpha: CGFloat = 0
        if self.getRed(&fRed, green: &fGreen, blue: &fBlue, alpha: &fAlpha) {
            let iRed = Int(fRed * 255.0)
            let iGreen = Int(fGreen * 255.0)
            let iBlue = Int(fBlue * 255.0)
            let iAlpha = Int(fAlpha * 255.0)

            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            let rgb = (iAlpha << 24) + (iRed << 16) + (iGreen << 8) + iBlue
            return rgb
        } else {
            // Could not extract RGBA components:
            return nil
        }
    }
    static func fromRgb(rgb: Int) -> UIColor{
        return UIColor(
            //  (Bits 24-31 are alpha, 16-23 are red, 8-15 are green, 0-7 are blue).
            displayP3Red: {
                return CGFloat(Float((rgb >> 16) - ((rgb >> 24) << 8)) / 255.0)
            }(),
            green: {
                return CGFloat(Float((rgb >> 8) - ((rgb >> 16) << 8)) / 255.0)
            }(),
            blue: {
                return CGFloat(Float(rgb - ((rgb >> 8) << 8)) / 255.0)
            }(),
            alpha: {
                return CGFloat(Float(rgb >> 24 ) / 255.0)
        
            }())
    }
}


class ReflectionTransition{
    private var sourceBase: Double
    private var targetBase: Double
    
    private var sourceDif: Double
    private var targetDif: Double
    
    public init(sourcePairOfLimits source: (min: Double, max: Double), targetPairOfLimits target: (min: Double, max: Double)){
        (sourceBase, sourceDif) = {
            let dif = source.max - source.min
            let base = min(source.max, source.min)
            return (base, dif)
        }()
        
        (targetBase, targetDif) = {
            let dif = target.max - target.min
            let base = min(target.max, target.min)
            return (base, dif)
        }()
    
    }
    public func getTargetValue(_ sourceValue: Double) -> Double?{
        let dif = sourceValue - sourceBase
        if dif > sourceDif || dif < 0{
            return nil
        }
        let koef = (sourceValue-sourceBase) / sourceDif
        return targetBase + koef * targetDif
    }
}
