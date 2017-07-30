//
//  AddViewController.swift
//  MVVM
//
//  Created by diego on 7/29/17.
//  Copyright (c) 2017 Diego Navarro. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var viewModel: DetailViewModel!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var amountField: UITextField!
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewModel.title
        nameField.text = viewModel.name
        amountField.text = viewModel.amount
        nameField.becomeFirstResponder()
        
        nameField.addTarget(self, action: #selector(DetailViewController.nameChanged), for: UIControlEvents.editingChanged)
        amountField.addTarget(self, action: #selector(DetailViewController.ammountChanged), for: UIControlEvents.editingChanged)
    }
    
    func nameChanged() {
        viewModel.name = nameField.text!
        resultLabel.text = viewModel.infoText
    }
    
    func ammountChanged() {
        viewModel.amount = amountField.text!
        resultLabel.text = viewModel.infoText
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelPressed(_ sender: AnyObject) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func donePressed(_ sender: AnyObject) {
        viewModel.handleDonePressed()
    }

}

// MARK: - AddViewModelDelegate

extension DetailViewController: DetailViewModelDelegate {
    func handleError(withMessage message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        nameField.becomeFirstResponder()
    }
    
    func dismissAddView() {
        navigationController?.popViewController(animated: true)
    }
}
