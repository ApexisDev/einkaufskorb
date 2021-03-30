//
//  ArticlesTableViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 23.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

class ArticleTableViewController: UITableViewController {

    static let identifier: String = "ArticleTableViewController"
    var list: List?
    var articles:[Article] = [Article]()
    var dataOperations: DatabaseOperations?
    var selectedRowIndex: NSIndexPath = NSIndexPath(row: -1, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        tableView.register(ArticleTableViewCell.self)
        dataOperations = DatabaseOperations()
        dataOperations?.registerArticleListeer(documentID: list?.id ?? "")
        dataOperations?.articleDelegate = self
        
    }
    @objc func createArticleButtonTapped(){
        guard let createArticleViewController = storyboard?.instantiateViewController(identifier: CreateArticleViewController.identifier) as? CreateArticleViewController else {
            return
        }
        createArticleViewController.title = "New Article"
        createArticleViewController.list = self.list
        navigationController?.pushViewController(createArticleViewController, animated: true)
    
    }
    
    func setupNavigationBar(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Create Article", style: .done, target: self, action: #selector(createArticleButtonTapped))
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
        return articles.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(ArticleTableViewCell.self, for: indexPath)
        // Customize the cell so it shows all important data
        cell.setupCell(articles[indexPath.row])
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath) as? ArticleTableViewCell {
                UIView.animate(withDuration: 0.3) {
                    cell.bottomView.isHidden = !cell.bottomView.isHidden
                }
                tableView.beginUpdates()
                tableView.endUpdates()
                tableView.deselectRow(at: indexPath, animated: true)
            }
        }


    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension ArticleTableViewController: DatabaseOperationsDelegate {
    
    func updateData(lists: [List]) {
    }
    
    func updateArticles(articles: [Article]) {
        self.articles = articles
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

