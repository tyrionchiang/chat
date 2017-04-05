//
//  AppDelegate.swift
//  chat
//
//  Created by Chiang Chuan on 24/11/2016.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import Fabric
import TwitterKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?
    let messagesController = MessagesController()
    let loginController = LoginController()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.tintColor = UIColor(r: 184, g: 153, b: 129)
        window?.backgroundColor = UIColor(r: 245, g: 245, b: 245)
        window?.makeKeyAndVisible()
        messagesController.loginController = loginController
        window?.rootViewController = UINavigationController(rootViewController: messagesController)
        // Override point for customization after application launch.
        
        
        
        
        FIRApp.configure()
        GIDSignIn.sharedInstance().clientID = FIRApp.defaultApp()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        Fabric.with([Twitter.self])
        
        return true
    }
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let err = error{
            print("Failed to log into Google", err)
            return
        }
        print("Successfully logged into Google", user)
        
        
        //lets login with Firebase
        
        loginController.handleGoogleRegister(user : user)
        
//        loginController.activityIncidatorViewAnimating(animated: true)
//
//        guard let idToken = user.authentication.idToken else {return}
//        guard let accessToken = user.authentication.accessToken else {return}
//        
//        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
//        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
//            if let err = error{
//                print("Failed to creat a FirbaseUser with Google account: ", err)
//                return
//            }
//            print("Successfully logged in with our Google user: ")
//            
//            guard let uid = user?.uid else{return}
//            
//            let checkUserExistRef = FIRDatabase.database().reference().child("users")
//            checkUserExistRef.observeSingleEvent(of: .value, with: { (snapshot) in
//                if snapshot.hasChild(uid){
//                    
//                    print("user exist")
//                    self.GoogleSuccessfullyLogged()
//
//                    
//                }else{
//                    print("user doesn't exist, add user into database")
//                    
//                    guard let name = user?.displayName, let email = user?.email,  let profileImageUrl = user?.photoURL?.absoluteString else {return}
//                    
//                    let values = ["name" : name, "email" : email, "profileImageUrl": profileImageUrl]
//                    let ref = FIRDatabase.database().reference()
//                    let usersReference = ref.child("users").child(uid)
//                    
//                    usersReference.updateChildValues(values) { (error, ref) in
//                        if let err = error{
//                            print(err)
////                            self.activityIncidatorViewAnimating(animated: false)
//                            return
//                        }
//                        print("Successfully registerUser into Database")
//                        let user = User()
//                        user.setValuesForKeys(values)
//                        
//                        self.GoogleSuccessfullyLogged()
//                    }
//                }
//            })
//        })

        
    }
    
//    func GoogleSuccessfullyLogged(){
//        loginController.activityIncidatorViewAnimating(animated: false)
//        let rootViewController = self.window?.rootViewController
//        rootViewController?.dismiss(animated: true, completion: nil)
//        self.messagesController.fetchUserAndSetupNavBarTitle()
//    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
      
        
        let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as! String!, annotation: options[UIApplicationOpenURLOptionsKey.annotation])
        
        
        GIDSignIn.sharedInstance().handle(url,
                                          sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                          annotation: [:])

        return handled

    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

