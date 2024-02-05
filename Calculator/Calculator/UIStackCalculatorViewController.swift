//
//  MockCalculatorViewController.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 5.02.2024.
//

import UIKit

// MARK: - SET UP WITH UI STACK VIEW

final class UIStackCalculatorViewController: UIViewController {
    // MARK: - Variables

    private let firstRow: [CalculatorButton] = [.allClear, .plusMinus, .percentage, .divide]
    private let secondRow: [CalculatorButton] = [.number(7), .number(8), .number(9), .multiply]
    private let thirdRow: [CalculatorButton] = [.number(4), .number(5), .number(6), .substract]
    private let fourthRow: [CalculatorButton] = [.number(1), .number(2), .number(3), .add]
    private let fifthRow: [CalculatorButton] = [.number(0), .float, .equals]

    private var currentNumber: CurrentNumber = .firstNumber
    private var currentOperator: CalculatorOperator? = nil
    private var previousNumber: String? = nil
    private var previousOperator: CalculatorOperator? = nil

    private var headerText: String = "0" {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.headerViewTextLabel.text = self?.headerText
            }
        }
    }

    private var firstNumber: String? = nil {
        didSet {
            headerText = firstNumber ?? "0"
            previousNumber = firstNumber
        }
    }

    private var secondNumber: String? = nil {
        didSet {
            headerText = secondNumber ?? "0"
            previousNumber = secondNumber
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
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpHeaderView()
        setUpHeaderText()
        setUpBodyView()

        createStackView(stackView: firstStackView, anchor: bodyView.topAnchor, calcButtons: firstRow)
        createStackView(stackView: secondStackView, anchor: firstStackView.bottomAnchor, calcButtons: secondRow)
        createStackView(stackView: thirdStackView, anchor: secondStackView.bottomAnchor, calcButtons: thirdRow)
        createStackView(stackView: fourthStackView, anchor: thirdStackView.bottomAnchor, calcButtons: fourthRow)
        createStackView(stackView: fifthStackView, anchor: fourthStackView.bottomAnchor, calcButtons: fifthRow)
    }
}

// MARK: - UI Related functions.

extension UIStackCalculatorViewController {
    private func setUpHeaderView() {
        headerView.translatesAutoresizingMaskIntoConstraints = false
        headerView.backgroundColor = .systemBackground
        view.addSubview(headerView)

        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalToSystemSpacingBelow: view.topAnchor, multiplier: 0),
            headerView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 0),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: headerView.trailingAnchor, multiplier: 0),
            headerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4)
        ])
    }

    private func setUpHeaderText() {
        headerViewTextLabel.translatesAutoresizingMaskIntoConstraints = false
        headerViewTextLabel.text = headerText
        headerView.addSubview(headerViewTextLabel)

        NSLayoutConstraint.activate([
            headerView.trailingAnchor.constraint(equalToSystemSpacingAfter: headerViewTextLabel.trailingAnchor, multiplier: 1),
            headerViewTextLabel.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            headerViewTextLabel.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)

        ])
    }

    private func setUpBodyView() {
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        bodyView.backgroundColor = .systemBackground
        view.addSubview(bodyView)

        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalToSystemSpacingBelow: headerView.bottomAnchor, multiplier: 0),
            bodyView.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            bodyView.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            bodyView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}

// MARK: - SetUp stack view.

extension UIStackCalculatorViewController {
    private func createStackView(stackView: UIStackView, anchor: NSLayoutYAxisAnchor, calcButtons: [CalculatorButton]) {
        bodyView.addSubview(stackView)

        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.spacing = 7
        stackView.distribution = .equalSpacing
        stackView.alignment = .center

        calcButtons.forEach { calcButton in
            let button = createCalcButton(with: calcButton)
            stackView.addArrangedSubview(button)
        }

        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalToSystemSpacingBelow: anchor, multiplier: 1),
            stackView.leadingAnchor.constraint(equalToSystemSpacingAfter: bodyView.leadingAnchor, multiplier: 1),
            bodyView.trailingAnchor.constraint(equalToSystemSpacingAfter: stackView.trailingAnchor, multiplier: 1)
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
        button.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)

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

// MARK: - Actions

extension UIStackCalculatorViewController {
    @objc
    private func didTapButton(_ sender: UIButton) {
        let calcButton = CalculatorButton(tag: sender.tag)
        didSelectButton(calculatorButton: calcButton)
    }
}

