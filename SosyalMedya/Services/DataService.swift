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
    
    // uid pass ediyoruz fonksiyona datasnapshot ile user ile uid eşleşmesi yapıyoruz. eşleşmesi yapılan user ın email ini geri dönüyoruz.(handler ile)
    func getUserName(forUID uid: String, handler: @escaping (_ username: String) -> ()) {
        
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                if user.key == uid {
                    handler(user.childSnapshot(forPath: "email").value as! String)
                }
            }
        }
        
        
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
    
    func getAllFeedMessages(handler: @escaping (_ messages: [Message]) -> ()) {
        
        var messageArray = [Message]()
        
        // Feed kısmındaki verilerin hepsini indiriyoruz burda.
        // "feedMessageDataSnapshot" firabase array ında saklıyoruz.
        REF_FEED.observeSingleEvent(of: .value) { (feedMessageDataSnapshot) in
            
            // DataSnapshot contains data from a Firebase Database location
            guard let feedMessageDataSnapshot = feedMessageDataSnapshot.children.allObjects as? [DataSnapshot]
                else { return }
            for message in feedMessageDataSnapshot {
                
                // content ve senderID child ları String olarak cast ediyoruz.
                let content = message.childSnapshot(forPath: "content").value as! String
                let sendID = message.childSnapshot(forPath: "senderId").value as! String
                // Burada ilk objemizi oluşturuyoruz.
                let message = Message(content: content, senderID: sendID)
                
                messageArray.append(message)
            }
            // bütün verileri firabase den indirdik ve Message türündeki messageArraya append ettik. 
            handler(messageArray)
            
            
        }
        
        
        
    }
    // buraya textfieldden query için bir değer gelecek ve bunu database deki değer ile eşleştirip
    // emailArray a append edeceğiz.
    func getEmail(forSearchQuery query: String, handler: @escaping (_ emailArray: [String]) -> ()) {
        
        var emailArray = [String]()
        
        REF_USERS.observe(.value) { (userSnapshot) in
            guard let userSnap = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnap {
                
                let email = user.childSnapshot(forPath: "email").value as! String
                if email.contains(query) == true && email != Auth.auth().currentUser?.email {
                    
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
        
        
        
    }
    
    
    
}
