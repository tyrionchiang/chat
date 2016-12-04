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
    
    func activityIncidatorViewStartAnimating(){
        
        let activityIncidatorView : UIActivityIndicatorView = {
            let aiv = UIActivityIndicatorView()
            aiv.hidesWhenStopped = true
            aiv.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            return aiv
        }()
        
        view.addSubview(activityIncidatorView)
        activityIncidatorView.center = view.center
        activityIncidatorView.startAnimating()
    }

}
