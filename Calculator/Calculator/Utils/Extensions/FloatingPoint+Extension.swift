//
//  FloatingPoint+Extension.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 4.02.2024.
//

import Foundation

extension FloatingPoint {
    var isInteger: Bool {
        rounded() == self
    }
}
