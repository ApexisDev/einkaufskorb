//
//  MyListsTableViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 19.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

class MyListsTableViewController: UITableViewController {
    
    static let identifier = "TableViewController"
    var lists:[List] = [List]()
    var listsDict:[String: [List]] = [:]
    var status = ["notCompleted", "completed"]
    var dataOperations: DatabaseOperations?
    var selectedRowIndex: NSIndexPath = NSIndexPath(row: -1, section: 0)
 
    @IBOutlet weak var myShoppingListTableView: UITableView!
    @IBOutlet weak var myShoppingListsLabel: UILabel!{
        didSet{
            myShoppingListsLabel.textAlignment = .center
            myShoppingListsLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
            myShoppingListsLabel.text = "My Shopping Lists"
        }
    }
    @IBOutlet weak var createNewListButton: UIButton!{
        didSet{
            createNewListButton.tintColor = .black
        }
    }
    @IBOutlet weak var createListButton: UIBarButtonItem!{
        didSet{
            createListButton.title = ""
        }
    }
    // Show create List tab
    @IBAction func didTapButton(){
        guard let createListViewController = storyboard?.instantiateViewController(identifier: CreateShoppingListViewController.identifier) as? CreateShoppingListViewController else {
            return
        }
        createListViewController.title = "Create New Shopping List"
        navigationController?.pushViewController(createListViewController, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(ShoppingListCell.self)
        dataOperations = DatabaseOperations()
        dataOperations?.registerListener()
        dataOperations?.delegate = self
    }
    
    // Tap on Cell
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articlesTableViewController = storyboard?.instantiateViewController(identifier: ArticleTableViewController.identifier) as? ArticleTableViewController else {
            return
        }
        // TODO: Liste aus Dictionary holen
        
        switch indexPath.section {
        case 0:
            let currentList = self.listsDict["notCompleted"]?[indexPath.row]
            articlesTableViewController.title = currentList?.title
            articlesTableViewController.list = currentList
            self.navigationController?.pushViewController(articlesTableViewController, animated: true)
        default:
            let currentList = self.listsDict["completed"]?[indexPath.row]
            articlesTableViewController.title = currentList?.title
            articlesTableViewController.list = currentList
            self.navigationController?.pushViewController(articlesTableViewController, animated: true)
        }
    }
    // Table cell height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == selectedRowIndex.row {
            return 100
        }
        return 70
    }
    // Number of Displayed Lists
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return listsDict["notCompleted"]?.count ?? 0
        default:
            return listsDict["completed"]?.count ?? 0
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ShoppingListCell.self, for: indexPath)
        
        var values: [List] = []
        switch indexPath.section {
        case 0:
            values = listsDict["notCompleted"] ?? []
        default:
            values = listsDict["completed"] ?? []
        }
        
        // Customize the cell so it shows all important data
        cell.setCell(values[indexPath.row])
        return cell
    }
    
    // MARK: Swipe Gestures
    // Function to delete cells
    private func delete(indexPath: IndexPath) {
        
        let documentID = lists[indexPath.row].id
        print(documentID)
        //DatabaseOperations().deleteList(id: documentID)
    }
    // Function to edit cells
    private func edit(indexPath: IndexPath) {
        self.transitionToEditListView(indexPath: indexPath.row)
    }
    
    private func putListBackOnNotCompleted(indexPath: IndexPath){
        let documentID = lists[indexPath.row].id
        DatabaseOperations().updateListStatus(documentID: documentID, newStatus: "notCompleted")
    }
    // Swipe left
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteListAction = UIContextualAction(style: .normal,
                                                      title: "") { [weak self] (action, view, completionHandler) in
            self?.delete(indexPath: indexPath)
                                                          completionHandler(true)
        }
        deleteListAction.image = UIImage(systemName: "trash.fill")
        deleteListAction.backgroundColor = .systemRed
        return UISwipeActionsConfiguration(actions: [deleteListAction])
    }
    // Swipe right
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if(indexPath.section == 0) {
            let editListAction = UIContextualAction(style: .normal,
                                                          title: "") { [weak self] (action, view, completionHandler) in
                self?.edit(indexPath: indexPath)
                completionHandler(true)
            }
            editListAction.image = UIImage(systemName: "pencil")
            editListAction.backgroundColor = .systemGray
            return UISwipeActionsConfiguration(actions: [editListAction])
        } else {
            let putListBackOnNotCompletedAction = UIContextualAction(style: .normal,
                                                                     title: "") { [weak self] (action, view, completionHandler) in
                           self?.putListBackOnNotCompleted(indexPath: indexPath)
                           completionHandler(true)
            }
            putListBackOnNotCompletedAction.image = UIImage(systemName: "text.badge.xmark")
            putListBackOnNotCompletedAction.backgroundColor = .systemGray
            return UISwipeActionsConfiguration(actions: [putListBackOnNotCompletedAction])
        }
        
        
    }
    // Display Editing List View
    func transitionToEditListView(indexPath: Int){
        guard let editViewController = storyboard?.instantiateViewController(identifier: EditListViewController.identifier) as? EditListViewController else {
            return
        }
        let listName : String = self.lists[indexPath].title
        editViewController.title = "Edit " + listName
        editViewController.listIdentifier = self.lists[indexPath].id
        editViewController.currentListNumber = indexPath
        editViewController.list = self.lists[indexPath]
        navigationController?.pushViewController(editViewController, animated: true)
    }
    // MARK: Sections
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listsDict.count
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Not Completed" : "Completed"
    }
    
}

// MARK: Extension
extension MyListsTableViewController: DatabaseOperationsDelegate {
    func updateData(lists: [List]) {
        self.lists = lists
        
        listsDict["notCompleted"] = lists.filter{$0.status == "notCompleted"}
        listsDict["completed"] = lists.filter{$0.status == "completed"}

        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    func updateArticles(articles: [Article]) {
        
    }
}
