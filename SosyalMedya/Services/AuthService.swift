//
//  File.swift
//  SosyalMedya
//
//  Created by Demo on 17.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import Foundation
import Firebase


class AuthService {
    
    static let instance = AuthService()
    
    //  with external parameter... email internal parameter.
    // @escaping tam anlaşılamadı.
    func registerUser(withEmail email: String, andPassword password: String, userCreationComplete: @escaping (_ status: Bool, _ error: Error?) -> ()) {
        // built-in function in Firebase
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            // eğer user nil değlse user değişkenine ata. eğer user değişkeni gelmemişse error ile false yap(completion handler dan gelen parametreler)
            guard let user = user else {
                userCreationComplete(false, error)
                return
            }
            // user nil değilse ne yapacağız peki? Firebase de database oluşturmamız için DataServise in createDBUser fonksiyonuna dictionary key value değerlerini göndereceğiz.
            // DataService fonksiyonuna parametre göndereceğiz. bunun için providerID(Firebase email, facebook veya google email id olabilir. )
            let userData = ["provider": user.user.providerID, "email": user.user.email]
            
            DataService.instance.createDBUser(uid: user.user.uid, userData: userData)
            userCreationComplete(true, nil)
            
        }
        
        
        
    }
    
    func loginUser(withEmail email: String, andPassword password: String, loginComplete: @escaping (_ status: Bool, _ error: Error?)->()) {
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
           
            if error != nil {
                loginComplete(false, error)
                return
            }
        
            loginComplete(true, nil)
        }
        
    }
    
    
    
}
