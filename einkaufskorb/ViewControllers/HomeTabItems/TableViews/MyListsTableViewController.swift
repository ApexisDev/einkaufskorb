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
        let currentList = indexPath.row
        let listName : String = self.lists[currentList].title
        articlesTableViewController.title = listName
        articlesTableViewController.list = self.lists[currentList]
        self.navigationController?.pushViewController(articlesTableViewController, animated: true)
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
        return lists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ShoppingListCell.self, for: indexPath)
        // Customize the cell so it shows all important data
        cell.setCell(lists[indexPath.row])
        return cell
    }
    // Function to delete cells
    private func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") {
        [weak self] (_, _, _)
            in guard let self = self else {
                return }
            DatabaseOperations().delete(id: self.lists[indexPath.row].id)
            self.lists.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            _ = self.tableView(self.tableView, numberOfRowsInSection: self.lists.count)
            self.tableView.reloadData()
        }
        return action
    }
    // Function to edit cells
    private func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") {
            [weak self](_, _, _) in
            guard let self = self else {
                return
            }
            self.transitionToEditListView(indexPath: indexPath.row)
        }
        return action
    }
    // Swipe left
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = self.delete(rowIndexPathAt: indexPath)
        let swipe =  UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    // Swipe right
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = self.edit(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [edit])
        return swipe
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
}
extension MyListsTableViewController: DatabaseOperationsDelegate {
    func updateData(lists: [List]) {
        self.lists = lists
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    func updateArticles(articles: [Article]) {
        
    }
}
