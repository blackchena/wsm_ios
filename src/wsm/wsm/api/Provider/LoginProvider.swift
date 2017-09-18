//
//  LoginProvider.swift
//  wsm
//
//  Created by nguyen.van.hung on 6/30/17.
//  Copyright © 2017 nguyen.van.hung. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ReactiveSwift
import Result
import Moya
import Himotoki

enum LoginType {
    case facebook
    case twitter
    case google
}

final class LoginProvider {

    typealias ProvideSignal = SignalProducer<User, RequestErrorType>
    typealias LogoutProvideSignal = SignalProducer<Void, RequestErrorType>

    static var loginUser: User?

    static func login(with email: String, password: String) -> ProvideSignal {
        return ProvideSignal { observer, _ in
            ApiProvider.shared.request(
                .login(email, password),
                completion: { (result: Result<Response, MoyaError>) in
                    switch result {
                    case .success(let response):
                        let responseProfile = ApiHelper.mapResponseAsDictionary(response)
                        if responseProfile.isSucceeded() {
                            if let data = responseProfile.data,
                                let loginUser = try? decodeValue(data) as User {
                                LoginProvider.loginUser = loginUser
                                observer.send(value: loginUser)
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

    static func logout() -> LogoutProvideSignal {
        return LogoutProvideSignal { _, _ in
            ApiProvider.shared.request(.logout, completion: { (_) in

            })
            LoginProvider.loginUser = nil
        }
    }
}
