//
//  ButtonModel.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 1.02.2024.
//

import UIKit

enum CalculatorButton {
    case allClear
    case plusMinus
    case percentage
    case divide
    case multiply
    case substract
    case add
    case equals
    case number(Int)
    case float

    init(calculatorButton: CalculatorButton) {
        switch calculatorButton {
        case .allClear, .plusMinus, .percentage, .divide, .multiply, .substract, .add, .equals, .float:
            self = calculatorButton
        case .number(let value):
            if value.description.count == 1 {
                self = calculatorButton
            } else {
                fatalError("CalculatorButton.number Int was not 1 digit during init.")
            }
        }
    }
}

extension CalculatorButton {
    var title: String {
        switch self {
        case .allClear:
            "AC"
        case .plusMinus:
            "+/-"
        case .percentage:
            "%"
        case .divide:
            "÷"
        case .multiply:
            "x"
        case .substract:
            "-"
        case .add:
            "+"
        case .equals:
            "="
        case .number(let value):
            value.description
        case .float:
            "."
        }
    }

    var color: UIColor {
        switch self {
        case .allClear, .plusMinus, .percentage:
            .lightGray
        case .divide, .multiply, .substract, .add, .equals:
            .systemOrange
        case .number, .float:
            .darkGray
        }
    }

    var selectedColor: UIColor? {
        switch self {
        case .allClear, .plusMinus, .percentage, .equals, .number, .float:
            nil

        case .divide, .multiply, .substract, .add:
            .white
        }
    }
}
