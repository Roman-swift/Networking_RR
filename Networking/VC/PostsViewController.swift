//
//  ViewController.swift
//  Networking
//
//  Created by Viacheslav Bilyi on 7/22/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class PostsViewController: UIViewController {

	@IBOutlet weak var postsTableView: UITableView! {
		didSet {
			postsTableView.delegate = self
			postsTableView.dataSource = self

			let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
			postsTableView.register(nib, forCellReuseIdentifier: "PostCellID")
		}
	}

    var posts: [Post] = []
	var networkManager = NetworkManager()
    var user: User?
    var refreshControl = UIRefreshControl()

	override func viewDidLoad() {
		super.viewDidLoad()
        
        if let myUser = user {
            NetworkManager().getPostsForUser(myUser.id) { (posts) in
                self.posts = posts
                DispatchQueue.main.async {
                    self.postsTableView.reloadData()
                }
            }
        }
        
        refreshControl.addTarget(self, action: #selector(refresh), for:.valueChanged)
        self.postsTableView.addSubview(refreshControl)
    }
    
    func saveNewPost (_ post: Post) {
        self.posts.append(post)
        DispatchQueue.main.async {
            self.postsTableView.reloadData()
        }
    }
    
    func removePost (_ indexPath: IndexPath) {
        DispatchQueue.main.async {
            self.posts.remove(at: indexPath.row)
            self.postsTableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    @objc func refresh(_ sender: Any) {
        if let myUser = user {
            NetworkManager().getPostsForUser(myUser.id) { (posts) in
                self.posts = posts
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.postsTableView.reloadData()
            }
        }
    }
}

    @IBAction func  didTapAddPostButton(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPostScreenVCID") as! AddPostTableViewController
        vc.delegate = self
        self.show(vc, sender: self)
    }

        func configure(_ user: User) {
            self.user = user
    }
}


extension PostsViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return posts.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "PostCellID", for: indexPath) as! PostTableViewCell
		cell.configure(posts[indexPath.row])
		return cell
	}
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentsVCID") as! CommentsViewController
        vc.configure(posts[indexPath.row])
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let remove = UITableViewRowAction(style: .destructive, title: "Remove") { action, indexPath in
            let currentPost = self.posts[indexPath.row]
            
            self.networkManager.removePost(currentPost) { _ in
                self.removePost(indexPath)
            }
        }
        
        return [remove]
    }
}
    
extension PostsViewController: AddPostTableViewControllerDelegate {
    func save(_ post: Post) {
        saveNewPost(post)
    }
}
