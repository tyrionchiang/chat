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
import GoogleSignIn
import TwitterKit

class ViewController: UIViewController, FBSDKLoginButtonDelegate, GIDSignInUIDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupFacebookButtons()
        
        setupGoogleButtons()
        
        setupTwitterButton()
        
    }
    
    fileprivate func setupTwitterButton(){
        let twitterButton = TWTRLogInButton { (session, error) in
            if let err = error{
                print("Failed to login via Twitter: ", err)
                return
            }
            print("Successfully logged in under Twitter")
            
            //lets login with Firebase
            self.handleTwitterRegister(session: session!)
            
        }
        
        twitterButton.frame = CGRect(x: 16, y: 212 + 66 + 66 + 66, width: view.frame.width - 32, height: 50)
        view.addSubview(twitterButton)
    }
    
    fileprivate func setupGoogleButtons(){
        let googleButton = GIDSignInButton()
        googleButton.frame = CGRect(x: 16, y: 212, width: view.frame.width - 32, height: 32)
        view.addSubview(googleButton)
        
        GIDSignIn.sharedInstance().uiDelegate = self
        
        //add our custom Google login button here
        let customGoogleButton = UIButton(type: .system)
        customGoogleButton.backgroundColor = .orange
        customGoogleButton.frame = CGRect(x: 16, y: 212 + 66, width: view.frame.width - 32, height: 50)
        customGoogleButton.setTitle("Custom Google Login here", for: .normal)
        customGoogleButton.setTitleColor(.white, for: .normal)
        customGoogleButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        view.addSubview(customGoogleButton)
        
        customGoogleButton.addTarget(self, action: #selector(handleCustomGoogleLogin), for: .touchUpInside)
        
        
    }
    
    
    func handleCustomGoogleLogin(){
        GIDSignIn.sharedInstance().signIn()
    }
    
    
    
    
    fileprivate func setupFacebookButtons(){
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
            //lets login with Firebase
            self.handleFBRegister()
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
        //lets login with Firebase
        handleFBRegister()
    }


}
