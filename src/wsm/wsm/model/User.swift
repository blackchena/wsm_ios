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

    var userId: String?
    var fullname: String?
    var gender: String?
    var dob: String?
    var phone: String?
    var email: String?
    var avatarUrl: String?

    static func decode(_ extractor: Extractor) throws -> User {
        let user = User()
        user.userId = try? extractor <| "userId"
        user.fullname = try? extractor <| "fullname"
        user.gender = try? extractor <| "gender"
        user.dob = try? extractor <| "dob"
        user.phone = try? extractor <| "phone"
        user.email = try? extractor <| "email"
        user.avatarUrl = try? extractor <| "avatar"
        return user
    }
}
