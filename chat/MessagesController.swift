//
//  ViewController.swift
//  chat
//
//  Created by Chiang Chuan on 24/11/2016.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        for family: String in UIFont.familyNames
//        {
//            print("\(family)")
//            for names: String in UIFont.fontNames(forFamilyName: family)
//            {
//                print("== \(names)")
//            }
//        }
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout))
        
        let image = UIImage(named: "new_message_icon")
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(handleNewMessage))
        
        checkIfUserIsLoggedIn()

    }
    
    func handleNewMessage(){
        let newMessageController = NewMessageController()
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true, completion: nil)
    }
    
    
    
    func checkIfUserIsLoggedIn(){
        // user is not Logged in
        if FIRAuth.auth()?.currentUser?.uid == nil{
            performSelector(inBackground: #selector(handleLogout), with: nil)
        }else{
            fetchUserAndSetupNavBarTitle()
        }

    }
    
    func fetchUserAndSetupNavBarTitle(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else{
            //for some reason uid = nil
            return
        }
        FIRDatabase.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject]{
//                self.navigationItem.title = dictionary["name"] as? String
                
                
                let user = User()
                user.setValuesForKeys(dictionary)
                self.setupNavBarWithUser(user: user)
            }
            
            
        }, withCancel: nil)

    }
    
    func setupNavBarWithUser(user: User){
        
        let titleView = UIView()
        titleView.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
//        titleView.backgroundColor = UIColor.red
        
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(containerView)
        
        
        let profileImageView = UIImageView()
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.contentMode = .scaleAspectFill
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        
        if let profileImageUrl = user.profileImageUrl{
            profileImageView.loadImageUsingCacheWithUrlString(urlSrting: profileImageUrl)
        }
        
        containerView.addSubview(profileImageView)
        
        //need x, y, width, height anchors
        profileImageView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        let nameLabel = UILabel()
        
        containerView.addSubview(nameLabel)
        nameLabel.text = user.name
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        //need x, y, width, height anchors
        nameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8).isActive = true
        nameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalTo: profileImageView.heightAnchor).isActive = true
        
        containerView.centerXAnchor.constraint(equalTo: titleView.centerXAnchor).isActive = true
        containerView.centerYAnchor.constraint(equalTo: titleView.centerYAnchor).isActive = true
        
        
        
        self.navigationItem.titleView = titleView
    }
    
    
    func handleLogout(){
        
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        
        let loginController = LoginController()
        loginController.messagesController = self
        present(loginController, animated: true, completion: nil)
    }

 

}

