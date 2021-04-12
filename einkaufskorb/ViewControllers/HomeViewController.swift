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
    
    let tabbar = UITabBar()
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
    func setupLeftButton() {
        let leftTabBarItem = (self.tabBar.items?[0])! as UITabBarItem?
        leftTabBarItem?.image = UIImage(systemName: "person.2.square.stack")?.withRenderingMode(.alwaysOriginal)
        leftTabBarItem?.title = "Shared Lists"
    }
    
    func setupRightButton() {
        let rightTabBarButton = (self.tabBar.items?[2])! as UITabBarItem?
        rightTabBarButton?.image = UIImage(systemName: "list.bullet")?.withRenderingMode(.alwaysOriginal)
        rightTabBarButton?.title = "My Shopping Lists"
    }
   
    func setupMiddleButton() {
        let middleTabBarButton = (self.tabBar.items?[1])! as UITabBarItem?
        middleTabBarButton?.image = UIImage(systemName: "house")?.withRenderingMode(.alwaysOriginal)
        
        middleTabBarButton?.title = "Home"
    }

    // Menu Button Touch Action
    @objc func menuButtonAction(sender: UIButton) {
        self.selectedIndex = 1
    }
}
