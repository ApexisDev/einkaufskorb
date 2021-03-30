//
//  Reusable.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 18.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

protocol Reusable {
    static var reuseIdentifier: String { get }
    static func nib() -> UINib?
    static func view() -> UIView?
}

extension Reusable {
    static var reuseIdentifier: String {
        return String(describing: self)
    }

    static func nib() -> UINib? {
        return nil
    }

    static func view() -> UIView? {
        return nil
    }
}
