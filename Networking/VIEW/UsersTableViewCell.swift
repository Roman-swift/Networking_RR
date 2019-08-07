//
//  UsersTableViewCell.swift
//  Networking
//
//  Created by Роман Родителев on 7/29/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import UIKit

class UsersTableViewCell: UITableViewCell {
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

