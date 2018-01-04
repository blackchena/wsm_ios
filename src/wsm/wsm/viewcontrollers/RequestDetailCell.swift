//
//  RequestDetailCell.swift
//  wsm
//
//  Created by DaoLQ on 1/4/18.
//  Copyright © 2018 framgia. All rights reserved.
//

import Foundation

class RequestDetailCell: UITableViewCell {
    
    @IBOutlet weak var iconImgView: UIImageView!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func updateCell(item: DetailModel) {
        headerLabel.text = item.header
        valueLabel.text = item.value
        
        let image = UIImage(named: item.imageName)
        let tintedImage = image?.withRenderingMode(.alwaysTemplate)
        iconImgView.image = tintedImage
        iconImgView.tintColor = UIColor.appBarTintColor
    }
}
