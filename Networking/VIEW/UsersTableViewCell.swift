//
//  UsersTableViewCell.swift
//  Networking
//
//  Created by Роман Родителев on 7/29/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var websiteLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var streetLabel: UILabel!
    @IBOutlet weak var suiteLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var catchPhraseLabel: UILabel!
    @IBOutlet weak var bsLabel: UILabel!
    
    
    
        private var user: User?
    
        func configure(_ user: User) {
            DispatchQueue.main.async {
            self.myView.layer.cornerRadius = 15
            self.myView.layer.masksToBounds = false
            self.myView.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.myView.layer.shadowColor = UIColor.black.cgColor
            self.myView.layer.shadowOpacity = 0.23
            self.myView.layer.shadowRadius = 5
                
            self.user = user
            self.nameLabel.text = user.name
            self.usernameLabel.text = user.username
            self.emailLabel.text = user.email
            self.websiteLabel.text = user.website
            self.phoneLabel.text = user.phone
            self.streetLabel.text = user.address.street
            self.suiteLabel.text = user.address.suite
            self.cityLabel.text = user.address.city
            self.companyNameLabel.text = user.company.name
            self.catchPhraseLabel.text = user.company.catchPhrase
            self.bsLabel.text = user.company.bs
                
            }
        }
    }

