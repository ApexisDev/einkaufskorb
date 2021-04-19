//
//  ArticlesTableViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 23.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

/*
enum ListState: String {
    case list = "onList"
    case cart = "inCart"
    
    static func fromString(state: String) -> ListState {
        switch state {
        case "onState":
            return list
        default:
            return cart
        }
    }
}
*/

class ArticleTableViewController: UITableViewController {

    static let identifier: String = "ArticleTableViewController"
    var list: List?
    
    var articles: [Article] = []
    var articlesDict: [String: [Article]] = [:]

    
    
    private var dataOperations: DatabaseOperations?
    var selectedRowIndex: NSIndexPath = NSIndexPath(row: -1, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if list?.status != "completed" {
            setupNavigationBar()
        }
        
        dataOperations = DatabaseOperations()
        dataOperations?.registerArticleListeer(documentID: list?.id ?? "")
        dataOperations?.articleDelegate = self
        
        self.tableView.register(ArticleTableViewCell.self)
    }
    
    // MARK: Navigation Bar
    @objc func createArticleButtonTapped(){
        guard let createArticleViewController = storyboard?.instantiateViewController(identifier: CreateArticleViewController.identifier) as? CreateArticleViewController else {
            return
        }
        createArticleViewController.title = "New Article"
        createArticleViewController.list = self.list
        navigationController?.pushViewController(createArticleViewController, animated: true)
    }
    
    private func setupNavigationBar(){
        
        let createArticleButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle"), style: .done, target: self, action: #selector(createArticleButtonTapped))
        
        let completePurchaseButton = UIBarButtonItem(image: UIImage(systemName: "text.badge.checkmark"), style: .done, target: self, action: #selector(onCompletePurchaseButtonTapped))
        
        navigationItem.rightBarButtonItems = [createArticleButton, completePurchaseButton]
    }

    // MARK: - Table view data source
    
    // Table cell height
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        /*
        if indexPath.row == selectedRowIndex.row {
            return 150
        }
 */
        return 200
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return articlesDict["onList"]?.count ?? 0
        default:
            return articlesDict["inCart"]?.count ?? 0
        }
    }
    
    // MARK: Sections
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return articlesDict.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "Shopping List" : "Shopping Cart"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ArticleTableViewCell.self, for: indexPath)
        
        var values: [Article] = []
        switch indexPath.section {
        case 0:
            values = articlesDict["onList"] ?? []
        default:
            values = articlesDict["inCart"] ?? []
        }
        
        // Customize the cell so it shows all important data
        cell.setupCell(values[indexPath.row])
        return cell
    }
    
    // MARK: Swipe Gestures

    override func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        if indexPath.section == 0 {
            let addToCartAction = UIContextualAction(style: .normal,
                                            title: "Add to Cart") { [weak self] (action, view, completionHandler) in
                                                self?.handleAddToCart(indexPath: indexPath)
                                                completionHandler(true)
            }
            
            addToCartAction.backgroundColor = .systemGreen
            addToCartAction.image = UIImage(systemName: "cart.fill.badge.plus")
            return UISwipeActionsConfiguration(actions: [addToCartAction])
        } else {
            let putBackOnListAction = UIContextualAction(style: .normal, title: "Put Back on List") { [weak self]( action, view, completionHandler) in
                self?.handlePutBackOnList(indexPath: indexPath)
                completionHandler(true)
            }
            putBackOnListAction.backgroundColor = .systemGray2
            putBackOnListAction.image = UIImage(systemName: "text.insert")
            return UISwipeActionsConfiguration(actions: [putBackOnListAction])
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView,
                       trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteFromListAction = UIContextualAction(style: .normal,
                                                      title: "Delete from List") { [weak self] (action, view, completionHandler) in
                                                          self?.handleRemoveFromShoppingList(indexPath: indexPath)
                                                          completionHandler(true)
        }
        deleteFromListAction.image = UIImage(systemName: "trash.fill")
        deleteFromListAction.backgroundColor = .systemRed
        
        return UISwipeActionsConfiguration(actions: [deleteFromListAction])
        
    }
    
    private func handlePutBackOnList(indexPath: IndexPath) {
        guard let documentID = list?.id,
              let articleID = articlesDict["inCart"]?[indexPath.row].id else {
            return
        }
        dataOperations?.updateStatus(documentID: documentID, articleID: articleID, newStatus: "onList")
        print("Put Item back on list")
    }
    
    private func handleAddToCart(indexPath: IndexPath) {
        guard let documentID = list?.id,
              let articleID = articlesDict["onList"]?[indexPath.row].id else {
            return
        }

        dataOperations?.updateStatus(documentID: documentID, articleID: articleID, newStatus: "inCart")
        print("Add to Cart")
    }
    
    private func handleRemoveFromShoppingList(indexPath: IndexPath) {
        guard let documentID = list?.id else { return }
        var articleID: String?
        switch indexPath.section {
        case 0:
            articleID = articlesDict["onList"]?[indexPath.row].id
        default:
            articleID = articlesDict["inCart"]?[indexPath.row].id
        }
        
        guard let mArticleID = articleID else { return }
        
        dataOperations?.deleteArticle(documentID: documentID, articleId: mArticleID)
    }
    
    @objc func onCompletePurchaseButtonTapped() {

        guard let documentID = list?.id else { return }
        dataOperations?.updateListStatus(documentID: documentID, newStatus: "completed")
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.list = nil
        
    }
    
}

extension ArticleTableViewController: DatabaseOperationsDelegate {
    
    func updateData(lists: [List]) {
    }
    
    func updateArticles(articles: [Article]) {
        self.articles = articles
        
        articlesDict["onList"] = articles.filter { $0.status == "onList" }
        articlesDict["inCart"] = articles.filter { $0.status == "inCart" }

        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

