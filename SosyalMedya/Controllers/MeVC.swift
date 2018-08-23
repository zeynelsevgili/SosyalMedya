//
//  MeVC.swift
//  SosyalMedya
//
//  Created by Demo on 19.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit
import Firebase

class MeVC: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.emailLabel.text = Auth.auth().currentUser?.email
    }

    
    // IBAction kısmı tam olarak oluşmadığı için 1.5 gün süre aldı. Dikkat et!
    @IBAction func signOutBtnWasPressed(_ sender: Any) {
        let logoutPopup = UIAlertController(title: "Çıkış?", message: "Çıkmak istediğinizden eminmisiniz?", preferredStyle: .actionSheet)
        
        let logoutAction = UIAlertAction(title: "Çıkış?", style: .destructive) { (buttonTapped) in
            
            
            do {
                try Auth.auth().signOut()
                let authVC = self.storyboard?.instantiateViewController(withIdentifier: "AuthVC") as? AuthVC
                
                self.present(authVC!, animated: true, completion: nil)
                
            } catch {
                print(error)
            }
            
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        { (buttontapped) in
            self.dismiss(animated: true, completion: nil)
        }
        // Attaches an action object to the alert or action sheet.
        logoutPopup.addAction(logoutAction)
        logoutPopup.addAction(cancelAction)
        self.present(logoutPopup, animated: true, completion: nil)
        
        
        
    }
    
    
    

}



