//
//  CreateArticleViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 23.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

class CreateArticleViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate{
    static let identifier = "CreateArticleViewController"
    var list: List?
    let categorys = ["-- Bitte auswählen --","Gemüse", "Obst", "Milchprodukte", "Backwaren", "Fleisch", "Fisch", "Aufstrich", "Getränke", "Süßigkeiten", "Sonstiges"]
    var valueSelected: String?

    @IBOutlet weak var nameLabel: UILabel!{
        didSet {
            nameLabel.text = "Name*"
        }
    }
    @IBOutlet weak var nameTextField: UITextField!{
        didSet {
            nameTextField.placeholder = "Name of the Product"
        }
    }
    
    @IBOutlet weak var countLabel: UILabel! {
        didSet {
            countLabel.text = "Count*"
        }
    }
    @IBOutlet weak var countTextField: UITextField!{
        didSet{
            countTextField.placeholder = "Number of Articles"
        }
    }
    
    @IBOutlet weak var categoryLabel: UILabel!{
        didSet{
            categoryLabel.text = "Category*"
        }
    }
    @IBOutlet weak var categoryPicker: UIPickerView!{
        didSet{
            categoryPicker.dataSource = self
            categoryPicker.delegate = self
        }
    }
    @IBOutlet weak var errorLabel: UILabel!{
        didSet{
            errorLabel.text = "*Required"
        }
    }
    
    @objc func saveButtonTapped(){
        saveChanges()
        //navigationController?.popViewController(animated: true)
        //navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
    
        // Do any additional setup after loading the view.
    }
    
    func saveChanges(){
        let validator = Validation()
        let db = DatabaseOperations()
        
        guard let documentID = list?.id else {
            return
        }
        if valueSelected != nil &&
            validator.checkIfEveryNeededValueIsEntered(textField: nameTextField) && validator.checkIfEveryNeededValueIsEntered(textField: countTextField){
            db.createArticle(data: collectData(), documentID: documentID)
            
            navigationController?.popViewController(animated: true)
        } else {
            if  !validator.checkIfEveryNeededValueIsEntered(textField: nameTextField) || !validator.checkIfEveryNeededValueIsEntered(textField: nameTextField)
                || valueSelected == nil{
                
                if !validator.checkIfEveryNeededValueIsEntered(textField: nameTextField) {
                    nameNotEntered()
                }
                if !validator.checkIfEveryNeededValueIsEntered(textField: countTextField) {
                    countNotEntered()
                }
                if valueSelected == nil {
                    valueNotSelected()
                }
                errorLabel.textColor = .red
            }
        }
    }
    func collectData()->[String: Any]{
        let title = nameTextField.text ?? ""
        let count = countTextField.text ?? ""
        
        let category = valueSelected
        let data = ["id": UUID().uuidString, "name": title, "count": count, "category": category ?? "", "status": "onList"] as [String: Any]
        
        return data
    }
    func nameNotEntered(){
        nameLabel.textColor = .red
    }
    func countNotEntered(){
        countLabel.textColor = .red
    }
    func valueNotSelected() {
        categoryLabel.textColor = .red
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categorys[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categorys.count
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if(categorys[row] == categorys[0]) {
            valueSelected = nil
        } else {
            valueSelected = categorys[row] as String
        }
        
        
        
    }
}

