//
//  SecondViewController.swift
//  SosyalMedya
//
//  Created by Demo on 16.08.2018.
//  Copyright © 2018 Demo. All rights reserved.
//

import UIKit

class GroupsVC: UIViewController {
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    var groupsArray = [Group]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        self.groupsTableView.separatorStyle = UITableViewCellSeparatorStyle.none

    }
    
    // viewDidAppear() metodu içine observe ekliyoruz ki arraya her veri eklendiğini izliyor. bundan sonra da tableReload() ediyoruz.
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // observe() -> herşeyi observe et. single değil...
        DataService.instance.REF_GROUPS.observe(.value) { (snapshot) in
            
            DataService.instance.getAllGroups { (returnedGroupsArray) in
                self.groupsArray = returnedGroupsArray
                self.groupsTableView.reloadData()
            }
        }
   
    }


}

extension GroupsVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as? GroupCell else { return UITableViewCell()}
        let group = groupsArray[indexPath.row]
        cell.configureCell(title: group.groupTitle, description: group.groupDesc, membersCount: group.membersCount)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let groupFeedVC = storyboard?.instantiateViewController(withIdentifier: "GroupFeedVC") as? GroupFeedVC else { return }
        // groupFeedVC oluşturduğumuz nesneyi başlatıyoruz ve seçili row u initData da set edilmek üzere GroupFeedVC ye gönderiyoruz.
        groupFeedVC.initData(forGroup: groupsArray[indexPath.row])
        // extension kısmında oluşturduğumuz "present" fonksiyonunu kullandık burada
        presentDetail(groupFeedVC)
        
    }
}
