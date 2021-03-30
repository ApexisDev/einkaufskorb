//
//  ListModel.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 28.09.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class ListModel: NSObject {

    
    var db:Firestore!
    var auth:Auth!
    
    func getLists(complition: @escaping ([List]) -> Void) {
        
        db = Firestore.firestore()
        auth = Auth.auth()
        
        var lists = [List]()

        guard let authID = auth.currentUser?.uid else {
            complition(lists)
            return
        }
        
        db.collection("lists").whereField("owner", isEqualTo: authID)
            .getDocuments() { (querySnapshot, err) in
                guard err == nil else {
                    print("Error getting documents: \(err)")
                    complition(lists)
                    return
                }
            
                for document in querySnapshot?.documents ?? [] {
                    let list = List()
                    list.id = document.documentID
                    list.title = document.get("title") as? String ?? ""
                    list.date = document.get("date") as? String ?? ""
                    list.place = document.get("location") as? String ?? ""
                    
                    lists.append(list)
                }
                
                complition(lists)
            }
    }
}


