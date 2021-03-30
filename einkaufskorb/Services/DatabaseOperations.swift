//
//  DatabaseOperations.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 17.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

protocol DatabaseOperationsDelegate: class {
    func updateData(lists: [List])
    func updateArticles(articles: [Article])
}

class DatabaseOperations: NSObject {
    weak var articleDelegate: DatabaseOperationsDelegate? {
        didSet{
            articleDelegate?.updateArticles(articles: [])
        }
    }
    weak var delegate: DatabaseOperationsDelegate? {
        didSet{
            delegate?.updateData(lists: [])
        }
    }
    
    let db = Firestore.firestore()
    let auth = Auth.auth()
    var lists = [List]()
    var articles = [Article]()
    
    // Create Document to Display Article Data
    func createArticle(data: [String: Any], documentID: String?){
        guard let articleID: String = data["id"] as? String else {
            print("Error @articleID")
            return
        }
        guard let documentID: String = documentID else {
            print ("Error LdocumentID")
            return
        }
        
        db.collection("lists").document(documentID).collection("articles")
            .addDocument(data: data){error in
                if error != nil {
                    print("Error creating article")
                }
            }
            /*
        db.collection("lists").document(documentID).collection("articles").document(articleID)
            .setData(data){error in
                if error != nil {
                    print ("Error creating article")
                }
                print ("Article successfully created")
            }
 */
    }
    
    func createList(data: [String: Any]) {
        
        guard let id: String = data["id"] as? String else {
            return
        }
        db.collection("lists").document(id).setData(data){error in
            if error != nil {
                print("Error creating list")
            }
        }
        
    }
    func update() {
        db.collection("lists")
            .addSnapshotListener{ documentSnapshot, error in
                guard documentSnapshot != nil else {
                    print("Error fetching document: \(error!)")
                    return
                }
            }
    
    }
    func registerListener() {
        guard let authID = auth.currentUser?.uid else {
            self.lists.removeAll()
            self.delegate?.updateData(lists: lists)
            return
        }
        
        db.collection("lists").whereField("owner", isEqualTo: authID)
            .addSnapshotListener{ documentSnapshot, error in
                self.lists.removeAll()
                guard error == nil else {
                    print("Error getting documents: \(error?.localizedDescription ?? "Error")")
                    self.delegate?.updateData(lists: self.lists)
                    return
                }
                for document in documentSnapshot?.documents ?? [] {
                    let list = List()
                    list.id = document.documentID
                    list.title = document.get("title") as? String ?? ""
                    list.date = document.get("date") as? String ?? ""
                    list.place = document.get("location") as? String ?? ""
                    self.lists.append(list)
                }
                self.delegate?.updateData(lists: self.lists)
            }
    }
    func registerArticleListeer(documentID: String){
        db.collection("lists").document(documentID).collection("articles")
            
            .addSnapshotListener{ DocumentSnapshot, error in
                self.articles.removeAll()
                guard error == nil else {
                    print("Error getting articles: \(error?.localizedDescription ?? "Error")")
                    self.articleDelegate?.updateArticles(articles: self.articles)
                    return
                }
                for document in DocumentSnapshot?.documents ?? [] {
                    let article = Article()
                    article.id = document.documentID
                    article.name = document.get("name") as? String ?? ""
                    article.count = document.get("count") as? String ?? ""
                    article.price = document.get("price") as? String ?? ""
                    article.category = document.get("category") as? String ?? ""
                    self.articles.append(article)
                }
                self.articleDelegate?.updateArticles(articles: self.articles)
            }
    }
    
    func delete(id: String){
        db.collection("lists").document(id)
            .delete()
    }
}
