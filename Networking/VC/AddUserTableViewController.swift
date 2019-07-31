//
//  AddUserTableViewController.swift
//  Networking
//
//  Created by Роман Родителев on 7/31/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class AddUserTableViewController: UITableViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var emailTExtField: UITextField!
    @IBOutlet weak var websiteTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var streetTextField: UITextField!
    @IBOutlet weak var suiteTextField: UITextField!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var companyNameTextField: UITextField!
    @IBOutlet weak var catchphrazeTextField: UITextField!
    @IBOutlet weak var bsTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    @IBAction func didTapeToSave(_ sender: UIBarButtonItem) {
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)

    }
    
    
}
