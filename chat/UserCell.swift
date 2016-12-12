//
//  UserCell.swift
//  chat
//
//  Created by Chiang Chuan on 12/12/2016.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit
import Firebase


class UserCell:UITableViewCell{
    
    var message: Message? {
        didSet{
            
            if let toId = message?.toId {
                let ref = FIRDatabase.database().reference().child("users").child(toId)
                ref.observe(.value, with: { (snapshot) in
                    
                    if let dictionary = snapshot.value as? [String: AnyObject]{
                        self.textLabel?.text = dictionary["name"] as? String
                        
                        if let profileImageUrl = dictionary["profileImageUrl"]{
                            self.profileImageView.loadImageUsingCacheWithUrlString(urlSrting: profileImageUrl as! String)
                        }
                    }
                    
                }, withCancel: nil)
            }
            
            detailTextLabel?.text = message?.text

        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: (textLabel?.frame.origin.y)! - 2, width: (textLabel?.frame.width)!, height: (textLabel?.frame.height)!)
        detailTextLabel?.frame = CGRect(x: 64, y: (detailTextLabel?.frame.origin.y)! + 2, width: (detailTextLabel?.frame.width)!, height: (detailTextLabel?.frame.height)!)
    }
    
    let profileImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        
        // need x, y, width, height anchors
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}