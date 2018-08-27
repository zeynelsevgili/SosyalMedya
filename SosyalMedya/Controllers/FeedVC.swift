//
//  FirstViewController.swift
//  SosyalMedya
//
//  Created by Demo on 16.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

class FeedVC: UIViewController {

    // firebase den indirdiğimiz verileri burada saklamıştık. Şimdi tableView a load edeceğiz.
    var messageArray = [Message]()
    
    // bu kısım olmasa viewDidLoad() kısmında delegate ve datasource u belirtemiyoruz.
    @IBOutlet weak var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.none

    }
    

    override func viewDidAppear(_ animated: Bool) {
        // bunun yapılması gerekiyor.(Dökümantasyon)
        super.viewDidAppear(animated)
        // Bu kısımda arrayı update ediyoruz.
        DataService.instance.getAllFeedMessages { (returnedMessageArray) in
            // reversed() fonksiyonu herhangi bir array ı tersine çevirir. en son gönderilen sayfada ilk başta görünür.
            self.messageArray = returnedMessageArray.reversed()
            self.tableView.reloadData()
            
    }

}
    
}

extension FeedVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // guard let kullanmamızın sebebi else kısmında return olarak boş table dönmesidir.
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "feedCell") as? FeedCell
            else { return  UITableViewCell() }
        
        // şimdi feedCell kısmındaki instansları yansıtacağız.
        let image = UIImage(named: "defaultProfileImage")
        let message = messageArray[indexPath.row]
        
        // DataService kısmındaki fonksiyonu kullanıyoruz. handler bize ilgili uid nin mailini(returnedUserName) dönüyordu.
        // Dönülen mail adresini burada email kısmına yapıştırıyoruz.
        
        DataService.instance.getUserName(forUID: message.senderID) { (returnedUserName) in
            cell.configureCell(profileImage: image!, email: returnedUserName, content: message.content)

        }
        
        
        
        return cell
    }
    
}


