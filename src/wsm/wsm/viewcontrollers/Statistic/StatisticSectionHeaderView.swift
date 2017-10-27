//
//  StatisticSectionHeaderView.swift
//  wsm
//
//  Created by framgia on 10/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import InAppLocalize

class StatisticSectionHeaderView: UITableViewCell {

    @IBOutlet weak var segmentControl: UISegmentedControl!

    var sectionChangedAction: ((_ index: Int) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()

        segmentControl.setTitle(LocalizationHelper.shared.localized("current_month"), forSegmentAt: 0)
        segmentControl.setTitle(LocalizationHelper.shared.localized("current_year"), forSegmentAt: 1)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func sectionChanged(_ sender: Any) {
        if let segment = sender as? UISegmentedControl {
            sectionChangedAction?(segment.selectedSegmentIndex)
        }
    }

    func setSegmentSelected(index: Int) {
        segmentControl.selectedSegmentIndex = index
    }
}
