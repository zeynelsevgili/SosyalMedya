//
//  ShadowView.swift
//  SosyalMedya
//
//  Created by Demo on 16.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit


//Dikkat view kısmının custom class kısmı attribute inspector den değiştirildiğinde otomatik olarak view aşağıda belirtilen özellikleri gösterir.
class ShadowView: UIView {

    override func awakeFromNib() {
        
        self.layer.shadowOpacity = 0.75
        self.layer.shadowRadius = 5
        self.layer.shadowColor = #colorLiteral(red: 0.7254902124, green: 0.4784313738, blue: 0.09803921729, alpha: 1)
        
        super.awakeFromNib()
    }
    
    

}
