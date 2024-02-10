//
//  UIStackCalculatorViewController.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 9.02.2024.
//

import UIKit

final class UIStackCalculatorViewController: UIViewController {
    // MARK: - Variables

    private let firstRow: [CalculatorButton] = [.allClear, .plusMinus, .percentage, .divide]
    private let secondRow: [CalculatorButton] = [.number(7), .number(8), .number(9), .multiply]
    private let thirdRow: [CalculatorButton] = [.number(4), .number(5), .number(6), .substract]
    private let fourthRow: [CalculatorButton] = [.number(1), .number(2), .number(3), .add]
    private let fifthRow: [CalculatorButton] = [.number(0), .float, .equals]

    private var headerTitleText: String = "0"
    private var currentNumber: CurrentNumber = .firstNumber
    private var currentOperator: CalculatorOperator? = nil
    private var previousNumber: String? = nil

    private var firstNumber: String? = nil {
        didSet {
            self.headerTitleText = self.firstNumber ?? "0"
        }
    }

    private var secondNumber: String? = nil {
        didSet {
            self.headerTitleText = self.secondNumber ?? "0"
        }
    }

    // MARK: - UI Components

    private let headerView: UIView = .init()
    private let headerViewTextLabel: TitleLabel = .init(textAlignment: .right)
    private let bodyView: UIView = .init()
    private let firstStackView: UIStackView = .init()
    private let secondStackView: UIStackView = .init()
    private let thirdStackView: UIStackView = .init()
    private let fourthStackView: UIStackView = .init()
    private let fifthStackView: UIStackView = .init()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpHeaderView()
        setUpHeaderText()
        setUpBodyView()

        createStackView(stackView: self.firstStackView, anchor: self.bodyView.topAnchor, calcButtons: self.firstRow)
        createStackView(stackView: self.secondStackView, anchor: self.firstStackView.bottomAnchor, calcButtons: self.secondRow)
        createStackView(stackView: self.thirdStackView, anchor: self.secondStackView.bottomAnchor, calcButtons: self.thirdRow)
        createStackView(stackView: self.fourthStackView, anchor: self.thirdStackView.bottomAnchor, calcButtons: self.fourthRow)
        createStackView(stackView: self.fifthStackView, anchor: self.fourthStackView.bottomAnchor, calcButtons: self.fifthRow)
    }
}

extension UIStackCalculatorViewController {
    private func updateHeaderTitle() {
        DispatchQueue.main.async { [weak self] in
            self?.headerViewTextLabel.text = self?.headerTitleText
        }
    }

    @objc
    private func didTapButton(_ sender: UIButton) {
        let calcButton = CalculatorButton(tag: sender.tag)
        didSelectButton(calcButton)
    }
}

// MARK: - SetUp stack view.

extension UIStackCalculatorViewController {
    private func setUpHeaderView() {
        self.headerView.translatesAutoresizingMaskIntoConstraints = false
        self.headerView.backgroundColor = .systemBackground
        view.addSubview(self.headerView)

        NSLayoutConstraint.activate([
            self.headerView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            self.headerView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: self.headerView.trailingAnchor, multiplier: 0),
            self.headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }

    private func setUpHeaderText() {
        self.headerViewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        self.headerViewTextLabel.text = self.headerTitleText
        self.headerView.addSubview(self.headerViewTextLabel)

        NSLayoutConstraint.activate([
            self.headerView.trailingAnchor.constraint(equalToSystemSpacingAfter: self.headerViewTextLabel.trailingAnchor, multiplier: 1),
            self.headerViewTextLabel.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
            self.headerViewTextLabel.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor)

        ])
    }

    private func setUpBodyView() {
        self.bodyView.translatesAutoresizingMaskIntoConstraints = false
        self.bodyView.backgroundColor = .systemBackground
        view.addSubview(self.bodyView)

        NSLayoutConstraint.activate([
            self.bodyView.topAnchor.constraint(equalToSystemSpacingBelow: self.headerView.bottomAnchor, multiplier: 0),
            self.bodyView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor),
            self.bodyView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor),
            self.bodyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func createStackView(stackView: UIStackView, anchor: NSLayoutYAxisAnchor, calcButtons: [CalculatorButton]) {
        self.bodyView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.distribution = .equalSpacing
        stackView.alignment = .center

        for calcButton in calcButtons {
            let button = self.createCalcButton(with: calcButton)
            stackView.addArrangedSubview(button)
        }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: anchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: self.bodyView.leadingAnchor, multiplier: 1),
            self.bodyView.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
        ])
    }

    private func createCalcButton(with calcButton: CalculatorButton) -> UIButton {
        let button = UIButton()

        button.setAttributedTitle(
            NSAttributedString(string: calcButton.title, attributes: [
                .font: UIFont.systemFont(ofSize: 42, weight: .regular),
                .foregroundColor: UIColor.white
            ]),
            for: .normal)

        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = calcButton.color
        button.configuration?.cornerStyle = .capsule
        button.tag = calcButton.tag
        button.addTarget(self, action: #selector(self.didTapButton(_:)), for: .touchUpInside)

        switch calcButton {
        case .number(let number) where number == 0:
            button.widthAnchor.constraint(equalToConstant: 185).isActive = true
            button.heightAnchor.constraint(equalToConstant: 85).isActive = true
        default:
            button.widthAnchor.constraint(equalToConstant: 85).isActive = true
            button.heightAnchor.constraint(equalToConstant: 85).isActive = true
        }

        return button
    }
}

