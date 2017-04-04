//
//  LoginController+handler.swift
//  chat
//
//  Created by Chiang Chuan on 04/04/2017.
//  Copyright © 2017 Chiang Chuan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKCoreKit
import GoogleSignIn
import TwitterKit

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func handleRegister(){
        
        view.endEditing(false)
        activityIncidatorViewAnimating(animated: true)

        
        
        guard let email = signupEmailTextField.text, let password = signupPasswordTextField.text, let name = signupNameTextField.text else {
            print("Form is not valid")
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user : FIRUser?, error) in
            if error != nil{
                print(error!)
                self.activityIncidatorViewAnimating(animated: false)
                return
            }
            
            
            guard let uid = user?.uid else{
                return
            }
            
            //Successfully authenticated user
            let imageName = NSUUID().uuidString
            let storageRef = FIRStorage.storage().reference().child("\(imageName).jpg")
            
            if let uploadData = self.compressImageSize(image: self.profileImageView.image!){
                
                storageRef.put(uploadData, metadata: nil, completion: { (metadata, error) in
                    
                    if error != nil{
                        print(error!)
                        self.activityIncidatorViewAnimating(animated: false)
                        return
                    }
                    
                    if let profileImageUrl = metadata?.downloadURL()?.absoluteString{
                        
                        let values = ["name" : name, "email" : email, "profileImageUrl": profileImageUrl]
                        
                        self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject])
                    }
                    
                    print(metadata!)
                    
                })
                
            }
            
            
        })
    }
    
    private func registerUserIntoDatabaseWithUid(uid: String, values:[String: AnyObject]){

        let ref = FIRDatabase.database().reference()
        let usersReference = ref.child("users").child(uid)

        usersReference.updateChildValues(values) { (error, ref) in
            if let err = error{
                print(err)
                self.activityIncidatorViewAnimating(animated: false)
                return
            }
            print("Successfully registerUser into Database")
            let user = User()
            user.setValuesForKeys(values)
            
            self.messagesController?.setupNavBarWithUser(user: user)
            self.activityIncidatorViewAnimating(animated: false)

            self.dismiss(animated: true, completion: nil)

        }
    }

    
    
    
    
    
    func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("canceled picker")
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //图片压缩 1000kb以下的图片控制在100kb-200kb之间
    func compressImageSize(image:UIImage) -> Data?{
        
        var zipImageData = UIImageJPEGRepresentation(image, 1.0)!
        let originalImgSize = zipImageData.count/1024 as Int  //获取图片大小
        print("原始大小: \(originalImgSize)")
        
        if originalImgSize>1500 {
            
            zipImageData = UIImageJPEGRepresentation(image,0.1)!
            
        }else if originalImgSize>600 {
            
            zipImageData = UIImageJPEGRepresentation(image,0.3)!
        }else if originalImgSize>400 {
            
            zipImageData = UIImageJPEGRepresentation(image,0.5)!
            
        }else if originalImgSize>300 {
            
            zipImageData = UIImageJPEGRepresentation(image,0.6)!
        }else if originalImgSize>200 {
            
            zipImageData = UIImageJPEGRepresentation(image,0.7)!
        }
        
        return zipImageData as Data?
    }
    
    
    
    
    
    
    
    
    //social account login handlers
    
    func handleTwitterRegister( session: TWTRSession? ){
        
        guard let token = session?.authToken else {return}
        guard let secret = session?.authTokenSecret else {return}
        
        let credentials = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error{
                print("Failed to login to Firbase with Twitter: ", err)
                return
            }
            print("Successfully logged in with our Twitter user: ")
            
            guard let uid = user?.uid else{return}
            
            let checkUserExistRef = FIRDatabase.database().reference().child("users")
            checkUserExistRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(uid){
                    
                    print("user exist")
                    self.successfullyLogged()
                    
                }else{
                    print("user doesn't exist, add user into database")
                    guard let name = user?.displayName, let userName = session?.userName else {return}
                    let email = "@" + userName
                    
                    let profileImageUrl = "https://twitter.com/\(userName)/profile_image?size=bigger"
                    let values = ["name" : name, "email" : email, "profileImageUrl": profileImageUrl]
                    self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject] )
                    
                }
            })
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
            
            guard let uid = user?.uid else{return}
            
            let checkUserExistRef = FIRDatabase.database().reference().child("users")
            checkUserExistRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(uid){
                    
                    print("user exist")
                    self.successfullyLogged()
                    
                }else{
                    print("user doesn't exist, add user into database")
                    
                    guard let name = user?.displayName, let email = user?.email,  let profileImageUrl = user?.photoURL?.absoluteString else {return}
                    
                    let values = ["name" : name, "email" : email, "profileImageUrl": profileImageUrl]
                    self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject] )
                }
            })
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
            
            
            guard let uid = user?.uid else{return}
            
            let checkUserExistRef = FIRDatabase.database().reference().child("users")
            checkUserExistRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(uid){
                    
                    print("user exist")
                    self.successfullyLogged()
                    
                }else{
                    print("user doesn't exist, add user into database")
                    FBSDKGraphRequest(graphPath: "/me", parameters: nil).start { (connection, result, err) in
                        if err != nil{
                            print("Failed to start graph request", err!)
                            return
                        }
                        
                        if let data = result as? [String:Any] {
                            
                            let profileImageUrl = "https://graph.facebook.com/\(data["id"] as! String)/picture?type=large"
                            
                            guard let name = user?.displayName, let email = user?.email else{return}
                            
                            let values = ["name" : name, "email" : email, "profileImageUrl": profileImageUrl]
                            self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject] )
                            
                        }
                    }
                }
            })
        })
    }
    
    func successfullyLogged(){
        //successfully logged in our user
        messagesController?.fetchUserAndSetupNavBarTitle()
        
        activityIncidatorViewAnimating(animated: false)
        dismiss(animated: true, completion: nil)
        
        print("successfullyLogged")

    }
    
    

    
}
