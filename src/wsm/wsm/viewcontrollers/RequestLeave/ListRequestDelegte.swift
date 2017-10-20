//
//  ListRequestDelegte.swift
//  wsm
//
//  Created by framgia on 10/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation

protocol ListRequestDelegte: class {
    func getListRequests()
    func didCreateRequest()
}
