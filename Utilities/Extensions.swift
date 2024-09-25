//
//  Extensions.swift
//  Marvel-swiftUI
//
//  Created by Daniel Coria on 12/04/21.
//

import SwiftUI
import Foundation
import Combine

extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}

extension AnyPublisher {
    
    static func success(_ value: Output) -> Self {
        Just(value)
            .setFailureType(to: Failure.self)
            .eraseToAnyPublisher()
    }
    
    static func failure(_ error: Failure) -> Self {
        Fail<Output, Failure>(error: error)
            .eraseToAnyPublisher()
    }
}


// MARK: - Single Value Result

extension Publisher {
    typealias PublisherResult = Result<Self.Output, Self.Failure>
    typealias PublisherResultCompletion = (PublisherResult) -> Void
    
    func receiveOnMain() -> AnyPublisher<Output, Failure> {
        receive(on: RunLoop.main).eraseToAnyPublisher()
    }
    
    func result(_ completion: @escaping PublisherResultCompletion) -> AnyCancellable {
        sink(
            receiveCompletion: {
                switch $0 {
                case .failure(let error):
                    completion(.failure(error))
                case .finished:
                    break
                }
            },
            receiveValue: {
                completion(.success($0))
            }
        )
    }
}
