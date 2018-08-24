//
//  UserCell.swift
//  SosyalMedya
//
//  Created by Demo on 23.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailText: UILabel!
    @IBOutlet weak var checkImage: UIImageView!
    
    // default olarak false göstermek zorundayız. Çünkü başlangıçta hiçbiri seçilmemiş checkmark ların.
    var showing = false
    func configureCell(profile image: UIImage, email: String, isSelected: Bool ) {
        
        self.profileImage.image = image
        self.emailText.text = email
        // basıldığında boolean değer geldiğinden tam tersini yapıyoruz.
        if isSelected {
            self.checkImage.isHidden = false
        } else {
            self.checkImage.isHidden = true
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            if showing == false {
                checkImage.isHidden = false
                showing = true
            } else {
                checkImage.isHidden = true
                showing = false
            }
        }
        
    }

}
