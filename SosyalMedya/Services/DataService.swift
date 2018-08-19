//
//  DataService.swift
//  SosyalMedya
//
//  Created by Demo on 16.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    private var _REF_GROUPS = DB_BASE.child("groups")
    private var _REF_FEED = DB_BASE.child("feed")
    
    
    // public variables that accessing private variables.
    var REF_BASE: DatabaseReference {
        
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        
        return _REF_USERS
    }
    
    var REF_GROUPS: DatabaseReference {
        
        return _REF_GROUPS
    }
    
    var REF_FEED: DatabaseReference {
        
        return _REF_FEED
    }
    
    
    // tree şeklinde bir yapı var database de uid ana, userData(Dictionary) çocukları olacak şekilde bir yapı var
    // bu fonksiyon firebase user oluşturmak için kullanılacak.
    func createDBUser(uid: String, userData: Dictionary<String, Any> ) {
        // child kısmını bizden dictionary şeklinde istiyor.
        REF_USERS.child(uid).updateChildValues(userData)
        
    }
    // escaping kısmı henüz anlaşılamadı.
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) ->()) {
        
        if groupKey != nil {
            
            // send to groups ref
        } else {
            // FEED kısmına post ediyoruz. childByAutoId() her bir message için unique bir id sağlar.
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
        
        
        
    }
    
    
}
