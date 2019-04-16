//
//  PiSelectorViewController.swift
//  Trojan
//
//  Created by Marcus Jackson on 4/9/19.
//  Copyright © 2019 Marcus Jackson. All rights reserved.
//

import Foundation
import UIKit

class PiSelectorViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    static var piNames = [String]()
    
    override func viewDidLoad() {
        RedisCommsStore.setUp(host: "redis-12994.c99.us-east-1-4.ec2.cloud.redislabs.com", port: 12994, auth: "hello")
        
        RedisCommsStore.store?.get(key: "rollcall", object: self)
        tableView.dataSource = self
        tableView.delegate = self
        super.viewDidLoad()
    }
    
    
}

extension PiSelectorViewController: RedisDataGetter {
    func hasGottenData(_ data: Data) {
        let dataString = String(describing: NSString(data: data, encoding: String.Encoding.utf8.rawValue))
        let cutOff = String(dataString.dropFirst(9))
        let cutEnd = String(cutOff.dropLast())
        let brokenString = cutEnd.split(separator: " ")
        
        PiSelectorViewController.piNames = brokenString.map { (sub) -> String in
            return String(sub)
        }
        
        PiSelectorViewController.piNames.remove(at: PiSelectorViewController.piNames.count - 1)
        tableView.reloadData()
    }
}

extension PiSelectorViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("Pi Count is \(PiSelectorViewController.piNames.count)")
        return PiSelectorViewController.piNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = PiSelectorViewCell(style: .default, reuseIdentifier: "reuseCell")
        cell.textLabel?.text = PiSelectorViewController.piNames[indexPath.row]
        
        return cell
    }
}

extension PiSelectorViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let maybeCell = tableView.cellForRow(at: indexPath)
        if let cell = maybeCell, let name = cell.textLabel?.text {
            print("cell is \(name)")
        }
    }
}
