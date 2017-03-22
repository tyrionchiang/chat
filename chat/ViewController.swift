//
//  ViewController.swift
//  chat
//
//  Created by Chiang Chuan on 20/03/2017.
//  Copyright © 2017 Chiang Chuan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class ViewController: UIViewController, FBSDKLoginButtonDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        let loginButton = FBSDKLoginButton()
        view.addSubview(loginButton)
        //frame's are obselete, please use constraints instead because its 2016 after all
        loginButton.frame = CGRect(x: 16, y: 100, width: view.frame.width - 32, height: 32)
        
        loginButton.delegate = self
        loginButton.readPermissions = ["email", "public_profile"]
        
        //add our custom fb login button here
        let customFBButton = UIButton()
        customFBButton.backgroundColor = .blue
        customFBButton.frame = CGRect(x: 16, y: 142, width: view.frame.width - 32, height: 50)
        customFBButton.setTitle("Custom FB Login here", for: .normal)
        customFBButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        view.addSubview(customFBButton)
        
        customFBButton.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        
    }
    func handleCustomFBLogin(){
        FBSDKLoginManager().logIn(withReadPermissions: ["email"], from: self) { (result, err) in
            if err != nil{
                print("Custom FB Login failed:",err!)
                return
            }
            self.showEmailAddress()
        }
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        print("Did log out of facebook")
    }
    
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil{
            print(error)
            return
        }
        showEmailAddress()
    }
    
    func showEmailAddress(){
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else{
            return
        }
        
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil{
                print("Something went wrong with our FB user: ", error!)
                return
            }
            print("Successfully logged in with our user: ", user ?? "")
        })
        
        FBSDKGraphRequest(graphPath: "/me", parameters: ["fields" : "email, id, name"]).start { (connection, result, err) in
            if err != nil{
                print("Failed to start graph request", err!)
                return
            }
            print(result!)
        }
    }
    

}
