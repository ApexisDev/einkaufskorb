//
//  SharedShoppingListCell.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 13.04.21.
//  Copyright © 2021 Jan Weßeling. All rights reserved.
//

import Foundation
import UIKit


class SharedShoppingListCell: UITableViewCell, Reusable {
    
    static let identifier = "SharedShoppingListTableViewCell"
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var placeLabel: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var sharedByLabel: UILabel!
    
    var list: List?{
        didSet{
            titleLabel.text = list?.title
            placeLabel.text = list?.place
            dateLabel.text = list?.date
            
            guard let createdBy = list?.owner else {
                return
            }
            let username = DatabaseOperations().getOwnerName(owner: list?.owner ?? "")
            sharedByLabel.text = "Geteilt von: " + createdBy
            
        }
    }
    
    func setupCell(_ l: List) {
        self.list = l
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public static func nib() -> UINib? {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }
}
