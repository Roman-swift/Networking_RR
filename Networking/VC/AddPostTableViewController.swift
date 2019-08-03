//
//  AddPostTableViewController.swift
//  Networking
//
//  Created by Роман Родителев on 8/4/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

protocol AddPostTableViewControllerDelegate: class {
    func save(_ post: Post)
}

class AddPostTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    
    weak var delegate: AddPostTableViewControllerDelegate?

  
    
}
extension AddPostTableViewController: UITextFieldDelegate {
}
