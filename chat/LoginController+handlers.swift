//
//  LoginController+handlers.swift
//  chat
//
//  Created by Chiang Chuan on 05/12/2016.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit
import Firebase


extension LoginController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    func handleRegister(){
        
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
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
        
        usersReference.updateChildValues(values, withCompletionBlock: { (err, ref) in
            if err != nil{
                print(err!)
                self.activityIncidatorViewAnimating(animated: false)
                return
            }
            
//            self.messagesController?.fetchUserAndSetupNavBarTitle()
//            self.messagesController?.navigationItem.title = values["name"] as? String
            let user = User()
            //this setter potentially crashes if keys don't match
            user.setValuesForKeys(values)
            self.messagesController?.setupNavBarWithUser(user: user)

            
            self.activityIncidatorViewAnimating(animated: false)
            self.dismiss(animated: true, completion: nil)
        })
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


}
