//
//  Connectivity.swift
//  Networking
//
//  Created by Роман Родителев on 8/10/19.
//  Copyright © 2019 Viacheslav Bilyi. All rights reserved.
//

import Foundation
import Alamofire

class Connectivity {
    class func isConnectedToInternet() ->Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}
