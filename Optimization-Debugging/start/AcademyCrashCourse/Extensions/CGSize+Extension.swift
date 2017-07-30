//
//  CGSize+Extension.swift
//  AcademyCrashCourse
//
//  Created by Jorge R Ovalle Z on 7/24/17.
//  Copyright © 2017 Test. All rights reserved.
//

import UIKit

extension CGSize {
    static func square(_ side: CGFloat) -> CGSize {
        return CGSize(width: side, height: side)
    }
}
