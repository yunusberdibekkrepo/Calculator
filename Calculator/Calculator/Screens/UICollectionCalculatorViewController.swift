//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 1.02.2024.
//

import UIKit

// MARK: - SET UP WITH COLLECTION VIEW

final class UICollectionCalculatorViewController: UIViewController {
    // MARK: - Variables

    private let calculatorButtonCells: [CalculatorButton] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .substract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .float, .equals
    ]

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

    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(HeaderReusableViewCell.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderReusableViewCell.reuseIdentifier)
        collectionView.register(ButtonCollectionViewCell.self,
                                forCellWithReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier)
        return collectionView
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        setUpCollectionView()
    }
}

// MARK: - UI Related Functions

extension UICollectionCalculatorViewController {
    private func style() {
        view.backgroundColor = .systemBackground
    }

    private func setUpCollectionView() {
        view.addSubview(self.collectionView)
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate(
            [
                self.collectionView.topAnchor.constraint(
                    equalTo: view.topAnchor
                ),
                self.collectionView.leadingAnchor.constraint(
                    equalTo: view.leadingAnchor
                ),
                self.collectionView.trailingAnchor.constraint(
                    equalTo: view.trailingAnchor
                ),
                self.collectionView.bottomAnchor.constraint(
                    equalTo: view.bottomAnchor,
                    constant: 25
                )
            ]
        )

        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }

    private func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Collection View Extension.

extension UICollectionCalculatorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    /// Header
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableViewCell.reuseIdentifier, for: indexPath) as? HeaderReusableViewCell else {
            fatalError()
        }
        header.configure(with: headerTitleText)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.calculatorButtonCells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? ButtonCollectionViewCell else {
            fatalError()
        }
        let buttonCell = self.calculatorButtonCells[indexPath.row]

        cell.configure(with: buttonCell)

        if let operation = currentOperator, secondNumber == nil {
            if operation.title == buttonCell.title {
                cell.setOperationSelected()
            }
        }

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonCell = self.calculatorButtonCells[indexPath.item]

        collectionView.deselectItem(at: indexPath, animated: true)

        didSelectButton(buttonCell)
    }
}

extension UICollectionCalculatorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let totalCellHeight = collectionView.frame.width
        let totalVerticalCellSpacing = CGFloat(10 * 4)

        let window = view.window?.windowScene?.keyWindow
        let topPadding = window?.safeAreaInsets.top ?? 0
        let bottomPadding = window?.safeAreaInsets.bottom ?? 0

        let availableScreenHeight = view.frame.size.height - topPadding - bottomPadding
        let headerHeight = availableScreenHeight - totalCellHeight - totalVerticalCellSpacing
        return CGSize(width: view.frame.width, height: headerHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let calculatorButton = self.calculatorButtonCells[indexPath.row]
        let width = collectionView.frame.width

        switch calculatorButton {
        case .number(let int) where int == 0:
            return CGSize(
                width: (width / 5) * 2 + ((width / 5) / 3),
                height: width / 5
            )
        default:
            return CGSize(
                width: width / 5,
                height: width / 5
            )
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        let bounds = collectionView.bounds
        let width = bounds.width

        return CGFloat(width / 5.1) / 3
    }
}

extension UICollectionCalculatorViewController {
    private func updateHeaderTitle() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }

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

    // TODO: NUMB+NUMB2 EQUALS EQULAS SUBSTRACT ÇALIŞMIYOR.
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
    UICollectionCalculatorViewController()
}
