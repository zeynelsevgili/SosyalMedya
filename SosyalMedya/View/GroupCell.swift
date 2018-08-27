//
//  GroupCell.swift
//  SosyalMedya
//
//  Created by Demo on 25.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet weak var groupTitle: UILabel!
    @IBOutlet weak var groupDscLbl: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
    
    // dikkat Main.storyboard kısmında class seçilirken "inherit from target seçili değilse problem çıkıyor."
    func configureCell(title: String, description: String, membersCount: Int) {
        
        self.groupTitle.text = title
        self.groupDscLbl.text = description
        self.membersLabel.text = "\(membersCount) Üye Mevcut..."
        
        
        
    }

}
