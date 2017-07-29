//
//  EmployeeViewController.swift
//  POP_Delegation
//
//  Created by Thien Liu on 7/28/17.
//  Copyright © 2017 Thien Liu. All rights reserved.
//

import UIKit

class EmployeeViewController: UITableViewController {

    // MARK: Sample data
    var employees = [
        Employee(name: "Harry", phone: "123-456-789", department: "Engineer"),
        Employee(name: "Neal", phone: "123-444-555", department: "Finance"),
        Employee(name: "Nigel", phone: "444-777-999", department: "Human Resource"),
        Employee(name: "Simon", phone: "987-456-312", department: "Engineer")
    ]
    
    // MARK: UITableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return employees.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let employee = employees[indexPath.row]
        cell.textLabel?.text = employee.name
        cell.detailTextLabel?.text = "\(employee.department) | Phone: (\(employee.phone))"
        
        return cell
    }
    
    // MARK: UITableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let employee = employees[indexPath.row]
        performSegue(withIdentifier: "segueDetail", sender: employee)
    }
    
    // MARK: Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let detailVC = segue.destination as? EmployeeDetailViewController else { return }
        detailVC.delegate = self
        
        guard let selectedEmployee = sender as? Employee else { return }
        
        if segue.identifier == "segueDetail" {
            detailVC.employee = selectedEmployee
            detailVC.index = (tableView.indexPathForSelectedRow?.row)
            
            // 5 - Tell object that what is now its delegate
            detailVC.delegate = self
        }
    }
}

// 4 - Make object conform to the delegate protocol

extension EmployeeViewController: EmployeeDelegate {
    
    func add(_ employee: Employee) {
        employees.append(employee)
        tableView.reloadData()
    }
    
    func update(_ employee: Employee, index: Int) {
        employees[index] = employee
        tableView.reloadData()
    }
}

