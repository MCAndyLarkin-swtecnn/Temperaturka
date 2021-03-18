//
//  RGBExtensions.swift
//  firstEntry
//
//  Created by user on 18.03.2021.
//

import UIKit

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
extension Int{
    func fromRBG() -> UIColor {
        return UIColor.fromRgb(rgb: self)
    }
}
