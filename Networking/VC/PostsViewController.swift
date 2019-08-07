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

    private var posts: [Post] = []
	var networkManager = NetworkManager()
    var user: User?
    var refreshControl = UIRefreshControl()

	override func viewDidLoad() {
		super.viewDidLoad()
        
       
        refreshControl.addTarget(self, action: #selector(refresh), for:.valueChanged)
        self.postsTableView.addSubview(refreshControl)
        
        if let currentUser = user {
            NetworkManager().getPostsForUser(userId: currentUser.id) { (posts) in
                DispatchQueue.main.async {
                    self.posts = posts
                    self.postsTableView.reloadData()
                }
            }
        }
    }
    
    
    func saveNewPost (_ post: Post) {
        self.posts.append(post)
        DispatchQueue.main.async {
            self.postsTableView.reloadData()
        }
    }
    
    func updateCurrentPost (_ post: Post) {
        if let index = posts.firstIndex(where: {$0.id == post.id}) {
            self.posts[index] = post
            DispatchQueue.main.async {
                self.postsTableView.reloadData()
            }
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
            NetworkManager().getPostsForUser(userId: myUser.id) { (posts) in
                self.posts = posts
            DispatchQueue.main.async {
                self.refreshControl.endRefreshing()
                self.postsTableView.reloadData()
            }
        }
    }
}
    func configure(_ user: User) {
        self.user = user
    }

    @IBAction func  didTapAddPostButton(_ sender: UIBarButtonItem) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPostScreenVCID") as! AddPostTableViewController
        vc.delegate = self
        self.show(vc, sender: self)
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
        
        let edit = UITableViewRowAction(style: .normal, title: "Edit") { (action, indexPath) in
            let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "AddPostScreenVCID") as! AddPostTableViewController
            let currentPost = self.posts[indexPath.row]
            vc.delegate = self
            vc.configure(currentPost)
            self.show(vc, sender: self)
        }
        edit.backgroundColor = .blue
        return [remove,edit]
    }
}
    
extension PostsViewController: AddPostTableViewControllerDelegate {
    func createOrUpdatePost(_ post: Post) {
        
        if posts.contains(where: {$0.id == post.id}){
            updateCurrentPost(post)
        } else {
            saveNewPost(post)
        }
    }
}
