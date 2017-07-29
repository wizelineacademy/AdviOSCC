//
//  EmployeeDetailViewController.swift
//  POP_Delegation
//
//  Created by Thien Liu on 7/28/17.
//  Copyright © 2017 Thien Liu. All rights reserved.
//

import UIKit

class EmployeeDetailViewController: UIViewController {

    var employee: Employee?
    var index: Int?
    
    // 2 - Give object a delegate optional variable
    
    var delegate: EmployeeDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var departmentTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let employee = self.employee {
            nameTextField.text = employee.name
            departmentTextField.text = employee.department
            phoneTextField.text = employee.phone
        }
    }
    
    @IBAction func save(_ sender: UIButton) {
        if employee == nil {
            employee = Employee(name: nameTextField.text!, phone: phoneTextField.text!, department: departmentTextField.text!)
            guard let employee = employee else { return }
            
            // 3 - Make object send messages to its delegate
            delegate?.add(employee)
        } else {
            employee?.name = nameTextField.text!
            employee?.department = departmentTextField.text!
            employee?.phone = phoneTextField.text!
            
            if let employee = employee, let index = index {
                
                // 3 - Make object send messages to its delegate
                delegate?.update(employee, index: index)
            }
        }
        navigationController?.popToRootViewController(animated: true)
    }
}
