//
//  Sequence+General.swift
//  AKOCommonToolsKit
//
//  Created by zitao on 2022/12/27.
//

import Foundation

extension Sequence where Element: Equatable {
    public func count(where isIncluded: (Element) -> Bool) -> Int {
        self.filter(isIncluded).count
    }
}

extension Sequence where Element: Hashable {
    public func uniqued() -> [Element] {
        var seen = Set<Element>()
        return filter { seen.insert($0).inserted }
    }
}

extension Sequence {
    public func uniqued<T: Equatable>(_ keyPath: KeyPath<Element, T>) -> [Element] {
        uniqued { $0[keyPath: keyPath] == $1[keyPath: keyPath] }
    }
    public func uniqued(comparator: (Element, Element) -> Bool) -> [Element] {
        var result: [Element] = []
        for element in self {
            if result.contains(where: {comparator(element, $0)}) {
                continue
            }
            result.append(element)
        }
        return result
    }
    
}



 


