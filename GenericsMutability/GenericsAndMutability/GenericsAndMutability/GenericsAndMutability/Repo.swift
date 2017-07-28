//
//  Repo.swift
//  GenericsAndMutability
//
//  Created by Guillermo Anaya on 7/27/17.
//  Copyright © 2017 Guillermo Anaya. All rights reserved.
//

import Foundation

struct Repo {
    let id: Int
    let name: String
    let language: String
    
    init?(object: JSON) {
        guard let id = object["id"] as? Int,
            let name = object["name"] as? String,
            let language = object["language"] as? String else {
                return nil
        }
        self.id = id
        self.name = name
        self.language = language
    }
    
    init(_ id: Int, _ name: String, _ language: String) {
        self.id = id
        self.name = name
        self.language = language
    }
}
