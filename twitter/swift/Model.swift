//
//  Model.swift
//  twitter
//
//  Created by Danyil ZBOROVKYI on 6/29/19.
//  Copyright © 2019 Danyil ZBOROVKYI. All rights reserved.
//

import Foundation

struct Tweet: CustomStringConvertible {
    let name: String
    let text: String
    var date: String
    
    var description: String {
        return "(\(name) : \(text)\n \(date))"
    }
}



















