//
//  UserProfile.swift
//  wsm
//
//  Created by framgia on 9/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import Himotoki

final class UserProfile: Decodable {
    
    var email: String?
    var gender: String?
    
    static func decode(_ e: Extractor) throws -> UserProfile {
        let profile = UserProfile()
        profile.email = try? e <| "email"
        profile.gender = try? e <| "gender"
        return profile
    }
}
