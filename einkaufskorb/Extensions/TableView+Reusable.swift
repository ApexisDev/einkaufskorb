//
//  TableView+Reusable.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 18.11.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit

extension UITableView {

    func register<T: UITableViewCell>(_: T.Type) where T: Reusable {
        if let nib = T.nib() {
            self.register(nib, forCellReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableCell<T: UITableViewCell>(_: T.Type, for indexPath: IndexPath) -> T where T: Reusable {
        guard let cell = self.dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("\(T.reuseIdentifier) is not a \(String(describing: T.self))")
        }
        return cell
    }

    func register<T: UITableViewHeaderFooterView>(headerFooterView: T.Type) where T: Reusable {
        if let nib = T.nib() {
            self.register(nib, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        } else {
            self.register(T.self, forHeaderFooterViewReuseIdentifier: T.reuseIdentifier)
        }
    }

    func dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(_: T.Type) -> T where T: Reusable {
        guard let cell = self.dequeueReusableHeaderFooterView(withIdentifier: T.reuseIdentifier) as? T else {
            fatalError("\(T.reuseIdentifier) is not a \(String(describing: T.self))")
        }
        return cell
    }

}

