//
//  RxExtensions.swift
//  last.fm-rewrite-ios
//
//  Created by SMBA on 19.04.2022..
//

import RxCocoa

public extension BehaviorRelay where Element: RangeReplaceableCollection {
    
    func append(_ subElement: Element.Element) {
        var newValue = value
        newValue.append(subElement)
        accept(newValue)
    }
    
    func insert(contentsOf newSubelements: Element, at index: Element.Index) {
        var newValue = value
        newValue.insert(contentsOf: newSubelements, at: index)
        accept(newValue)
    }
    
    func removeAll() {
        var array = value
        array.removeAll()
        accept(array)
    }
}
