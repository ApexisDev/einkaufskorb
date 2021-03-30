//
//  CategorysPickerView.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 23.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

class CategorysPickerView: UIPickerView{
    
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "test"//categorys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorys.count
    }

}
