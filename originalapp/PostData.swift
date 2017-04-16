//
//  PostDate.swift
//  originalapp
//
//  Created by 熊谷一騎 on 2017/04/15.
//  Copyright © 2017 熊谷一騎. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class PostData: NSObject {
    
    var id: String?
    var senderID: String?
    var displayName: String?
    var text: String?
    var date: NSDate?
    
    init(snapshot: FIRDataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: AnyObject]
        
        self.senderID = valueDictionary["senderID"] as? String
        self.displayName = valueDictionary["senderDisplayName"] as? String
        self.text = valueDictionary["text"] as? String
        let time = valueDictionary["date"] as? String
        if time != nil{
            self.date = NSDate(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        }
        
    }
}
