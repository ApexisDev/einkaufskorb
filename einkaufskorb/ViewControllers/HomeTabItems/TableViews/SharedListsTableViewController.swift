//
//  item1.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 19.09.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import Foundation
import UIKit

class SharedListsTableViewController:  UITableViewController{
    
    static let identifier = "SharedLists"
    private var lists:[List] = [List]()
    private var listsDict: [String: [List]] = [:]
    private var db: DatabaseOperations?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(SharedShoppingListCell.self)
        db = DatabaseOperations()
        db?.registerSharedListsListener()
        db?.delegate = self
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return listsDict.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 120
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Not Completed" : "Completed"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section{
        case 0:
            return listsDict["notCompleted"]?.count ?? 0
        default:
            return listsDict["completed"]?.count ?? 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(SharedShoppingListCell.self, for: indexPath)
        var values: [List] = []
        
        switch indexPath.section {
        case 0:
            values = listsDict["notCompleted"] ?? []
        default:
            values = listsDict["completed"] ?? []
        }
        cell.setupCell(values[indexPath.row])
        return cell
    }
    
    
}
// MARK: Extension
extension SharedListsTableViewController: DatabaseOperationsDelegate {
    func updateData(lists: [List]) {
        self.lists = lists

        listsDict["notCompleted"] = lists.filter{$0.status == "notCompleted"}
        listsDict["completed"] = lists.filter{$0.status == "completed"}

        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
        print("db list added")
    }
    func updateArticles(articles: [Article]) {

    }
}
