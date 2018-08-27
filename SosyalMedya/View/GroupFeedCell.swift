//
//  GroupFeedCell.swift
//  SosyalMedya
//
//  Created by Demo on 25.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

class GroupFeedCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var contentLbl: UILabel!
    
    
    
    func configureCell(profileImage: UIImage, email: String, content: String ) {
        
        self.profileImage.image = profileImage
        self.emailLbl.text = email
        self.contentLbl.text = content
        
        
    }
}
