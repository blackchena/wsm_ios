//
//  HelpModel.swift
//  wsm
//
//  Created by Mac Pro on 12/4/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

class Help {
    
    var color: String?
    var image: UIImage?
    var title: String
    
    init(color: String?, image: UIImage?, title: String) {
        self.color = color
        self.image = image
        self.title = title
    }
}
