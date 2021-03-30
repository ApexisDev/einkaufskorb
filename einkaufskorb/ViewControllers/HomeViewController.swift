//
//  HomeViewController.swift
//  einkaufskorb
//
//  Created by Jan Weßeling on 19.09.20.
//  Copyright © 2020 Jan Weßeling. All rights reserved.
//

import UIKit
import SwiftIcons

class HomeViewController: UITabBarController, UITabBarControllerDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        setupMiddleButton()
        setupLeftButton()
        setupRightButton()
    }
    
    // TabBarButtons
    // Setup Left Button
    func setupLeftButton() {
        let leftTabBarItem = (self.tabBar.items?[0])! as UITabBarItem?
        leftTabBarItem?.image = UIImage(named: "sharedShoppingListsIcon")?.withRenderingMode(.alwaysOriginal)
        leftTabBarItem?.title = ""
        leftTabBarItem?.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
    
    // Setup Right Button
    func setupRightButton() {
        let rightTabBarButton = (self.tabBar.items?[2])! as UITabBarItem?
        rightTabBarButton?.image = UIImage(named: "myShoppingListsIcon")?.withRenderingMode(.alwaysOriginal)
        rightTabBarButton?.title = ""
        rightTabBarButton?.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
    }
   
    // Setup Middle Button
    func setupMiddleButton() {
        let middleButton = UIButton(frame: CGRect(x: (0.5 * self.view.bounds.width) - 25, y: -20, width: 50, height: 50))
        middleButton.layer.cornerRadius = middleButton.bounds.size.width / 2
        middleButton.clipsToBounds = true;
        
        //style the button
        middleButton.setIcon(icon: .fontAwesomeSolid(.home), iconSize: 20.0, color: UIColor.white, backgroundColor: UIColor.white, forState: .normal)
        middleButton.applyGradient(colours: [UIColor.from(hexString: "#343d46"), UIColor.from(hexString: "4f5b66")]  )
        
        //add to the tabbar and add click event
        self.tabBar.addSubview(middleButton)
        middleButton.addTarget(self, action: #selector(self.menuButtonAction), for: .touchUpInside)

        self.view.layoutIfNeeded()
    }

    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 1
    }
}
