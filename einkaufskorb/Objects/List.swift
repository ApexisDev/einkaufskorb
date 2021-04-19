//
//  List.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 28.09.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

class List: NSObject {
    var id: String = ""
    var title: String = ""
    var owner: String = ""
    var date: String = ""
    var place: String = ""
    var status: String = ""
    var sharedWith: [String] = []
}
