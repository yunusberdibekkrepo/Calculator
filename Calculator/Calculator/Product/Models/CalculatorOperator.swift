//
//  CalculatorOperator.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 4.02.2024.
//

import Foundation

enum CalculatorOperator {
    case divide
    case multiply
    case substract
    case add

    var title: String {
        switch self {
        case .divide:
            "÷"
        case .multiply:
            "x"
        case .substract:
            "-"
        case .add:
            "+"
        }
    }
}