extension UIStackCalculatorViewController {
    private func didSelectButton(calculatorButton: CalculatorButton) {
        switch calculatorButton {
        case .allClear:
            didSelectAllClear()
        case .plusMinus:
            didSelectPlusMinus()
        case .percentage:
            didSelectPercentage()
        case .divide:
            didSelectOperator(with: .divide)
        case .multiply:
            didSelectOperator(with: .multiply)
        case .substract:
            didSelectOperator(with: .substract)
        case .add:
            didSelectOperator(with: .add)
        case .equals:
            didSelectEquals()
        case .number(let number):
            didSelectNumber(with: number)
        case .float:
            didSelectFloat()
        }
    }

    private func didSelectAllClear() {
        currentNumber = .firstNumber
        firstNumber = nil
        secondNumber = nil
        currentOperator = nil
        previousNumber = nil
        previousOperator = nil
    }

    private func didSelectPlusMinus() {
        switch currentNumber {
        case .firstNumber:
            guard var firstNumber else { return }

            if firstNumber.contains("-") {
                firstNumber.removeFirst()
            } else {
                firstNumber.insert(contentsOf: "-", at: firstNumber.startIndex)
            }

            self.firstNumber = firstNumber
            previousNumber = firstNumber
        case .secondNumber:
            guard var secondNumber else { return }

            if secondNumber.contains("-") {
                secondNumber.removeFirst()
            } else {
                secondNumber.insert(contentsOf: "-", at: secondNumber.startIndex)
            }

            self.secondNumber = secondNumber
        }
    }

    private func didSelectPercentage() {
        if currentNumber == .firstNumber {
            if let firstNumber, var number = firstNumber.toDouble {
                number /= 100

                if number.isInteger {
                    self.firstNumber = number.toInt?.description
                } else {
                    self.firstNumber = number.description
                }
            }
        } else {
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

    private func didSelectOperator(with calcOperator: CalculatorOperator) {
        if currentNumber == .firstNumber {
            currentOperator = calcOperator
            currentNumber = .secondNumber
        } else if currentNumber == .secondNumber {
            if let currentOperator = currentOperator, let firstNumber = firstNumber?.toDouble, let secondNumber = secondNumber?.toDouble {
                let result = getOperatorResult(currentOperator, firstNumber, secondNumber)
                let resultString = result.isInteger ? result.toInt?.description : result.description

                self.secondNumber = nil
                self.firstNumber = resultString
                currentNumber = .firstNumber
                self.currentOperator = calcOperator
            }
        } else {
            currentOperator = calcOperator
        }
    }

    private func didSelectEquals() {
        if let currentOperator, let firstNumber = firstNumber?.toDouble, let secondNumber = secondNumber?.toDouble {
            let result = getOperatorResult(currentOperator, firstNumber, secondNumber)
            let resultString = result.isInteger ? result.toInt?.description : result.description

            self.secondNumber = nil
            previousOperator = currentOperator
            self.currentOperator = nil
            self.firstNumber = resultString
            currentNumber = .firstNumber
        } else if let previousOperator, let firstNumber = firstNumber?.toDouble, let previousNumber = previousNumber?.toDouble {
            let result = getOperatorResult(previousOperator, firstNumber, previousNumber)
            let resultString = result.isInteger ? result.toInt?.description : result.description

            self.firstNumber = resultString
        }
    }

    private func didSelectNumber(with number: Int) {
        if currentNumber == .firstNumber {
            if var firstNumber {
                firstNumber.append(number.description)
                self.firstNumber = firstNumber
            } else {
                firstNumber = number.description
            }
        } else {
            if var secondNumber {
                secondNumber.append(number.description)
                self.secondNumber = secondNumber
            } else {
                secondNumber = number.description
            }
        }
    }

    private func didSelectFloat() {
        if currentNumber == .firstNumber {
            if var firstNumber {
                guard !firstNumber.contains(".") else { return }

                firstNumber.append(".")
                self.firstNumber = firstNumber
            } else {
                firstNumber = "0."
            }
        } else {
            if var secondNumber {
                guard !secondNumber.contains(".") else { return }

                secondNumber.append(".")
                self.secondNumber = secondNumber
            } else {
                secondNumber = "0."
            }
        }
    }
}

extension UIStackCalculatorViewController {
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
