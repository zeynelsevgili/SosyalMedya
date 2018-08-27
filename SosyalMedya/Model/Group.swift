//
//  Group.swift
//  SosyalMedya
//
//  Created by Demo on 25.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import Foundation

class Group {
    
    private var _groupTitle: String
    private var _groupDesc: String
    private var _key: String
    private var _members: [String]
    private var _membersCount: Int
    
    
    public var groupTitle: String {
        return _groupTitle
    }
    public var groupDesc: String {
        return _groupDesc
    }
    public var key: String {
        return _key
    }
    public var members: [String] {
        return _members
    }
    public var membersCount: Int {
        return _membersCount
    }
    
    init(title: String, description: String, key: String, members: [String], membersCount: Int) {
        
        self._groupTitle = title
        self._groupDesc = description
        self._key = key
        self._members = members
        self._membersCount = membersCount

    }
    
    
    
    
    
}
