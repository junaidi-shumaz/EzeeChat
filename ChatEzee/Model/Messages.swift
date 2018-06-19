//
//  Messages.swift
//  ChatEzee
//
//  Created by Shumaz Ahamed Junaidi on 6/4/18.
//  Copyright © 2018 Shumaz Ahamed Junaidi. All rights reserved.
//

import UIKit
import Firebase
class Messages: NSObject {
    var receiverID: String?
    var senderID: String?
    var timeStamp: NSNumber?
    var text: String?
    
    func getActualMappedUserID()-> String?{
        let actualChatID: String?
        if senderID == Auth.auth().currentUser?.uid{
            
            actualChatID = receiverID
        }else{
            
            actualChatID = senderID
        }
        return actualChatID
    }
    
}
