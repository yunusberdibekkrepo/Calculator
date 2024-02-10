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

    // For mock calculator view controller.
    /// Mock view controller içinde gelen button tag'ine göre #selector(didTapButton) içinde ilgili buton'un tag bilgisinden hangi calculator buton işlemi yapıldığını anlamak için kulanılacaktır.
    init(tag: Int) {
        switch tag {
        case 10:
            self.init(calculatorButton: .allClear)
        case 11:
            self.init(calculatorButton: .plusMinus)
        case 12:
            self.init(calculatorButton: .percentage)
        case 13:
            self.init(calculatorButton: .divide)
        case 14:
            self.init(calculatorButton: .multiply)
        case 15:
            self.init(calculatorButton: .substract)
        case 16:
            self.init(calculatorButton: .add)
        case 17:
            self.init(calculatorButton: .equals)
        case 19:
            self.init(calculatorButton: .float)
        default:
            self.init(calculatorButton: .number(tag)) // 0,1,2,3,4,5,6,7,8,9
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

    // For mock calculator view controller
    var tag: Int {
        switch self {
        case .allClear:
            10
        case .plusMinus:
            11
        case .percentage:
            12
        case .divide:
            13
        case .multiply:
            14
        case .substract:
            15
        case .add:
            16
        case .equals:
            17
        case .number(let number):
            number // 0,1,2,3,4,5,6,7,8,9
        case .float:
            19
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
