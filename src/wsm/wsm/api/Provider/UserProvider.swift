//
//  UserProvider.swift
//  wsm
//
//  Created by framgia on 9/19/17.
//  Copyright © 2017 framgia. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
import Moya
import Himotoki

final class UserProvider {

    typealias UserProfileSignal = SignalProducer<UserProfile, RequestErrorType>

    static var userProfile: UserProfile?

    static func getProfile(userId: Int) -> UserProfileSignal {
        return UserProfileSignal { observer, _ in
            ApiProvider.shared.request(
                .getProfile(userId: userId),
                completion: { (result: Result<Response, MoyaError>) in
                    switch result {
                    case .success(let response):
                        let responseProfile = ApiHelper.mapResponseAsDictionary(response)
                        if responseProfile.isSucceeded() {
                            if let data = responseProfile.data,
                                let profile = try? decodeValue(data) as UserProfile {
                                UserProvider.userProfile = profile
                                observer.send(value: profile)
                            }
                            observer.sendCompleted()
                        } else {
                            observer.send(error: RequestErrorType(responseProfile.message))
                        }
                    case .failure(let error):
                        observer.send(error: RequestErrorType(error.localizedDescription))
                    }
            })
        }
    }
}
