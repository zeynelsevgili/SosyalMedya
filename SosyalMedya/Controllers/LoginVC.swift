//
//  LoginVC.swift
//  SosyalMedya
//
//  Created by Demo on 16.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    @IBOutlet weak var emailTextField: InsetTextField!
    @IBOutlet weak var passworTextField: InsetTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()


        emailTextField.delegate = self
        passworTextField.delegate = self
        
    }


    @IBAction func closeBtnWasPressed(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    @IBAction func signInBtnWasPressed(_ sender: Any) {
        
        if emailTextField.text != nil && passworTextField != nil {
            
            AuthService.instance.loginUser(withEmail: emailTextField.text!, andPassword: passworTextField.text!, loginComplete: { (success, error) in
                
                if success {
                    self.dismiss(animated: true, completion: nil)
                } else {
                    // clousure içinde localizedDescription aşağıdaki şekilde yazılıyor.
                    print(String(describing: error?.localizedDescription))
                }
                // eğer hiçbir kayıt yoksa bu satıra geçecek(else komutundan sonra) ve login ile girilen kişinin kaydı yapılacak.
                AuthService.instance.registerUser(withEmail: self.emailTextField.text!, andPassword: self.passworTextField.text!, userCreationComplete: { (success, error) in
                    
                    if success {
                        AuthService.instance.loginUser(withEmail: self.emailTextField.text!, andPassword: self.passworTextField.text!, loginComplete: { (succes, nil) in
                            self.dismiss(animated: true, completion: nil)
                            print("başarılı bir şekilde kayıt yapıldı")
                            
                        })
                      // register kısmında problem çıkarsa!
                    } else {
                        print(String(describing: error?.localizedDescription))
                        
                    }
                    
                    
                })
                
            })
        }
        
        
    }
    
}


extension LoginVC: UITextFieldDelegate {
    
}
