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

class Networking {
    
    static func getRepos(query: String, completion: @escaping (JSON) -> Void) {
        var apiUrl = URLComponents(string: "https://api.github.com/search/repositories")!
        apiUrl.queryItems = [URLQueryItem(name: "q", value: query)]
        
        URLSession.shared.dataTask(with: URLRequest(url: apiUrl.url!)) { data, _, _ in
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? JSON
            completion(json!)
        }.resume()
    }
    
    static func getCommits(repoName: String, completion: @escaping (JSON) -> Void) {
        var apiUrl = URLComponents(string: "https://api.github.com/search/commits")!
        apiUrl.queryItems = [URLQueryItem(name: "q", value: repoName)]
        var req = URLRequest(url: apiUrl.url!)
        req.addValue("application/vnd.github.cloak-preview", forHTTPHeaderField: "Accept")
        //apiUrl.queryItems = [URLQueryItem(name: "q", value: "repo:"query)]
        
        URLSession.shared.dataTask(with: req) { data, _, _ in
            
            let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? JSON
            completion(json!)
            }.resume()
    }
    
}
