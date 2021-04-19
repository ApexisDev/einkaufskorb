//
//  CreateShoppingListViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 17.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class CreateShoppingListViewController: UIViewController {

    static let identifier = "createNewShoppingList"
    @IBOutlet weak var headerLabel: UILabel! {
        didSet{
            headerLabel.text = "Create Shopping List"
        }
    }
    @IBOutlet weak var shoppingListNameLabel: UILabel!{
        didSet{
            shoppingListNameLabel.text = "Name*"
        }
    }
    @IBOutlet weak var shoppingListTextField: UITextField!{
        didSet{
            shoppingListTextField.placeholder = "Name of the list"
        }
    }
    @IBOutlet weak var shoppingDateLabel: UILabel!{
        didSet{
            shoppingDateLabel.text = "Date"
        }
    }
    
    @IBOutlet weak var ShoppingPlaceLabel: UILabel!{
        didSet{
            ShoppingPlaceLabel.text = "Place*"
        }
    }
    @IBOutlet weak var ShoppingPlaceTextField: UITextField!{
        didSet{
            ShoppingPlaceTextField.placeholder = "Store"
        }
    }
    
    @IBOutlet weak var shoppingListDatePicker: UIDatePicker!{
        didSet{
            shoppingListDatePicker.minimumDate = Date()
        }
    }
    
    @IBOutlet weak var createListButton: UIButton!{
        didSet{
            createListButton.setTitle("Create List", for: .normal)
        }
    }
    @IBOutlet weak var errorLabel: UILabel!{
        didSet{
            errorLabel.text = "*Required"
            errorLabel.textColor = .black
        }
    }
    
    var nameEntered = false
    var placeEntered = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(createListAndClose))
        
        // Do any additional setup after loading the view.
    }
    
    @objc func createListAndClose() {
        let validator = Validation()
        let db = DatabaseOperations()
        
        if validator.checkIfEveryNeededValueIsEntered(textField: shoppingListTextField) && validator.checkIfEveryNeededValueIsEntered(textField: ShoppingPlaceTextField){
            db.createList(data: collectData())
            
            navigationController?.popToRootViewController(animated: true)
        } else {
            if !validator.checkIfEveryNeededValueIsEntered(textField: shoppingListTextField) || !validator.checkIfEveryNeededValueIsEntered(textField: ShoppingPlaceTextField){
                
                if !validator.checkIfEveryNeededValueIsEntered(textField: shoppingListTextField) {
                    nameNotEntered()
                }
                if !validator.checkIfEveryNeededValueIsEntered(textField: ShoppingPlaceTextField) {
                    placeNotEntered()
                }
                errorLabel.textColor = .red
            }
        }
    }
    func collectData()->[String : Any]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let name = shoppingListTextField.text ?? ""
        let place = ShoppingPlaceTextField.text ?? ""
        let date = dateFormatter.string(from:shoppingListDatePicker.date)
        
        let data = ["date": date, "id": UUID().uuidString, "location": place, "owner": Auth.auth().currentUser?.uid ?? "", "title": name, "status": "notCompleted", "sharedWith": []] as [String : Any]
        
        return data
    }
    func placeNotEntered(){
        ShoppingPlaceLabel.textColor = .red
    }
    func nameNotEntered(){
        shoppingListNameLabel.textColor = .red
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    }


