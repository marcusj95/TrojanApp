//
//  HomeViewController.swift
//  Trojan
//
//  Created by Marcus Jackson on 4/8/19.
//  Copyright © 2019 Marcus Jackson. All rights reserved.
//

import Foundation
import UIKit

class HomeViewController: UIViewController {
    override func viewDidLoad() {
        RedisCommsStore.setUp(host: "redis-12994.c99.us-east-1-4.ec2.cloud.redislabs.com", port: 12994, auth: "hello")
        super.viewDidLoad()
    }
    
    
    @IBAction func scanPressed(_ sender: Any) {
    }
}
