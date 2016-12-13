//
//  Message.swift
//  chat
//
//  Created by Chiang Chuan on 11/12/2016.
//  Copyright © 2016 Chiang Chuan. All rights reserved.
//

import UIKit
import Firebase

class Message: NSObject {
    var toId: String?
    var timestamp: NSNumber?
    var text: String?
    var fromId: String?
    
    func chatPartnerId() -> String? {
        return fromId == FIRAuth.auth()?.currentUser?.uid ? toId : fromId
    }
}
