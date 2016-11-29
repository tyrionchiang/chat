//
//  ViewController.swift
//  chat
//
//  Created by Chiang Chuan on 24/11/2016.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit

class messagesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
    }
    
    func handleLogout(){
        
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }

 

}

