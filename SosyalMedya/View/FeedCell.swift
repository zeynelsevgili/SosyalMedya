//
//  FeedCell.swift
//  SosyalMedya
//
//  Created by Demo on 20.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

class FeedCell: UITableViewCell {


    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    func configureCell(profileImage: UIImage, email: String, content: String) {
        
        self.profileImage.image = profileImage
        self.emailLabel.text = email
        self.messageLabel.text = content
        
        
        
        
    }
    
    
}
