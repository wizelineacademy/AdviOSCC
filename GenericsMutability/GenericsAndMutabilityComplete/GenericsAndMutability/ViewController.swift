//
//  ViewController.swift
//  GenericsAndMutability
//
//  Created by Guillermo Anaya on 7/27/17.
//  Copyright © 2017 Guillermo Anaya. All rights reserved.
//

import UIKit

let repoName = "alamo"

class ViewController: UITableViewController {
    
    var repos: [Repo] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Networking.getRepos(query: repoName) { [weak self] result in
            if let repos = result {
                self?.repos = repos
                DispatchQueue.main.async{
                    self?.tableView.reloadData()
                }
            } else {
                self?.repos = []
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "repoCell", for: indexPath)
        
        cell.textLabel?.text = repos[indexPath.row].name as String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "commits", sender: repos[indexPath.row])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let controller = segue.destination as? CommitsTableViewController, let repo = sender as? Repo else { return }
        var r = repo
        controller.repoName = r.name as String
    }
}

