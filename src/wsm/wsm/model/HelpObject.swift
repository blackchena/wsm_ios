//
//  HelpObject.swift
//  wsm
//
//  Created by Mac Pro on 12/4/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Floaty

class  HelpObject {
    
    var helpObjects: [Help]
    
    init() {
        helpObjects = [Help]()
        let currentDayIcon = UIImage(named: "ic_current_day")
        let overtimeIcon = UIImage(named: "ic_overtime_2")
        helpObjects.append(Help(color: nil, image: currentDayIcon, title: "Current Day"))
        helpObjects.append(Help(color: "#B22222", image: nil, title: "IL/LO/LE/forgot card/forgot checkin/checkout"))
        helpObjects.append(Help(color: "#FF4081", image: nil, title: "WO/IL/LE/LO and enought working time"))
        helpObjects.append(Help(color: "#32CD32", image: nil, title: "No Data/Not enough working time"))
        helpObjects.append(Help(color: "#d10f2184", image: overtimeIcon, title: "Overtime"))
        helpObjects.append(Help(color: "#ff875b", image: nil, title: "Ro: Unpail leave of absence"))
        helpObjects.append(Help(color: "#a2e796", image: nil, title: "P: Paid leave of absence"))
        helpObjects.append(Help(color: "#FFD700", image: nil, title: "Holiday"))
    }
}
