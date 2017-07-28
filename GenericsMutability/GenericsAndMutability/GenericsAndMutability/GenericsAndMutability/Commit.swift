//
//  Commit.swift
//  GenericsAndMutability
//
//  Created by Guillermo Anaya on 7/27/17.
//  Copyright © 2017 Guillermo Anaya. All rights reserved.
//

import Foundation

struct Commit {
    let author: String
    let message: String
    
    init?(object: JSON) {
        guard let commitJSON = object["commit"] as? JSON,
            let authorJSON = commitJSON["author"] as? JSON,
            let author = authorJSON["name"] as? String,
            let message = commitJSON["message"] as? String else {
                return nil
        }
        
        self.author = author
        self.message = message
    }
    
    init(_ author: String, _ message: String) {
        self.author = author
        self.message = message
    }
}
