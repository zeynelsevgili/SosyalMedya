//
//  UIViewExt.swift
//  SosyalMedya
//
//  Created by Demo on 20.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

extension UIView {
    
    
    func bindTheKeyboard() {
        // btn.bindTheKeyboard() komutuyla aşağıdaki satır aktif olur ve selector içindeki fonksiyon icra edilir. name kısmı zaten default olarak ios da kullanılıyor.
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChange(_:)), name:NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
       
    }
    
    // objc komutu bu fonksiyonu objectif c ye maruz bırakıyor. 
   @objc func keyboardWillChange(_ notification: NSNotification) {
        
        // keyboardın animasyon süresi. Buton keyboard ile eş zamanlı yükselecek. Dictionary şeklinde dönüş olur
        let duration = notification.userInfo![UIKeyboardAnimationDurationUserInfoKey] as! Double
        // keyboardın animasyon curve ünü alıyoruz. aşağıda buton da aynı şekilde olacak.
        let curve = notification.userInfo![UIKeyboardAnimationCurveUserInfoKey] as! UInt
        
        let beginingFrame = (notification.userInfo![UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        let endFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // yukarıda bize rectangle türünde bir değer dönülmüştü. bu rectangle ın y sini alıyoruz.
        let delta = endFrame.origin.y - beginingFrame.origin.y
        
        
        // asıl animasyonu yapacak kısım bu fonksiyondur. Butonu oynatacak fonksiyon bu.
        UIView.animateKeyframes(withDuration: duration, delay: 0.0, options: UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            // burası çok önemli! Soldaki ifade butonunu konumunu ifade ediyor. bu konuma keyboardın(basıldığı zaman otomatik yukarı çıkıyor) animasyon anındaki değerleri gönderiyoruz. böylece buton eş zamanlı havaya kalkıyor.
            self.frame.origin.y += delta
        }, completion: nil)
    }
    
}
