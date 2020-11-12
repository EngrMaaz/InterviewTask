//
//  UITableViewCell+Extension.swift
//  bitmal
//
//  Created by mac on 17/10/2019.
//  Copyright © 2019 Logicon. All rights reserved.
//

import UIKit

extension UITableViewCell {
    static func identifier() -> String {
        return (String(describing: self))
    }
}