extension UIStackCalculatorViewController {
    private func didSelectButton(_ calcButton: CalculatorButton) {
        switch calcButton {
        case .allClear:
            self.didSelectAllClear()
        case .plusMinus:
            self.didSelectPlusMinus()
        case .percentage:
            self.didSelectPlusMinus()
        case .divide:
            self.didSelectOperator(.divide)
        case .multiply:
            self.didSelectOperator(.multiply)
        case .substract:
            self.didSelectOperator(.substract)
        case .add:
            self.didSelectOperator(.add)
        case .equals:
            self.didSelectEquals()
        case .number(let number):
            self.didSelectNumber(number)
        case .float:
            self.didSelectFloat()
        }

        self.updateHeaderTitle()
    }

    private func didSelectOperator(_ selectedOperator: CalculatorOperator) {
        switch self.currentNumber {
        case .firstNumber:
            self.currentNumber = .secondNumber
            self.currentOperator = selectedOperator
        case .secondNumber:
            if let currentOperator, let number1 = firstNumber?.toDouble, let number2 = secondNumber?.toDouble {
                let result = self.getOperatorResult(currentOperator, number1, number2)
                let resultStr = result.isInteger ? result.toInt?.description : result.description

                self.secondNumber = nil
                self.firstNumber = resultStr
                self.currentNumber = .firstNumber
                self.currentOperator = selectedOperator
            } else {
                currentOperator = selectedOperator
            }
        }
    }

    private func didSelectNumber(_ number: Int) {
        switch self.currentNumber {
        case .firstNumber:
            if var number1 = firstNumber {
                number1.append(number.description)
                self.firstNumber = number1
                self.previousNumber = number1
            } else {
                self.firstNumber = number.description
                self.previousNumber = number.description
            }
        case .secondNumber:
            if var number2 = secondNumber {
                number2.append(number.description)
                self.secondNumber = number2
                self.previousNumber = number2
            } else {
                self.secondNumber = number.description
                self.previousNumber = number.description
            }
        }
    }

    //TODO: NUMB+NUMB2 EQUALS EQULAS SUBSTRACT ÇALIŞMIYOR.
    private func didSelectEquals() {
        if let currentOperator, let number1 = firstNumber?.toDouble, let number2 = secondNumber?.toDouble {
            let result = self.getOperatorResult(currentOperator, number1, number2)
            let resultString = result.isInteger ? result.toInt?.description : result.description

            self.secondNumber = nil
            self.firstNumber = resultString
            self.previousNumber = number2.description
            self.currentNumber = .secondNumber
            print("1")
        } else if let currentOperator, let number1 = firstNumber?.toDouble, let number2 = previousNumber?.toDouble {
            let result = self.getOperatorResult(currentOperator, number1, number2)
            let resultString = result.isInteger ? result.toInt?.description : result.description

            self.firstNumber = resultString
            self.currentNumber = .secondNumber
            print("2")
        }
    }

    private func didSelectFloat() {
        switch self.currentNumber {
        case .firstNumber:
            if var number1 = firstNumber {
                guard !number1.contains(".") else { return }

                number1.append(".")
                self.firstNumber = number1
            } else {
                self.firstNumber = "0."
            }
        case .secondNumber:
            if var number2 = secondNumber {
                guard !number2.contains(".") else { return }

                number2.append(".")
                self.secondNumber = number2
            } else {
                self.secondNumber = "0."
            }
        }
    }

    private func didSelectPercentage() {
        switch self.currentNumber {
        case .firstNumber:
            if let firstNumber, var number = firstNumber.toDouble {
                number /= 100

                if number.isInteger {
                    self.firstNumber = number.toInt?.description
                } else {
                    self.firstNumber = number.description
                }
            }
        case .secondNumber:
            if let secondNumber, var number = secondNumber.toDouble {
                number /= 100

                if number.isInteger {
                    self.secondNumber = number.toInt?.description
                } else {
                    self.secondNumber = number.description
                }
            }
        }
    }

    private func didSelectPlusMinus() {
        switch self.currentNumber {
        case .firstNumber:
            guard var number1 = firstNumber else { return }

            if number1.contains("-") {
                number1.removeFirst()
            } else {
                number1.insert(contentsOf: "-", at: number1.startIndex)
            }

            self.firstNumber = number1
            self.previousNumber = number1
        case .secondNumber:
            guard var number2 = secondNumber else { return }

            if number2.contains("-") {
                number2.removeFirst()
            } else {
                number2.insert(contentsOf: "-", at: number2.startIndex)
            }

            self.secondNumber = number2
            self.previousNumber = number2
        }
    }

    private func didSelectAllClear() {
        self.currentNumber = .firstNumber
        self.secondNumber = nil
        self.firstNumber = nil
        self.previousNumber = nil
        self.currentOperator = nil
    }

    private func getOperatorResult(_ calcOperator: CalculatorOperator, _ firstNumber: Double, _ secondNumber: Double) -> Double {
        switch calcOperator {
        case .divide:
            return firstNumber / secondNumber
        case .multiply:
            return firstNumber * secondNumber
        case .substract:
            return firstNumber - secondNumber
        case .add:
            return firstNumber + secondNumber
        }
    }
}

#Preview {
    UIStackCalculatorViewController()
}
