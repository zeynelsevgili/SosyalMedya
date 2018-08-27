//
//  GroupFeedVC.swift
//  SosyalMedya
//
//  Created by Demo on 25.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit
import Firebase

class GroupFeedVC: UIViewController {
    @IBOutlet weak var groupTitleLbl: UILabel!
    @IBOutlet weak var membersLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var sendBtnView: UIView!
    @IBOutlet weak var messageTextField: InsetTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    // burada group nesnesi başlatıp bütün özelliklerine ulaşıp, bu sınıfta oluşturduğumuz outletlere atayabileceğiz.
    // firebase den tekrardan indirmeye gerek yok. viewWillAppear kısmında outletlere atama yapıyoruz.
    var group: Group?
    var groupMessages = [Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sendBtnView.bindTheKeyboard()
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none


        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // normalde membersden id
        DataService.instance.getEmailsForGroup(forGroup: group!) { (returnedEmails) in
            
            self.groupTitleLbl.text = self.group?.groupTitle
            self.membersLbl.text = returnedEmails.joined(separator: ", ")
        }
        // REF_GROUPS içindeki bütün değişimleri(observe) gözlemliyoruz.
        // Herhangi bir değişimde bütün mesajları update edeceğiz
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            DataService.instance.getAllMessagesFor(desiredGroup: self.group!, handler: { (returnedGroupMessagesArray) in
                self.groupMessages = returnedGroupMessagesArray
                // indirilen messajlar groupMessages arrayına atanır atanmaz table ı reload et
                self.tableView.reloadData()
                
                if self.groupMessages.count > 0 {
                    // grup mesajının en alt kalmayıp güzel bir animasyonla sonda belirmesini sağlayacağız.
                    // burada row: kısmında 30 mesaj varsa mesaj sayısı kadar ki row yani 30. row u animate edeceğiz.(0 ıncı indexten başlandığı için 1 çıkarılacak)
                    self.tableView.scrollToRow(at: IndexPath.init(row: self.groupMessages.count-1, section: 0), at: .none, animated: true)
                }
            })
        }
    }
    
    // burada group nesnesi başlatıp bütün özelliklerine ulaşıp, bu sınıfta oluşturduğumuz outletlere atayabileceğiz.
    // firebase den tekrardan indirmeye gerek yok.
    func initData(forGroup group: Group) {
        self.group = group
    }
    
    @IBAction func backBtnWasPressed(_ sender: Any) {
        // extension kısmında oluşturduğumuz fonksiyonu dismiss yerine kullandık
        dismissDetail()
    }
    @IBAction func sendBtnWasPressed(_ sender: Any) {
        
        if messageTextField.text != "" {
            messageTextField.isEnabled = false
            sendBtn.isEnabled = false
            // uid nereden refere edildi.
            DataService.instance.uploadPost(withMessage: messageTextField.text!, forUID: (Auth.auth().currentUser?.uid)!, withGroupKey: group?.key, sendComplete: { (complete) in
                
                if complete {
                    // message gönderildikten sonra mesaj kutusu boşalacak.
                    self.messageTextField.text = ""
                    
                    self.messageTextField.isEnabled = true
                    self.sendBtn.isEnabled = true
                    
                }
            })
            
        }
        
        
    }
    
}


extension GroupFeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupMessages.count
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "groupFeedCell", for: indexPath) as? GroupFeedCell else { return UITableViewCell()}
        let message = groupMessages[indexPath.row]
        
        DataService.instance.getUserName(forUID: message.senderID) { (email) in
            // dikkat! closure a gelen email değerini internal parametre olarak kullandı.
            cell.configureCell(profileImage: UIImage(named: "defaultProfileImage")!, email: email, content: message.content)

        }
        
        return cell
        
    }
    
}
