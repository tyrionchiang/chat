//
//  ViewController+handlers.swift
//  chat
//
//  Created by Chiang Chuan on 23/03/2017.
//  Copyright © 2017 Chiang Chuan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import TwitterKit

extension ViewController{
    
    func handleTwitterRegister( session: TWTRSession? ){
        
        guard let token = session?.authToken else {return}
        guard let secret = session?.authTokenSecret else {return}
        
        let credentials = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error{
                print("Failed to login to FirbaseU with Twitter: ", err)
                return
            }
            print("Successfully logged in with our Twitter user: ")
            guard let uid = user?.uid, let name = user?.displayName, let userName = session?.userName else {return}
            let email = "@" + userName
            
            let profileImageUrl = "https://twitter.com/\(userName)/profile_image?size=bigger"
            self.registerUserIntoDatabaseWithUid(uid: uid, name: name, email: email, profileImageUrl: profileImageUrl)
        })

    }
    
    func handleGoogleRegister(user : GIDGoogleUser){
        
        guard let idToken = user.authentication.idToken else {return}
        guard let accessToken = user.authentication.accessToken else {return}
        
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error{
                print("Failed to creat a FirbaseUser with Google account: ", err)
                return
            }
            print("Successfully logged in with our Google user: ")
            guard let uid = user?.uid, let name = user?.displayName, let email = user?.email,  let profileImageUrl = user?.photoURL?.absoluteString else {return}
            
            self.registerUserIntoDatabaseWithUid(uid: uid, name: name, email: email, profileImageUrl: profileImageUrl)
        })
    }
    
    func handleFBRegister(){
        
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
            print("Successfully logged in with our FB user: ")
            guard let uid = user?.uid, let name = user?.displayName, let email = user?.email else{return}
            
            
            FBSDKGraphRequest(graphPath: "/me", parameters: nil).start { (connection, result, err) in
                if err != nil{
                    print("Failed to start graph request", err!)
                    return
                }
                print(result!)
                
                if let data = result as? [String:Any] {
                
                    let profileImageUrl = "https://graph.facebook.com/\(data["id"] as! String)/picture?type=large"
                        
                    self.registerUserIntoDatabaseWithUid(uid: uid, name: name, email: email, profileImageUrl: profileImageUrl)

                }
            }


        })
        
    }
    

    private func registerUserIntoDatabaseWithUid(uid: String, name: String, email: String, profileImageUrl: String){
        print(profileImageUrl)
        let values = ["name" : name, "email": email, "profileImageUrl": profileImageUrl]
        
        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)
        
        usersReference.updateChildValues(values) { (error, ref) in
            if let err = error{
                print(err)
                return
            }
            print("Successfully registerUser into Database")
            let user = User()
            user.setValuesForKeys(values)
        }
    }

}
