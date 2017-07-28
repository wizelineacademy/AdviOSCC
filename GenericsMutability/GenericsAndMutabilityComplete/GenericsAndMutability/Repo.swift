//
//  Repo.swift
//  GenericsAndMutability
//
//  Created by Guillermo Anaya on 7/27/17.
//  Copyright © 2017 Guillermo Anaya. All rights reserved.
//

import Foundation

final class Box<A> {
    var unbox: A
    init(_ value: A) { self.unbox = value }
}

struct Repo {
    
    fileprivate var _name: Box<NSMutableString>
    var name: NSMutableString {
        mutating get {
            if !isKnownUniquelyReferenced(&_name) {
                _name = Box(_name.unbox.mutableCopy() as! NSMutableString)
                print("Making a copy")
            }
            return _name.unbox
        }
    }
    
    let id: Int
    //let name: String
    let language: String
    
    init?(object: JSON) {
        guard let id = object["id"] as? Int,
            let name = object["name"] as? String,
            let language = object["language"] as? String else {
                return nil
        }
        self.id = id
        let nsstring = NSString(string: name)
        self._name = Box(nsstring.mutableCopy() as! NSMutableString)
        self.language = language
    }
    
    init(_ id: Int, _ name: String, _ language: String) {
        self.id = id
        let nsstring = NSString(string: name)
        self._name = Box(nsstring.mutableCopy() as! NSMutableString)
        self.language = language
    }
}
