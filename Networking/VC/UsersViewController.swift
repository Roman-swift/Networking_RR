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
    
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private var users: [User] = []
    var networkManager = NetworkManager()
    var refreshControl = UIRefreshControl()
    var user: User?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Connectivity.isConnectedToInternet() {
        activityIndicator.startAnimating()
        NetworkManager().getAllUsers() { users in
                self.users = users
            DispatchQueue.main.async {
                self.usersTableView.reloadData()
                self.activityIndicator.stopAnimating()
            }
        }
        } else {
            self.activityIndicator.stopAnimating()
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "No internet connection", message: "Please, check your connection to Internet.", preferredStyle: .alert)
                
                self.present(alert, animated: true, completion: nil)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                    alert.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)

                })
            }
        }
        
        refreshControl.addTarget(self, action: #selector(refresh), for:.valueChanged)
        self.usersTableView.addSubview(refreshControl)
    }
    
    func saveNewUser (_ user: User) {
        self.users.append(user)
        DispatchQueue.main.async {
            self.usersTableView.reloadData()
        }
    }
    func updateCurrentUser (_ user: User) {
        
        if let index = users.firstIndex(where: {$0.id == user.id}) {
            self.users[index] = user
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
    
    @objc func refresh(_ sender: Any) {
        networkManager.getAllUsers { (users) in
            self.users = users
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.usersTableView.reloadData()
            }
        }
    }
    
    @IBAction func didTapAddUserButton(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUserScreenVCID") as! AddUserTableViewController
        vc.delegate = self
        self.show(vc, sender: self)
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
            
            self.networkManager.removeUser(currentUser) { _ in
                self.removeUser(indexPath)
            }
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddUserScreenVCID") as! AddUserTableViewController
            let currentUser = self.users[indexPath.row]
            vc.delegate = self
            vc.configure(currentUser)
            self.show(vc, sender: self)
        }
        edit.backgroundColor = .blue
        return [remove,edit]
    }
    
}

extension UsersViewController: AddUserTableViewControllerDelegate {
  
    func createOrUpdateUser(_ user: User) {
        
         if users.contains(where: {$0.id == user.id}){
            updateCurrentUser(user)
        } else {
            saveNewUser(user)
        }
    }
}
