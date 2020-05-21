//
//  SearchViewController.swift
//  BookEat
//
//  Created by Thomas Samy on 28/04/2020.
//  Copyright © 2020 Thomas Samy. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func add(_ sender: UIButton) {
        guard var viewControllers = self.tabBarController?.viewControllers else { return }
        let centerVC = self.storyboard!.instantiateViewController(withIdentifier: "AccountVC") as! AccountViewController
        viewControllers.append(centerVC)
        self.tabBarController?.viewControllers = viewControllers
    }
    
    @IBAction func test(_ sender: UIButton) {
        guard var viewControllers = self.tabBarController?.viewControllers else { return }
        viewControllers.removeLast()
        self.tabBarController?.viewControllers = viewControllers
    }
    


}
