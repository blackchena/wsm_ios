//
//  TimeSheetSummaryViewCell.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/2/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

class TimeSheetSummaryViewCell: UITableViewCell {

    //MARK: IBOutlets
    @IBOutlet weak var circleView1: UIView!
    @IBOutlet weak var circleView2: UIView!
    @IBOutlet weak var circleView3: UIView!
    @IBOutlet weak var circleView4: UIView!
    @IBOutlet weak var circleView5: UIView!

    @IBOutlet weak var finingValueLable: UILabel!
    @IBOutlet weak var paidLeaveValueLable: UILabel!
    @IBOutlet weak var unpaidLeaveValueLable: UILabel!
    @IBOutlet weak var dayOffValueLable: UILabel!
    @IBOutlet weak var overtimeValueLable: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        circleView1.layer.cornerRadius = circleView1.bounds.width / 2
        circleView2.layer.cornerRadius = circleView2.bounds.width / 2
        circleView3.layer.cornerRadius = circleView3.bounds.width / 2
        circleView4.layer.cornerRadius = circleView4.bounds.width / 2
        circleView5.layer.cornerRadius = circleView5.bounds.width / 2
    }

    func setTimeSheetInfo(timeSheet: TimeSheetModel?) {
        finingValueLable.text = "\(timeSheet?.totalFining ?? 0.0)"
        paidLeaveValueLable.text = "\(timeSheet?.numberDayOffHaveSalary ?? 0.0)"
        unpaidLeaveValueLable.text = "\(timeSheet?.numberDayOffNoSalary ?? 0.0)"
        dayOffValueLable.text = "\(timeSheet?.totalDayOff ?? 0.0 )"
        overtimeValueLable.text = "\(timeSheet?.numberOverTime ?? 0.0)"
    }
}
