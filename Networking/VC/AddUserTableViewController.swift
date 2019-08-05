//
//  AddUserTableViewController.swift
//  Networking
//
//  Created by Роман Родителев on 7/31/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

protocol AddUserTableViewControllerDelegate: class {
    func createOrUpdateUser(_ user: User)
}

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
    @IBOutlet weak var saveUpdateUser: UIBarButtonItem!
    @IBOutlet weak var addUpdateUserItem: UINavigationItem!
    
    private var users: [User] = []
    private var user: User?
    var networkManager = NetworkManager()
    weak var delegate: AddUserTableViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        if user != nil {
            self.addUpdateUserItem.title = "Update User"
        
        if let currentUser = self.user {
            self.nameTextField.text = currentUser.name
            self.usernameTextField.text = currentUser.username
            self.emailTExtField.text = currentUser.email
            self.phoneTextField.text = currentUser.phone
            self.websiteTextField.text = currentUser.website
            self.streetTextField.text = currentUser.address.street
            self.suiteTextField.text = currentUser.address.suite
            self.cityTextField.text = currentUser.address.city
            self.companyNameTextField.text = currentUser.company.name
            self.catchphrazeTextField.text = currentUser.company.catchPhrase
            self.bsTextField.text = currentUser.company.bs
            }
        }
    }
    
    func configure(_ user: User) {
        self.user = user
    }
    
    func save() {
        if let name = nameTextField.text, let username = usernameTextField.text, let email = emailTExtField.text, let phone = phoneTextField.text, let website = websiteTextField.text, let street = streetTextField.text, let suite = suiteTextField.text, let city = cityTextField.text,let companyName = companyNameTextField.text, let catchPhrase = catchphrazeTextField.text, let bs = bsTextField.text {
            
            let newUser = User(id: users.count + 1, name: name, username: username, email: email, address: Address(street: street, suite: suite, city: city), phone: phone, website: website, company: Company(name: companyName, catchPhrase: catchPhrase, bs: bs))
            
            if (nameTextField.text == "" || usernameTextField.text == "") || (phoneTextField.text == "" || emailTExtField.text == "") {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Empty fields", message: "Required fields are marked *", preferredStyle: .alert)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                }
            } else {
                networkManager.createUser(newUser) { serverUser in
                    newUser.id = serverUser.id
                    self.delegate?.createOrUpdateUser(newUser)
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "User creation", message: "Your user is creating...", preferredStyle: .alert)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            alert.dismiss(animated: true, completion: nil)
                            print(newUser.id)
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
    
    func update() {
         if let name = nameTextField.text, let username = usernameTextField.text, let email = emailTExtField.text, let phone = phoneTextField.text, let website = websiteTextField.text, let street = streetTextField.text, let suite = suiteTextField.text, let city = cityTextField.text,let companyName = companyNameTextField.text, let catchPhrase = catchphrazeTextField.text, let bs = bsTextField.text {
            if let userId = user?.id {
                let updateUser = User(id: userId, name: name, username: username, email: email, address: Address(street: street, suite: suite, city: city), phone: phone, website: website, company: Company(name: companyName, catchPhrase: catchPhrase, bs: bs))
                
                networkManager.editUser(updateUser) { _ in
                    
                    DispatchQueue.main.async {
                        self.delegate?.createOrUpdateUser(updateUser)

                        let alert = UIAlertController(title: "User updation", message: "Your user is updating...", preferredStyle: .alert)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            alert.dismiss(animated: true, completion: nil)
                            print(updateUser.id)
                            
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }
    }

    @IBAction func didTapeToSave(_ sender: UIBarButtonItem) {
        if user == nil {
            save()
        } else  {
            update()
        }
}
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popToRootViewController(animated: true)

    }
}

extension AddUserTableViewController: UITextFieldDelegate {
}
