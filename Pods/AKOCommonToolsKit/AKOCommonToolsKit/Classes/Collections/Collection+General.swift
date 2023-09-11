//
//  Collection+General.swift
//  AKOCommonToolsKit
//
//  Created by zitao on 2022/12/27.
//

import Foundation

extension Collection {
    public subscript (safe index: Self.Index) -> Iterator.Element? {
        let value = (startIndex ..< endIndex).contains(index) ? self[index] : nil
        assert((value != nil), "Out of bounds of Collection")
        return value
    }
}

 


