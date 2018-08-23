//
//  File.swift
//  SosyalMedya
//
//  Created by Demo on 21.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import Foundation

// Firebase de FEED kısmından veriler çekildikten sonra çekilen bütün veriler message instance ına aktarılacak.
// Ordan da arraya append edilecek. Sonra da tableView de gösterilecek. 
class Message {
    
    private var _content: String
    private var _senderID: String
    
    var content: String {
        
        return _content
    }
    
    var senderID: String {
        
        return _senderID
    }
    init(content: String, senderID: String) {
        
        self._content = content
        self._senderID = senderID
        
    }
}
