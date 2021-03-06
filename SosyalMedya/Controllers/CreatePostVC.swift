//
//  CreatePostVC.swift
//  SosyalMedya
//
//  Created by Demo on 19.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit
import Firebase

class CreatePostVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var sendBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        
        // burada istediğimiz elementi bind edebiliriz. keyboard ile birlikte yukarı kaldırabiliriz. 
        sendBtn.bindTheKeyboard()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.emailLabel.text = Auth.auth().currentUser?.email
        
    }

    @IBAction func closeBtnWasPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
        
    }
    
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        
        if textView.text != nil && textView.text != "Bir şeyler yaz..." {
            
            sendBtn.isEnabled = false
            
            // database ile iletişim kurar. asenkron bir işlem gerçekleşir. işlem gerçekleştiği vakit diğer sayfaya geri döner.
            DataService.instance.uploadPost(withMessage: textView.text, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: nil, sendComplete: { (isComplete) in
                // message database gönderildiği an dismiss olup geldiği sayfaya geri dönecek
                if isComplete{
                    self.sendBtn.isEnabled = true
                    self.dismiss(animated: true, completion: nil)
                } else {
                    
                    self.sendBtn.isEnabled = true
                    print("bir hata meydana geldi.")
                }
            })
            
        }
    }
    
}

extension CreatePostVC: UITextViewDelegate {
    
    // text yazılmaya başlandığında default olan placeholder ı sil
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
}
