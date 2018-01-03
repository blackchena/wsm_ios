//
//  ManageRequestDetailViewController.swift
//  wsm
//
//  Created by DaoLQ on 1/3/18.
//  Copyright © 2018 framgia. All rights reserved.
//

import UIKit

class ManageRequestDetailViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var items = [DetailModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    init() {
        super.init(nibName: "ManageRequestDetailViewController", bundle: nil)
        modalPresentationStyle = .overCurrentContext
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBAction func closeButtonClick(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func rejectButtonClick(_ sender: Any) {
    }
    
    @IBAction func acceptButtonClick(_ sender: Any) {
    }
}

extension ManageRequestDetailViewController: UITableViewDelegate, UITableViewDataSource {
 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ConfirmCreateRequestCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}
