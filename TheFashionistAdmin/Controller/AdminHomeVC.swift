//
//  AdminHomeViewController.swift
//  TheFashionistAdmin
//
//  Created by Ozgur Hayat on 16/11/2020.
//

import UIKit

class AdminHomeVC: HomeVC {

        override func viewDidLoad() {
            super.viewDidLoad()
            
            navigationItem.leftBarButtonItem?.isEnabled = false
            
            let addCategoryBtn = UIBarButtonItem(title: "Add Category", style: .plain, target: self, action: #selector(addCategory))
            navigationItem.rightBarButtonItem = addCategoryBtn
        }
        
        @objc func addCategory() {
            performSegue(withIdentifier: Segues.ToAddEditCategory, sender: self)
        }
    }
