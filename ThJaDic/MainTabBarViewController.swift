//
//  MainTabBarViewController.swift
//  ThJaDic
//
//  Created by 江藤太一郎 on 2019/02/23.
//  Copyright © 2019 Taichiro Etoh. All rights reserved.
//

import Foundation
import UIKit

final class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewSearch = SearchViewController()
        viewSearch.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 1)
        let naviSearch = UINavigationController(rootViewController: viewSearch)
        
        let viewBookMark = BookMarkViewController()
        viewBookMark.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        let naviBookMark = UINavigationController(rootViewController: viewBookMark)
        
        setViewControllers([naviSearch, naviBookMark], animated: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
