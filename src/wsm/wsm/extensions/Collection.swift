//
//  Collection.swift
//  wsm
//
//  Created by Lê Thanh Quang on 10/16/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import UIKit

extension Collection where Indices.Iterator.Element == Index {

    //This way you'll never hit Index out of range
    //You'll have to check if the item is nil
    //ref: https://stackoverflow.com/a/37225027
    subscript (safe index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
