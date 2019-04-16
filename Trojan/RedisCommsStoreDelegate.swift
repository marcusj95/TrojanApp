//
//  RedisCommsStoreDelegate.swift
//  ChartTest
//
//  Created by Marcus Jackson on 3/18/19.
//  Copyright © 2019 Marcus Jackson. All rights reserved.
//

import Foundation

/**
 Protocol to be attached to to classes looking to display data from the Pi.
 */
protocol RedisCommsStoreDelegate {
    func didReceiveRedisResponse(data: Data)
}
