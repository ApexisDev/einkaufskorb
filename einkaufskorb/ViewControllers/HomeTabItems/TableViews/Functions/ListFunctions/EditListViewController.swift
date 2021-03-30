//
//  EditListViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 20.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit
import Foundation
import FirebaseAuth

class EditListViewController: UIViewController {
    
    static let identifier = "EditListViewController"
    var listIdentifier: String?
    var currentListNumber: Int?
    var list: List?
    
    @IBOutlet weak var listNameLabel: UILabel!{
        didSet {
            listNameLabel.text = "List Name"
        }
    }
    @IBOutlet weak var listNameTextField: UITextField!
    
    @IBOutlet weak var listPlaceLabel: UILabel!{
        didSet {
            listPlaceLabel.text = "Shopping Place"
        }
    }
    @IBOutlet weak var listPlaceTextField: UITextField!
    
    @IBOutlet weak var shoppingDateLabel: UILabel!{
        didSet {
            shoppingDateLabel.text = "Shopping Date"
        }
    }
    @IBOutlet weak var shoppingDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setupSaveButton()
        // Do any additional setup after loading the view.
    }
    @objc func saveButtonTapped(){
        saveChanges()
        navigationController?.popToRootViewController(animated: true)
    }
    
    // Set up upper right save button
    func setupSaveButton(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonTapped))
    }
    
    // Save changes
    func saveChanges() {
        let db = DatabaseOperations()
        
        db.createList(data: collectData())
    }
    
    func collectData() ->[String : Any]{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let name = listNameTextField.text ?? ""
        let place = listPlaceTextField.text ?? ""
        let date = dateFormatter.string(from:shoppingDatePicker.date)
        
        let data = ["date": date, "id": list?.id ?? "", "location": place, "owner": Auth.auth().currentUser?.uid ?? "", "title": name] as [String : Any]
        return data
    }
    
    // Display Data of List in Textfields
    func displayData(){
        // String to Date
        guard let isoDate = list?.date else { return }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "DD.MM.yyyy HH:mm"
        dateFormatter.locale = Locale.current
        guard let date = dateFormatter.date(from: isoDate) else {
            print ("Error getting date")
            return
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let finalDate = calendar.date(from: components)
        
        // Set all important data
        shoppingDatePicker.date = finalDate!
        listNameTextField.text = list?.title
        listPlaceTextField.text = list?.place
        
        
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
