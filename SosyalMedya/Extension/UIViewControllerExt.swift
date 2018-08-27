//
//  UIViewControllerExt.swift
//  SosyalMedya
//
//  Created by Demo on 27.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit


// dismiss ve present için extension geliştireceğiz.
extension UIViewController {
    
    func presentDetail(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromTop
        self.view.window?.layer.add(transition, forKey: kCATransition)
        
        // oluşturduğumuz fonksiyonun parametresini default present e giriyoruz
        present(viewControllerToPresent, animated: false, completion: nil   )
        
        
    }
    
    func dismissDetail() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromBottom
        self.view.window?.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false, completion: nil)
    }
    
}
