//
//  Floaty.swift
//  wsm
//
//  Created by framgia on 9/25/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Floaty

extension Floaty {
    func addButton(title: String, hexColor: String, image: UIImage? = nil) {
        let item = FloatyItem()
        item.buttonColor = UIColor.init(hexString: hexColor)
        item.icon = image
        item.title = title
        item.titleColor = UIColor.white
        item.titleLabel.backgroundColor = UIColor.init(hexString: "#333333")
        item.titleLabel.textAlignment = .center
        item.titleLabel.frame = CGRect(x: item.titleLabel.frame.minX - 5,
                                       y: item.titleLabel.frame.minY - 5,
                                       width: item.titleLabel.frame.width + 10,
                                       height: item.titleLabel.frame.height + 10)
        addItem(item: item)
    }
}
