//
//  ShoppingListCell.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 01.10.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

class ShoppingListCell: UITableViewCell, Reusable {

    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellPlace: UILabel!
    @IBOutlet weak var cellDate: UILabel!
    
    var list: List?
    
    static let identifier = "ShoppingListCell"
    
    override func awakeFromNib() {
           super.awakeFromNib()
    }
    
    func setCell(_ l: List) {
        self.list = l
        
        // Set Labels
        self.cellTitle.text = list?.title
        self.cellDate.text = list?.date
        self.cellPlace.text = list?.place
    }
 
    public static func nib() -> UINib? {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
    
    /*
    public static func view() -> UIView? {
        return ShoppingListCell()
    }
    */
    
}
