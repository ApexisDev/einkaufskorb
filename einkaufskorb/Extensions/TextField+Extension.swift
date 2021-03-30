//
//  TextField+Extension.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 26.06.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

extension UITextField {

    func underlined(){
        let textField = UITextField()
        let border = CALayer()
        let width = CGFloat(1.0)
        border.bounds = CGRect(x: 0, y: self.frame.size.height - 2, width:  self.frame.size.width, height: 2)
        border.borderColor = UIColor.from(hexString: "#afafaf").cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width:  self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        textField.borderStyle = .none
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
    }
    
}
