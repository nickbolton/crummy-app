//
//  UIColor+Utils.swift
//  Bedrock
//
//  Created by Nick Bolton on 7/25/16.
//  Copyright © 2016 Pixelbleed LLC. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int32, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex >> 16) & 0xFF)
        let green = CGFloat((hex >> 8) & 0xFF)
        let blue = CGFloat((hex) & 0xFF)
        
        self.init(red: red / 255.0, green: green / 255.0, blue: blue / 255.0, alpha: alpha)
    }
    
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        var colorString = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        
        if (colorString.length == 0 || colorString.length == 5 || colorString.length == 7) {
            self.init(red: CGFloat(0.0), green: CGFloat(0.0), blue: CGFloat(0.0), alpha: alpha)
            return
        } else if (colorString.length == 1 || colorString.length == 2) {
            colorString = "\(colorString)\(colorString)\(colorString)"
        }
        
        var red: CGFloat = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat = 0.0
        var alpha: CGFloat = 1.0
        
        switch (colorString.length) {
        case 3: // #RGB
            red   = UIColor.colorComponent(from: colorString, start: 0, length: 1)
            green = UIColor.colorComponent(from: colorString, start: 1, length: 1)
            blue  = UIColor.colorComponent(from: colorString, start: 2, length: 1)
            break;
        case 4: // #ARGB
            alpha = UIColor.colorComponent(from: colorString, start: 0, length: 1)
            red   = UIColor.colorComponent(from: colorString, start: 1, length: 1)
            green = UIColor.colorComponent(from: colorString, start: 2, length: 1)
            blue  = UIColor.colorComponent(from: colorString, start: 3, length: 1)
            break;
        case 6: // #RRGGBB
            red   = UIColor.colorComponent(from: colorString, start: 0, length: 2)
            green = UIColor.colorComponent(from: colorString, start: 2, length: 2)
            blue  = UIColor.colorComponent(from: colorString, start: 4, length: 2)
            break;
        case 8: // #AARRGGBB
            alpha = UIColor.colorComponent(from: colorString, start: 0, length: 2)
            red   = UIColor.colorComponent(from: colorString, start: 2, length: 2)
            green = UIColor.colorComponent(from: colorString, start: 4, length: 2)
            blue  = UIColor.colorComponent(from: colorString, start: 6, length: 2)
            break;
        default:
            break;
        }
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    private static func colorComponent(from: String, start: Int, length: Int) -> CGFloat {
        let range = from.index(from.startIndex, offsetBy: start)..<from.index(from.startIndex, offsetBy: start+length)
        let substring = from[range]
        let fullHex = length == 2 ? substring : "\(substring)\(substring)"
        var hexComponent: UInt32 = 0
        let scanner = Scanner(string: fullHex)
        scanner.scanHexInt32(&hexComponent)
        return CGFloat(hexComponent) / CGFloat(255.0)
    }
    
    func color(withAlpha alpha: CGFloat) -> UIColor {
        var red: CGFloat = 0.0;
        var blue: CGFloat = 0.0;
        var green: CGFloat = 0.0;
        
        getRed(&red, green: &green, blue: &blue, alpha: nil)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    static func random() -> UIColor {
        let red =  CGFloat(UInt32.random())/CGFloat(RAND_MAX)
        let blue =  CGFloat(UInt32.random())/CGFloat(RAND_MAX)
        let green =  CGFloat(UInt32.random())/CGFloat(RAND_MAX)
        return UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
    
    static func difference(start: UIColor, end: UIColor, percent: CGFloat) -> UIColor {
        
        let boundedPercent = min(max(percent, 0.0), 1.0)

        var sRed: CGFloat = 0.0;
        var sBlue: CGFloat = 0.0;
        var sGreen: CGFloat = 0.0;
        var sAlpha: CGFloat = 0.0;
        
        var eRed: CGFloat = 0.0;
        var eBlue: CGFloat = 0.0;
        var eGreen: CGFloat = 0.0;
        var eAlpha: CGFloat = 0.0;

        start.getRed(&sRed, green: &sGreen, blue: &sBlue, alpha: &sAlpha)
        end.getRed(&eRed, green: &eGreen, blue: &eBlue, alpha: &eAlpha)

//        let red = (((1.0 - boundedPercent) * sRed) + (boundedPercent * eRed)) / 2.0
//        let blue = (((1.0 - boundedPercent) * sBlue) + (boundedPercent * eBlue)) / 2.0
//        let green = (((1.0 - boundedPercent) * sGreen) + (boundedPercent * eGreen)) / 2.0
//        let alpha = (((1.0 - boundedPercent) * sAlpha) + (boundedPercent * eAlpha)) / 2.0
        let red = (((1.0 - boundedPercent) * sRed) + (boundedPercent * eRed)) / 2.0
        let blue = (((1.0 - boundedPercent) * sBlue) + (boundedPercent * eBlue)) / 2.0
        let green = (((1.0 - boundedPercent) * sGreen) + (boundedPercent * eGreen)) / 2.0
        let alpha = (((1.0 - boundedPercent) * sAlpha) + (boundedPercent * eAlpha)) / 2.0
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}
