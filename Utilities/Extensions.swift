//
//  Extensions.swift
//  Marvel-swiftUI
//
//  Created by Daniel Coria on 12/04/21.
//

import SwiftUI
import Foundation
import Combine
import Firebase

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

extension Query {
//	func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
//		let snapshot = try await self.getDocuments()
//		
//		return try snapshot.documents.map { document in
//			try document.data(as: T.self)
//		}
//	}
	
	func getDocuments<T>(as type: T.Type) async throws -> [T] where T : Decodable {
		let (posts, _) = try await getDocumentsWithSnapshot(as: type)
		return posts
	}
	
	func getDocumentsWithSnapshot<T>(as type: T.Type) async throws -> ([T], DocumentSnapshot?) where T : Decodable {
		let snapshot = try await self.getDocuments()
		
		let posts = try snapshot.documents.map { document in
			try document.data(as: T.self)
		}
		
		return (posts, snapshot.documents.last)
	}
}
