//
//  Button+Extension.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 02.07.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

extension UIButton{
    
    func filled(_ button:UIButton) {
        //let button = UIButton()
        button.backgroundColor = UIColor.from(hexString: "#AFAFAF")
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.white
    }
    
    func hollow(_ button:UIButton) {
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.cornerRadius = 25.0
        button.tintColor = UIColor.black
    }

    @discardableResult
    func applyGradient(colours: [UIColor]) -> CAGradientLayer {
        return self.applyGradient(colours: colours, locations: nil)
    }

    @discardableResult
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
        }
    }
    

