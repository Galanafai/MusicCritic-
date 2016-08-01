//
//  Sweet.swift
//  Music_Critic_Single
//
//  Created by Galanafai Windross on 7/29/16.
//  Copyright © 2016 Galanafai Windross. All rights reserved.
//

import Foundation
import FirebaseDatabase


struct Sweet {
    let key:String!
    let content:String!
    let addedByUser:String!
    let itemRef:FIRDatabaseReference?
    
    init (content:String, addedByUser:String , key:String = ""){
        self.key = key
        self.content = content
        self.addedByUser = addedByUser
        self.itemRef = nil
        
    }
    
    init (snapshot:FIRDataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        
        if let sweetContent = snapshot.value!["content"] as? String {
            content = sweetContent
        }else{
            content = ""
        }
        
        if let sweetUser = snapshot.value!["addedByUser"] as? String {
            addedByUser = sweetUser
        }else{
            addedByUser = ""
        }

        
    }
    func toAnyObject() -> AnyObject {
        return ["content":content, "addedByUser":addedByUser]
    }
    
    
    
}
