//
//  InsetTextField.swift
//  SosyalMedya
//
//  Created by Demo on 16.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

class InsetTextField: UITextField {

    // placeholder kısmındaki text paddingleri. text soldan 20 birim ileride diğerlerinde 0 olacak şekilde yerleşecek
    private var padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
    
    
    override func awakeFromNib() {
        setUpView()
        super.awakeFromNib()
    }


    // bu fonksiyonları çok açıklayamadı.
    override func textRect(forBounds bounds: CGRect) -> CGRect {


        // Bu satır tam olarak anlaşılmadı.
        return UIEdgeInsetsInsetRect(bounds, padding)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {

        return UIEdgeInsetsInsetRect(bounds, padding)

    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        
        return UIEdgeInsetsInsetRect(bounds, padding)

    }
    
    func setUpView (){
        // placeholder yazısı belirtilen renkte olur
        let placeholder = NSAttributedString(string: self.placeholder!, attributes: [NSAttributedStringKey.foregroundColor: #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)])
        
        // textfielde vasıflanmış bir placeholder olduğunu söylüyoruz.
        // MainStoryBoarddan viewController daki textfield ler seçilip custom class kısmından InsetTextField seçiliyor.
        self.attributedPlaceholder = placeholder
        
    }
    
    
}
