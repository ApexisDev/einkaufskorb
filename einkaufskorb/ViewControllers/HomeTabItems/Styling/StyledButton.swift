//
//  StyledButton.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 09.04.21.
//  Copyright © 2021 Jan Weßeling. All rights reserved.
//

import Foundation
import UIKit

class StyledButton: UIButton {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupDefaults()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.setupDefaults()
    }

    func setupDefaults() {
        self.contentEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray.cgColor
        self.layer.cornerRadius = 10
    }

}
