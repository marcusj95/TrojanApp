//
//  RedisDataGetter.swift
//  Trojan
//
//  Created by Marcus Jackson on 4/9/19.
//  Copyright © 2019 Marcus Jackson. All rights reserved.
//

import Foundation

protocol RedisDataGetter {
    func hasGottenData(_ data: Data)
}
