//
//  CardView.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/2/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit
import MaterialComponents


@IBDesignable
class CardView: UIView {

    override class var layerClass: AnyClass {
        return MDCShadowLayer.self
    }

    func setDefaultElevation() {
        self.shadowLayer.elevation = MDCShadowElevationCardResting
    }

    var shadowLayer: MDCShadowLayer {
        return self.layer as! MDCShadowLayer
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        setDefaultElevation()
    }
}
