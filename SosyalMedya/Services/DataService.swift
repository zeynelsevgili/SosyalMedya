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

    
    // escaping kısmı henüz anlaşılamadı.(kısmen anlaşıldı)
    func uploadPost(withMessage message: String, forUID uid: String, withGroupKey groupKey: String?, sendComplete: @escaping (_ status: Bool) ->()) {
        
        if groupKey != nil {
            
            // herbir mesaj autoid ye sahip olacak. bu auto id nin içerisinde yeni bir child olacak(content ve senderId) update edeceğimiz child değerlerini dictionary ile update ediyoruz.
            REF_GROUPS.child(groupKey!).child("messages").childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
            
        } else {
            // FEED kısmına post ediyoruz. childByAutoId() her bir message için unique bir id sağlar.
            REF_FEED.childByAutoId().updateChildValues(["content": message, "senderId": uid])
            sendComplete(true)
        }
        
        
    }
    
    func getAllMessagesFor(desiredGroup: Group, handler: @escaping (_ messagesArray: [Message]) -> ()){
        var groupMessageArray = [Message]()
        REF_GROUPS.child(desiredGroup.key).child("messages").observeSingleEvent(of: .value) { (groupMessageSnapshot) in
            guard let groupMessageSnapshot = groupMessageSnapshot.children.allObjects as? [DataSnapshot] else { return }
            for groupMessage in groupMessageSnapshot {
                let content = groupMessage.childSnapshot(forPath: "content").value as! String
                let senderId = groupMessage.childSnapshot(forPath: "senderId").value as! String
                let groupMessage = Message(content: content, senderID: senderId)
                groupMessageArray.append(groupMessage)
            }
            handler(groupMessageArray)
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
    
    // girilen username e göre email eşleştirilecek ve bu maillerin id leri dönülecek.
    func getIds(forUsernames usernames: [String], handler: @escaping (_ uidArray: [String]) -> ()) {
        
        var idArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {
                let email = user.childSnapshot(forPath: "email").value as! String
                if usernames.contains(email) {
                    // id diziye ekleniyor. user.key? tam olarak anlaşılamadı. nasıl çekti keyleri doğrudan
                    idArray.append(user.key)
                }
            }
            handler(idArray)
        }
        
    }
    
    func getEmailsForGroup(forGroup group: Group, handler: @escaping (_ emailArray: [String]) -> ()) {
        
        var emailArray = [String]()
        REF_USERS.observeSingleEvent(of: .value) { (userSnapshot) in
            guard let userSnapshot = userSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot {

                if group.members.contains(user.key) {
                    
                    let email = user.childSnapshot(forPath: "email").value as! String
                    
                    emailArray.append(email)
                }
            }
            handler(emailArray)
        }
    }
    
    // id kısmı nasıl buraya parametre olarak gönderilecek gözlemle. ayrıca handler true döndüğünde neler olacak gözlemle.
    func createGroup(withTitle title: String, andDescription description: String, forUserIds ids: [String], handler: @escaping (_ groupCreated: Bool) -> ()) {
        // idArray yukarıdaki fonksiyonda dönüldükten sonra burada members adı altında faaliyet gösterecek
        REF_GROUPS.childByAutoId().updateChildValues(["title": title, "description": description, "members": ids])
        // yukarıdaki update işlemi tamamlandığında handler true değeri döner
        handler(true)
    }
    
    func getAllGroups(handler: @escaping (_ groupsArray: [Group]) -> ()) {
        
        var groupsArray = [Group]()
        
        // observeSingleEvent Sadece bir kereliğine observe eder. Firebase e veri eklendiğinde aktif olmaz. Bundan ötürü GroupsVC de
        // viewDidAppear() metodu içine observe ekliyoruz ki arraya her veri eklendiğini izliyor. bundan sonra da tableReload() ediyoruz.
        REF_GROUPS.observeSingleEvent(of: .value) { (groupSnapshot) in
            
            guard let groupSnapshot = groupSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for group in groupSnapshot {
            let memberArray = group.childSnapshot(forPath: "members").value as! [String]
                // neden halihazırdaki user ı arıyor?
                if memberArray.contains((Auth.auth().currentUser?.uid)!) {
                    let title = group.childSnapshot(forPath: "title").value as! String
                    let description = group.childSnapshot(forPath: "description").value as! String
                    // aşağıda group.key nereden geliyor. araştır. dikkat membersCount a arraydaki eleman sayısını verdi.
                    let group = Group(title: title, description: description, key: group.key, members: memberArray, membersCount: memberArray.count)
                    
                    groupsArray.append(group)
                }

                
            }
            handler(groupsArray)
        }

        
    }
    
}
