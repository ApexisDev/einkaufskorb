//
//  Color+Extension.swift
//  catcher
//
//  Created by Felix Zardai on 22.02.20.
//  Copyright © 2020 Felix Zardai. All rights reserved.
//

import UIKit

extension UIColor {
    
    var hexString: String {
        if let colorRef = cgColor.components {
            let r: CGFloat = colorRef[0]
            let g: CGFloat = colorRef[1]
            let b: CGFloat = colorRef[2]
            return String(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        } else {
            return "#000000"
        }
    }
        
    static func from(hexString: String?) -> UIColor {
        if let hexString = hexString {
            var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
            
            if cString.hasPrefix("#") {
                cString.remove(at: cString.startIndex)
            }
            
            if (cString.count) != 6 {
                return UIColor.black
            }
            
            var rgbValue: UInt64 = 0
            Scanner(string: cString).scanHexInt64(&rgbValue)

            return UIColor(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
        } else {
            return UIColor.black
        }
    }
    
}
