//
//  ArticleTableViewCell.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 24.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

class ArticleTableViewCell: UITableViewCell, Reusable {

    var article: Article?
    static let identifier = "ArticleTableViewCell"
    
    
    
    @IBOutlet weak var titleLabel: UILabel!{
        didSet{
            titleLabel.textColor = .black
        }
    }
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addedByLabel: UILabel!
    @IBOutlet weak var bottomView: UIView! {
        didSet {
            bottomView.isHidden = true
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    func setupCell(_ a: Article) {
        
        self.article = a
        
        guard let name = article?.name else {
            return
        }
        guard let category = article?.category else {
            return
        }
        guard let count = article?.count else {
            return
        }
        // Set Labels
        self.titleLabel.text = name
        
        self.countLabel.text = count + "x"
        self.countLabel.textColor = .lightGray
        
        self.categoryLabel.text = category
        self.categoryLabel.textColor = .lightGray
        
    }
 
    public static func nib() -> UINib? {
        return UINib(nibName: reuseIdentifier, bundle: nil)
    }

}
