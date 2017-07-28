//
//  CommitsTableViewController.swift
//  GenericsAndMutability
//
//  Created by Guillermo Anaya on 7/27/17.
//  Copyright © 2017 Guillermo Anaya. All rights reserved.
//

import UIKit

class CommitsTableViewController: UITableViewController  {
    
    var commits: [Commit] = []
    
    var repoName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Networking.getCommits(repoName: repoName) { [weak self] commits in
            if let commits = commits {
                self?.commits = commits
                DispatchQueue.main.async{
                    self?.tableView.reloadData()
                }
            } else {
                self?.commits = []
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commits.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath)
        cell.textLabel?.text = commits[indexPath.row].author
        cell.detailTextLabel?.text = commits[indexPath.row].message
        return cell
    }
}

