//
//  ArrayExtension.swift
//  Countries
//
//  Created by Rajaram Mohanty on 30/06/19.
//  Copyright © 2019 Rajaram Mohanty. All rights reserved.
//

import Foundation

extension Array {
    
    var firstObject: Element {
        return self[self.startIndex]
    }
    
    var lastObject: Element {
        return self[self.endIndex - 1]
    }
}

