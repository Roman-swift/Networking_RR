//
//  AddCommentTableViewController.swift
//  Networking
//
//  Created by Роман Родителев on 8/4/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

protocol AddCommentTableViewControllerDelegate: class {
    func createOrUpdateComment(_ comment: Comment)
}

class AddCommentTableViewController: UITableViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var bodyTextField: UITextField!
    @IBOutlet weak var titleItem: UINavigationItem!
    
    private var comments: [Comment] = []
    private var comment: Comment?
    weak var delegate: AddCommentTableViewControllerDelegate?
    var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if comment != nil {
            self.titleItem.title = "Update Comment"
            if let currentComment = self.comment {
                self.nameTextField.text = currentComment.name
                self.emailTextField.text = currentComment.email
                self.bodyTextField.text = currentComment.body
            }
        }
    }
    
    func configure(_ comment: Comment) {
        self.comment = comment
    }
    
    func save() {
        if let name = nameTextField.text, let email = emailTextField.text,
            let body = bodyTextField.text {
            
            let newComment = Comment(id: comments.count+1, name: name, email: email, body: body)
            
            if nameTextField.text == "" || bodyTextField.text == "" {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Empty fields", message: "Required fields are marked *", preferredStyle: .alert)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                        alert.dismiss(animated: true, completion: nil)
                    })
                }
            } else {
                networkManager.createComment(newComment) { serverComment in
                    newComment.id = serverComment.id
                    self.delegate?.createOrUpdateComment(newComment)
                    
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Comment creation", message: "Your comment is creating...", preferredStyle: .alert)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            alert.dismiss(animated: true, completion: nil)
                            print(newComment.id)
                            
                            self.navigationController?.popToRootViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
    
    func update() {
        if let name = nameTextField.text,
            let email = emailTextField.text,
            let body = bodyTextField.text {
            if let commentId = comment?.id {
                let updatedComment = Comment(id: comments.count+1, name: name, email: email, body: body)
                
                networkManager.editComment(updatedComment) { _ in
                    DispatchQueue.main.async {
                        self.delegate?.createOrUpdateComment(updatedComment)
                        
                        let alert = UIAlertController(title: "Comment updation", message: "Your comment is updating...", preferredStyle: .alert)
                        
                        self.present(alert, animated: true, completion: nil)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                            alert.dismiss(animated: true, completion: nil)
                            print(updatedComment.id)
                            
                            self.navigationController?.popViewController(animated: true)
                        })
                    }
                }
            }
        }
    }
    
    @IBAction func didTapSaveButton(_ sender: UIBarButtonItem) {
        if comment == nil {
            save()
        } else  {
            update()
        }
    }
    
    @IBAction func didTapCancel(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddCommentTableViewController: UITextFieldDelegate {
}
