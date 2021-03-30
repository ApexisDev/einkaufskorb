//
//  ThirdItemViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 23.09.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit
import FirebaseFirestore

class ThirdItemViewController: UIViewController {

    
    @IBOutlet weak var createNewListButton: UIButton!{
        didSet {
            createNewListButton.tintColor = .black
        }
    }
    @IBOutlet weak var myShoppingListsTableView: UITableView!
    
    
    @IBOutlet weak var myShoppingListsLabel: UILabel!{
        didSet{
            myShoppingListsLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        }
    }
    @IBAction func onAddShoppingListButtonClicked(_ sender: Any) {
        
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.updateData(lists: lists)
        /*
        self.myShoppingListsTableView.estimatedRowHeight = 100
        self.myShoppingListsTableView.rowHeight = UITableView.automaticDimension
        self.myShoppingListsTableView.dataSource = self
        self.myShoppingListsTableView.delegate = self
        
        */
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    func transitionToCreateShoppingListView(){
        guard let createShoppingListController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "CreateShoppingList") as? CreateShoppingListViewController else { return }
        createShoppingListController.modalPresentationStyle = .fullScreen
        self.present(createShoppingListController, animated: true, completion: nil)
    }
 */
}

