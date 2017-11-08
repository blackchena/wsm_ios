//
//  ManageRequestTableViewCell.swift
//  wsm
//
//  Created by DaoLQ on 10/26/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class ManageRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var userAvatarImgView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var statusRequestImgView: UIImageView!
    @IBOutlet weak var leaveTypeLabel: UILabel!
    @IBOutlet weak var timeRequestLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func updateLeaveRequestCell(leaveRequest: RequestLeaveModel) {
        userNameLabel.text = leaveRequest.user?.name
        leaveTypeLabel.text = leaveRequest.leaveType?.name
        statusRequestImgView.image = leaveRequest.status?.getIcon()
        timeRequestLabel.text = leaveRequest.getRequestTimeString()
    }
    
    public func updateOvertimeRequestCell(overtimeRequest: RequestOtModel) {
        userNameLabel.text = overtimeRequest.user?.name
        leaveTypeLabel.text = overtimeRequest.getDurationTimes()
        statusRequestImgView.image = overtimeRequest.status?.getIcon()
        timeRequestLabel.text = overtimeRequest.getTimeOtString()
    }
    
    public func updateOffRequestCell(offRequest: RequestDayOffModel) {
        userNameLabel.text = offRequest.user?.name
        leaveTypeLabel.text = offRequest.totalDayOff
        statusRequestImgView.image = offRequest.status?.getIcon()
        timeRequestLabel.text = offRequest.getRequestTimeString()
    }
}
