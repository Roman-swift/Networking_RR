//
//  AddPostTableViewController.swift
//  Networking
//
//  Created by Роман Родителев on 8/4/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

protocol AddPostTableViewControllerDelegate: class {
    func createOrUpdatePost(_ post: Post)
}

class AddPostTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var addUpdatePostItem: UINavigationItem!
    
    private var posts: [Post] = []
    private var post: Post?
    weak var delegate: AddPostTableViewControllerDelegate?
    var networkManager = NetworkManager()

    override func viewDidLoad() {
        super.viewDidLoad()
            if post != nil {
            self.addUpdatePostItem.title = "Update User"
            if let currentPost = self.post {
                self.titleTextField.text = currentPost.title
                self.bodyTextField.text = currentPost.body
            }
        }
    }
    
    func configure(_ post: Post) {
        self.post = post
    }
    
    func save() {
        if let title = titleTextField.text,
            let body = bodyTextField.text {
            
            let newPost = Post(id: posts.count + 1, title: title, body: body)
            
            if titleTextField.text == "" || bodyTextField.text == "" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Empty fields", message: "Required fields are marked *", preferredStyle: .alert)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                }
            } else {
                networkManager.createPost(newPost) { serverPost in
                    newPost.id = serverPost.id
                    self.delegate?.createOrUpdatePost(newPost)
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Post creation", message: "Your post is creating...", preferredStyle: .alert)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            alert.dismiss(animated: true, completion: nil)
                            print(newPost.id)
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
    
    func update() {
        if let title = titleTextField.text,
            let body = bodyTextField.text {
            if let postId = post?.id {
                let updatedPost = Post(id: postId, title: title, body: body)

                networkManager.editPost(updatedPost) { _ in
                    DispatchQueue.main.async {
                        self.delegate?.createOrUpdatePost(updatedPost)
                        
                        let alert = UIAlertController(title: "Post updation", message: "Your post is updating...", preferredStyle: .alert)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            alert.dismiss(animated: true, completion: nil)
                            print(updatedPost.id)
                            
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }
    }

    @IBAction func didTapSaveButton(_ sender: UIBarButtonItem) {
        if post == nil {
            save()
        } else  {
            update()
        }
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
self.navigationController?.popViewController(animated: true)
        
        }
    }

extension AddPostTableViewController: UITextFieldDelegate {
}
