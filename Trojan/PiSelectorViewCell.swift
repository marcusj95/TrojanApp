//
//  PiSelectorViewCell.swift
//  Trojan
//
//  Created by Marcus Jackson on 4/9/19.
//  Copyright © 2019 Marcus Jackson. All rights reserved.
//

import Foundation
import UIKit

class PiSelectorViewCell: UITableViewCell {
    init() {
        super.init(style: .default, reuseIdentifier: nil)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
