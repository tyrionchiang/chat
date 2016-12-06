//
//  extension.swift
//  chat
//
//  Created by Chiang Chuan on 26/11/2016.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit

extension UIColor{
    convenience init(r : CGFloat, g : CGFloat, b : CGFloat){
        self.init(red : r / 255, green : g / 255, blue : b / 255, alpha : 1)
    }
}
extension UIViewController {
    
    // hide keyboard
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}



let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    func loadImageUsingCacheWithUrlString(urlSrting: String) {
        
        self.image = nil
        
        //Check cache for Image first
        if let cachedImage = imageCache.object(forKey: urlSrting as AnyObject) as? UIImage{
            self.image = cachedImage
            return
        }
        
        //otherwise fire off a new download
        let url = URL(string: urlSrting)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            
            //download hit an error lets return out
            if error != nil{
                print(error!)
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                if let downloadedImage = UIImage(data: data!){
                    
                    imageCache.setObject(downloadedImage, forKey: urlSrting as AnyObject)

                    self.image = downloadedImage

                }
                
                
            })
            
        }).resume()

    }
}
