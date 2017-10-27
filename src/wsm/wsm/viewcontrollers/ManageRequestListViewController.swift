//
//  ManageRequestListViewController.swift
//  wsm
//
//  Created by DaoLQ on 10/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class ManageRequestListViewController: BaseViewController {

    @IBOutlet weak var tableView: UITableView!
        
    var requestType: RequestType?
    
    required init(type: RequestType) {
        super.init(nibName: "ManageRequestListViewController", bundle: nil)
        self.requestType = type
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = requestType?.title
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView?.register(UINib(nibName: "ManageRequestTableViewCell", bundle: nil), forCellReuseIdentifier: "ManageRequestTableViewCell")
    }
}

extension ManageRequestListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageRequestTableViewCell")
        if let cell = cell {
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // TODOs: update later
        return 20
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let accept = UITableViewRowAction(style: .normal, title: "Accept") { action, index in
            // TODOs: handle accept action later
        }
        accept.backgroundColor = UIColor(hexString: "0x50A298")
        
        let reject = UITableViewRowAction(style: .normal, title: "Reject") { action, index in
            // TODOs: handle reject action later
        }
        reject.backgroundColor = UIColor.red
        
        return [reject, accept]
    }
}
