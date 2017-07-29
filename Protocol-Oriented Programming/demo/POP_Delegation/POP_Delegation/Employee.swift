//
//  Employee.swift
//  POP_Delegation
//
//  Created by Thien Liu on 7/28/17.
//  Copyright © 2017 Thien Liu. All rights reserved.
//

import Foundation

// 1. Define a delegate protocol

protocol EmployeeDelegate {
    func update(_ employee: Employee, index: Int)
    func add(_ employee: Employee)
}

struct Employee {
    var name: String
    var phone: String
    var department: String
}
