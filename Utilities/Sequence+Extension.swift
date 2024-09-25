//
//  Sequence+Extensions.swift
//
//  Created by Alex Pezzi on 2021-07-12.
//

import Foundation

public extension Sequence where Element: Hashable {
    
    func uniqued() -> [Element] {
        var set = Set<Element>()
        return filter { set.insert($0).inserted }
    }
    
    func toSet() -> Set<Element> {
        Set(self)
    }
}

public extension Sequence {
    
    func uniqued<Type: Hashable>(by keyPath: KeyPath<Element, Type>) -> [Element] {
        var set = Set<Type>()
        return filter { set.insert($0[keyPath: keyPath]).inserted }
    }
    
    // Returns fthe first element in `self` that `transform` maps to a `.some`.
    func firstNonNil<Result>(_ transform: (Element) throws -> Result?) rethrows -> Result? {
        for value in self {
            if let value = try transform(value) {
                return value
            }
        }
        return nil
    }
    
    func sortedAscendingOrder<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] < b[keyPath: keyPath]
        }
    }
    
    func sortedDescendingOrder<T: Comparable>(by keyPath: KeyPath<Element, T>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath] > b[keyPath: keyPath]
        }
    }
    
    func sortedAscendingOrderLocalized(by keyPath: KeyPath<Element, String>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath].localizedCompare(b[keyPath: keyPath]) == .orderedAscending
        }
    }
    
    func sortedDescendingOrderLocalized(by keyPath: KeyPath<Element, String>) -> [Element] {
        sorted { a, b in
            a[keyPath: keyPath].localizedCompare(b[keyPath: keyPath]) == .orderedDescending
        }
    }
    
    func asyncMap<T>(
        _ transform: (Element) async throws -> T
    ) async rethrows -> [T] {
        var values = [T]()
        
        for element in self {
            try await values.append(transform(element))
        }
        
        return values
    }
    
    func concurrentForEach(
        _ operation: @escaping (Element) async -> Void
    ) async {
        // A task group automatically waits for all of its
        // sub-tasks to complete, while also performing those
        // tasks in parallel:
        await withTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    await operation(element)
                }
            }
        }
    }
    
    func concurrentThrowingForEach(
        _ operation: @escaping (Element) async throws -> Void
    ) async throws {
        // A task group automatically waits for all of its
        // sub-tasks to complete, while also performing those
        // tasks in parallel:
        await withThrowingTaskGroup(of: Void.self) { group in
            for element in self {
                group.addTask {
                    try await operation(element)
                }
            }
        }
    }
    
    func concurrentMap<T>(
        _ transform: @escaping (Element) async throws -> T
    ) async throws -> [T] {
        let tasks = map { element in
            Task {
                try await transform(element)
            }
        }
        
        return try await tasks.asyncMap { task in
            try await task.value
        }
    }
}
