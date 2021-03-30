//
//  Validation.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 17.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

class Validation: NSObject {
    
    func checkIfEveryNeededValueIsEntered(textField: UITextField) -> Bool{
        if textField.text != "" {
            return true
        } else {
            return false
        }
    
    }
}
