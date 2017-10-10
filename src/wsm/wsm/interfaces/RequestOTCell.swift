//
//  RequestOTCell.swift
//  wsm
//
//  Created by DaoLQ on 10/9/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class RequestOTCell: UITableViewCell {
    
    @IBOutlet weak var timeOtLabel: LocalizableLabel!
    @IBOutlet weak var timeCreatedLabel: LocalizableLabel!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var circleView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        circleView.setCircleView()
    }
    
    func updateCell(request: RequestOtModel) {
        timeOtLabel.text = request.getTimeOtString()
        timeCreatedLabel.text = request.getTimeCreatedString()
        statusImageView.image = request.getStatusImage()
    }
}
