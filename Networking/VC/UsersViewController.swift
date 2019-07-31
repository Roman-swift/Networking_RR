//
//  UsersViewController.swift
//  Networking
//
//  Created by Роман Родителев on 7/29/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController {
    
    @IBOutlet weak var usersTableView: UITableView! {
        didSet {
            usersTableView.dataSource = self
            usersTableView.delegate = self
            let nib = UINib(nibName: "UsersTableViewCell", bundle: nil)
            usersTableView.register(nib, forCellReuseIdentifier: "UsersCellID")
        }
    }
    
    private var users: [User] = []
    var networking = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkManager().getAllUsers() { users in
            
            self.users = users
            
            DispatchQueue.main.async {
                self.usersTableView.reloadData()

            }
        }
    }
    
    func removeUser (_ indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.users.remove(at: indexPath.row)
            self.usersTableView.deleteRows(at: [indexPath], with: .fade)
        }
        
    }
    
    @IBAction func didTapAddUserButton(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "AddUserVCID")
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.delegate = self
        self.present(vc, animated: true)
        vc.popoverPresentationController?.barButtonItem = sender
    }
    @IBAction func didTapBackButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension UsersViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = usersTableView.dequeueReusableCell(withIdentifier: "UsersCellID", for: indexPath) as! UsersTableViewCell
        cell.configure(users[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PostsVCID") as! PostsViewController
        vc.configure(users[indexPath.row])

        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { action, indexPath in
            let currentUser = self.users[indexPath.row]
            
            self.networking.removeUser(currentUser) { _ in
                self.removeUser(indexPath)
            }
        }
        
        return [remove]
    }
}

extension UsersViewController: UIPopoverPresentationControllerDelegate {
}
