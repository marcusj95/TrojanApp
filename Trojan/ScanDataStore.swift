//
//  ScanDataStore.swift
//  Trojan
//
//  Created by Marcus Jackson on 4/10/19.
//  Copyright © 2019 Marcus Jackson. All rights reserved.
//

import Foundation

class ScanDataStore {
    private var lastScan: [String: Any]
    private var trackedAddress: String?
    private var trackedTime: Date?
    
    public init() {
        lastScan = [String:Any]()
    }
    
    public func updateLatestScan(scan: [String: Any]) {
        lastScan = scan
    }
    
    public func trackMacAddress(address: String) {
        trackedAddress = address
        trackedTime = Date()
    }
    
    
    
    public func 😬(str: String) -> Int {
        return 0
    }
}
