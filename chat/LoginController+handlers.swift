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

extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIAlertViewDelegate {
    
    
    func handleRegister(){
        
        view.endEditing(false)
        activityIncidatorViewAnimating(animated: true)

        
        
        guard let email = signupEmailTextField.text, let password = signupPasswordTextField.text, let name = signupNameTextField.text else {
            print("Form is not valid")
            self.activityIncidatorViewAnimating(animated: false)
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user : FIRUser?, error) in
            if error != nil{
                print(error!)
                self.activityIncidatorViewAnimating(animated: false)
                return
            }
            
            
            guard let uid = user?.uid else{
                self.activityIncidatorViewAnimating(animated: false)
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
            
            self.successfullyLogged()
//            self.messagesController?.setupNavBarWithUser(user: user)
//            self.activityIncidatorViewAnimating(animated: false)
//
//            self.dismiss(animated: true, completion: nil)

        }
    }

    

    func handleSelectProfileImageView() {
        
        let alert:UIAlertController=UIAlertController(title: "Choose Image", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
//        alert.popoverPresentationController?.sourceView = view.
//        alert.popoverPresentationController?.sourceRect =
        
        let cameraAction = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openCamera()
        }
        let gallaryAction = UIAlertAction(title: "Gallary", style: UIAlertActionStyle.default)
        {
            UIAlertAction in
            self.openGallary()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel)
        {
            UIAlertAction in
        }
        // Add the actions
        alert.addAction(cameraAction)
        alert.addAction(gallaryAction)
        alert.addAction(cancelAction)
        // Present the controller
        
        if UIDevice.current.userInterfaceIdiom == .pad{
            alert.popoverPresentationController?.sourceView = view
            alert.popoverPresentationController?.sourceRect = view.bounds
//            alert.preferredContentSize = CGSize(width: 10, height: 10)
            alert.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.init(rawValue: 0)

        }
    
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func openCamera()
    {
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
        {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = UIImagePickerControllerSourceType.camera
            present(picker, animated: true, completion: nil)
        }
        else
        {
            openGallary()
        }
    }
    func openGallary()
    {
        let picker = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        picker.delegate = self
        picker.allowsEditing = true

        if UIDevice.current.userInterfaceIdiom == .phone
        {

            present(picker, animated: true, completion: nil)
        }
        else
        {
            print("popOver in")
            popover(pop: picker, size: CGSize(width: bd.width * 0.75, height: bd.height * 6), arch: view, Direction: UIPopoverArrowDirection.init(rawValue: 0))
        }
    }
    
    
    
    func adaptivePresentationStyle(for controller:UIPresentationController) -> UIModalPresentationStyle {
        return .none
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
        
        picker.dismiss(animated: true, completion: nil)
        
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
        
        activityIncidatorViewAnimating(animated: true)
        
        guard let token = session?.authToken else {
            self.activityIncidatorViewAnimating(animated: false)
            return}
        guard let secret = session?.authTokenSecret else {
            self.activityIncidatorViewAnimating(animated: false)
            return}
        
        let credentials = FIRTwitterAuthProvider.credential(withToken: token, secret: secret)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error{
                print("Failed to login to Firbase with Twitter: ", err)
                self.activityIncidatorViewAnimating(animated: false)
                return
            }
            print("Successfully logged in with our Twitter user: ")
            
            guard let uid = user?.uid else{
                self.activityIncidatorViewAnimating(animated: false)
                return}
            
            let checkUserExistRef = FIRDatabase.database().reference().child("users")
            checkUserExistRef.observeSingleEvent(of: .value, with: { (snapshot) in
                if snapshot.hasChild(uid){
                    
                    print("user exist")
                    self.successfullyLogged()
                    
                }else{
                    print("user doesn't exist, add user into database")
                    guard let name = user?.displayName, let userName = session?.userName else {
                        self.activityIncidatorViewAnimating(animated: false)
                        return}
                    let email = "@" + userName
                    
                    let profileImageUrl = "https://twitter.com/\(userName)/profile_image?size=bigger"
                    let values = ["name" : name, "email" : email, "profileImageUrl": profileImageUrl]
                    self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject] )
                    
                }
            })
        })
    }
    
    func handleGoogleRegister(notification:Notification){
        //user : GIDGoogleUser
        guard let user = notification.userInfo?["user"] as? GIDGoogleUser else{
            return
        }

        activityIncidatorViewAnimating(animated: true)
        
        guard let idToken = user.authentication.idToken else {
            self.activityIncidatorViewAnimating(animated: false)
            return}
        guard let accessToken = user.authentication.accessToken else {
            self.activityIncidatorViewAnimating(animated: false)
            return}
        
        let credentials = FIRGoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if let err = error{
                print("Failed to creat a FirbaseUser with Google account: ", err)
                self.activityIncidatorViewAnimating(animated: false)
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
                    
                    guard let name = user?.displayName, let email = user?.email,  let profileImageUrl = user?.photoURL?.absoluteString else {
                        self.activityIncidatorViewAnimating(animated: false)
                        return}
                    
                    let values = ["name" : name, "email" : email, "profileImageUrl": profileImageUrl]
                    self.registerUserIntoDatabaseWithUid(uid: uid, values: values as [String : AnyObject] )
                }
            })
        })
    }
    
    func handleFBRegister(){

        activityIncidatorViewAnimating(animated: true)
        
        let accessToken = FBSDKAccessToken.current()
        guard let accessTokenString = accessToken?.tokenString else{
            self.activityIncidatorViewAnimating(animated: false)
            return
        }
        
        let credentials = FIRFacebookAuthProvider.credential(withAccessToken: accessTokenString)
        FIRAuth.auth()?.signIn(with: credentials, completion: { (user, error) in
            if error != nil{
                print("Something went wrong with our FB user: ", error!)
                self.activityIncidatorViewAnimating(animated: false)
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
                            self.activityIncidatorViewAnimating(animated: false)
                            return
                        }
                        
                        if let data = result as? [String:Any] {
                            
                            let profileImageUrl = "https://graph.facebook.com/\(data["id"] as! String)/picture?type=large"
                            
                            guard let name = user?.displayName, let email = user?.email else{
                                self.activityIncidatorViewAnimating(animated: false)
                                return
                            }
                            
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

//        loginViewInitialization()
        activityIncidatorViewAnimating(animated: false)
        dismiss(animated: true, completion: nil)
        
        print("successfullyLogged")

    }
//    func loginViewInitialization(){
//        loginEmailTextField.text = ""
//        loginPasswordTextField.text = ""
//        signupNameTextField.text = ""
//        signupEmailTextField.text = ""
//        signupPasswordTextField.text = ""
//        handleLoginViewTap()
//    }
    
    
    
}


