//
//  ColorHelper.swift
//  BW4MortgageCalculator
//
//  Created by Clayton Watkins on 10/20/20.
//

import UIKit

class ColorsHelper {
    // Color palette
    static let DarkSlateGreen: UIColor = UIColor(red: 56, green: 77, blue: 72)
    static let Nickel: UIColor = UIColor(red: 110, green: 114, blue: 113)
    static let LaurelGreen: UIColor = UIColor(red: 172, green: 173, blue: 148)
    static let LightGrey: UIColor = UIColor(red: 216, green: 212, blue: 213)
    static let Platinum: UIColor = UIColor(red: 226, green: 226, blue: 226)
}

// Extension on UIColor in order to give easier color codes
extension UIColor {
    
   convenience init(red: Int, green: Int, blue: Int) {
       assert(red >= 0 && red <= 255, "Invalid red component")
       assert(green >= 0 && green <= 255, "Invalid green component")
       assert(blue >= 0 && blue <= 255, "Invalid blue component")

       self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
   }

   convenience init(rgb: Int) {
       self.init(
           red: (rgb >> 16) & 0xFF,
           green: (rgb >> 8) & 0xFF,
           blue: rgb & 0xFF
       )
   }
    
}
