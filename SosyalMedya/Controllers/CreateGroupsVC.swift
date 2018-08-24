//
//  CreateGroupsVC.swift
//  SosyalMedya
//
//  Created by Demo on 23.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

class CreateGroupsVC: UIViewController {


    @IBOutlet weak var titleTextField: InsetTextField!
    @IBOutlet weak var descriptionTextField: InsetTextField!
    @IBOutlet weak var emailSearchTextField: InsetTextField!

    @IBOutlet weak var groupMemberLbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    // Tamam butonunu hide edeceğimiz için outlet ekliyoruz.
    @IBOutlet weak var doneBtn: UIButton!

    var emailArray = [String]()
    var chosenArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        // emailTextField deki olayları control amaçlı delegate ediyoruz.
        emailSearchTextField.delegate = self
        // editingChanged: yani bir şeyler yazıldığında neler olacak. aşağıdaki satır bunun kontrolünü yapıyor.
        // her editing change edildiğinde selector içine yazılan fonksiyon çağrılacak
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

        // Do any additional setup after loading the view.
    }
    
    // view update edileceği zaman butonu sakla.
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        doneBtn.isHidden = true
    }

    @objc func textFieldDidChange() {

        if emailSearchTextField.text == "" {
            emailArray = []
            tableView.reloadData()
        } else {
            DataService.instance.getEmail(forSearchQuery: emailSearchTextField.text!, handler: { (returnedEmailArray) in
                self.emailArray = returnedEmailArray
                self.tableView.reloadData()
            })

        }
    }

    @IBAction func doneBtnWasPressed(_ sender: Any) {
    }

    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension CreateGroupsVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return emailArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserCell else { return UITableViewCell() }
        let profileImage = UIImage(named: "defaultProfileImage")
        
        // checkmark edilmiş emailleri tekrardan yazıldığında cell kısmına getirir.
        if chosenArray.contains(emailArray[indexPath.row]) {
            cell.configureCell(profile: profileImage!, email: emailArray[indexPath.row], isSelected: true)
        } else {
            cell.configureCell(profile: profileImage!, email: emailArray[indexPath.row], isSelected: false)

        }
        

        return cell
    }

    // tableViewCell seçildiğinde bu fonksiyon icra olunur. seçilen indexpath e göre işlem yapılır. dikkat çoklu row seçildiğinde her bir row dönülüyor
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // herbir seçeceğimiz row için bir cell dönecek
        guard let cell = tableView.cellForRow(at: indexPath) as? UserCell else { return }
        
        // ünlem işareti not contain yapıyor. seçtiğimiz hücrede olmayan maili groupMemberLbl a ekleyeceğiz.
        if !chosenArray.contains(cell.emailText.text!) {
            chosenArray.append(cell.emailText.text!)
            groupMemberLbl.text = chosenArray.joined(separator: ", ")
            doneBtn.isHidden = false
        } else {
            // bastığımız hücre haricinde update eder. $0 for looptaki geçici değişken gibidir. textfield da checkmark edilmiş herhangi bir maile basıldığında basılan mail haricindekileri(chosen array içinde checkmark edilmiş) filtereleyeceğiz. sadece $0 işareti işaretlense filtrelenmemiş bütün verileri getirir.
            chosenArray = chosenArray.filter({ $0 != cell.emailText.text!})
            if chosenArray.count >= 1 {
                groupMemberLbl.text = chosenArray.joined(separator: ", ")
                } else {
                
                groupMemberLbl.text = "gruba birilerini ekleyin"
                doneBtn.isHidden = true
            }
        }
    }
}

extension CreateGroupsVC: UITextFieldDelegate {

}

