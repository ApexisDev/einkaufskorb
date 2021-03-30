//
//  MyShoppingListsTableView.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 28.09.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

class MyShoppingListsTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var lists = [List]()
    
    private func delete(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .destructive, title: "Delete") {
        [weak self] (_, _, _)
            in guard let self = self else {
                return }
            DatabaseOperations().delete(id: self.lists[indexPath.row].id)
            self.lists.remove(at: indexPath.row)
            self.deleteRows(at: [indexPath], with: .automatic)
            self.numberOfRows(inSection: self.lists.count)
            self.reloadData()
        }
        return action
        
    }
    private func edit(rowIndexPathAt indexPath: IndexPath) -> UIContextualAction {
        let action = UIContextualAction(style: .normal, title: "Edit") {
            [weak self](_, _, _) in
            // TODO: Add function
           }
        return action
    }
    
    override func numberOfRows(inSection section: Int) -> Int {
        return lists.count
    }
    override func cellForRow(at indexPath: IndexPath) -> UITableViewCell? {
        let cell = dequeueReusableCell(ShoppingListCell.self, for: indexPath)

        // Customize the cell so it shows all important data
        cell.setCell(lists[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = self.delete(rowIndexPathAt: indexPath)
        let swipe =  UISwipeActionsConfiguration(actions: [delete])
        return swipe
    }
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let edit = self.edit(rowIndexPathAt: indexPath)
        let swipe = UISwipeActionsConfiguration(actions: [edit])
        return swipe
    }
    
}
