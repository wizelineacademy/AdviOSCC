//
//  Networking.swift
//  GenericsAndMutability
//
//  Created by Guillermo Anaya on 7/27/17.
//  Copyright © 2017 Guillermo Anaya. All rights reserved.
//

import Foundation

typealias JSON = [AnyHashable: Any]

var webserviceURL = URL(string: "https://api.github.com")!

struct Resource<A> {
    let path: String
    let parse: (JSON) -> A?
}

extension Resource {
    func loadAsynchronously(query: String, callback: @escaping (A?) -> ()) {
        var apiUrl = URLComponents(string: "\(webserviceURL)\(path)")!
        apiUrl.queryItems = [URLQueryItem(name: "q", value: query)]
        var req = URLRequest(url: apiUrl.url!)
        req.addValue("application/vnd.github.cloak-preview", forHTTPHeaderField: "Accept")
        
        let session = URLSession.shared
        session.dataTask(with: req) { data, response, error in
            let json = data.flatMap {
                try? JSONSerialization.jsonObject(with: $0, options: []) as? JSON
            }
            guard let j = json else { return }
            callback(j.flatMap(self.parse))
            }.resume()
    }
}

class Networking {
    
    private func jsonArray<A>(_ transform: @escaping (Any) -> A?) -> (Any) -> [A]? {
        return { array in
            guard let array = array as? [Any] else {
                return nil
            }
            return array.flatMap(transform)
        }
    }
    
    static func getRepos(query: String, completion: @escaping ([Repo]?) -> Void) {
        let resource = Resource(path: "/search/repositories") { json -> [Repo]? in
            if let items = json["items"] as? [JSON] {
                return items.flatMap(Repo.init)
            }
            return nil
        }
        resource.loadAsynchronously(query: query, callback: completion)
    }
    
    static func getCommits(repoName: String, completion: @escaping ([Commit]?) -> Void) {
        let resource = Resource(path: "/search/commits") { json -> [Commit]? in
            if let items = json["items"] as? [JSON] {
                return items.flatMap(Commit.init)
            }
            return nil
        }
        resource.loadAsynchronously(query: repoName, callback: completion)
    }
    
}
