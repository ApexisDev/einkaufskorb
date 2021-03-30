//
//  Utilities.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 02.07.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import Foundation
class Utilities {
    
    // Check if passwort is minimum 8 characters long, and contains 1 special character, 1 number, a letter
    static func isPasswordValid(_ password : String) -> Bool {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
        return passwordTest.evaluate(with: password)
    }
}

 
