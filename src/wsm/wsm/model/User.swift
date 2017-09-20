//
//  LoginUser.swift
//  wsm
//
//  Created by nguyen.van.hung on 6/30/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import Foundation
import Himotoki

final class User: Decodable {

    var authenToken: String?
    var isManager: Bool?

    static func decode(_ e: Extractor) throws -> User {
        let user = User()
        user.authenToken = try? e <| "authen_token"
        user.isManager = try? e <| "is_manager"
        return user
    }
}
