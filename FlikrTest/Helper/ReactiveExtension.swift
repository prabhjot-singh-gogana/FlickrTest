//
//  ReactiveExtension.swift
//  FlikrTest
//
//  Created by Prabhjot Singh on 03/06/21.
//  Copyright © 2021 Gogana Solutions. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// Extension for Behavior Relay for adding and removing items
extension BehaviorRelay where Element == Array<FlickrPhoto> {

    func add(element: Element.Element) {
        var array = self.value
        array.append(element)
        self.accept(array)
    }
    func removeItem(element: Element.Element) {
        var array = self.value
        if let index = array.firstIndex(where: {$0.picID == element.picID}){
            array.remove(at: index)
        }
        self.accept(array)
    }
}
