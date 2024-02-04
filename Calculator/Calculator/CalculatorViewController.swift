//
//  CalculatorViewController.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 1.02.2024.
//

import UIKit

// MARK: - FİRST NUMBER VEYA SECOND NUMBER UPDATE OLDUĞUNDA PREVİOUS NUMBER'DA UPDATE OLUYOR. BU YÜZDEN BUNU DİDSET İÇİNE YAZABİLİRİZ.

final class CalculatorViewController: UIViewController {
    // MARK: - Variables

    private let calculatorButtonCells: [CalculatorButton] = [
        .allClear, .plusMinus, .percentage, .divide,
        .number(7), .number(8), .number(9), .multiply,
        .number(4), .number(5), .number(6), .substract,
        .number(1), .number(2), .number(3), .add,
        .number(0), .float, .equals
    ]

    private lazy var headerTitle: String = "0"
    private var currentNumber: CurrentNumber = .firstNumber
    private var currentOperator: CalculatorOperator? = nil
    private var previousNumber: String? = nil
    private var previousOperator: CalculatorOperator? = nil
    //  private var previousOperator: CalculatorOperator? = nil

    private var firstNumber: String? = nil {
        didSet {
            headerTitle = firstNumber ?? "0"
            previousNumber = firstNumber
        }
    }

    private var secondNumber: String? = nil {
        didSet {
            headerTitle = secondNumber ?? "0"
            previousNumber = secondNumber
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

extension CalculatorViewController {
    private func style() {
        view.backgroundColor = .systemBackground
    }

    private func setUpCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor,
                                                   constant: 25)
        ])

        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func updateView() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

// MARK: - Collection View Extension.

extension CalculatorViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    /// Header
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HeaderReusableViewCell.reuseIdentifier, for: indexPath) as? HeaderReusableViewCell else {
            fatalError()
        }
        header.configure(with: headerTitle)
        return header
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        calculatorButtonCells.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ButtonCollectionViewCell.reuseIdentifier, for: indexPath) as? ButtonCollectionViewCell else {
            fatalError()
        }

        cell.configure(with: calculatorButtonCells[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let buttonCell = calculatorButtonCells[indexPath.item]

        collectionView.deselectItem(at: indexPath, animated: true)
        didSelectButton(calculatorButton: buttonCell)
    }
}

extension CalculatorViewController: UICollectionViewDelegateFlowLayout {
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
        let calculatorButton = calculatorButtonCells[indexPath.row]
        let width = collectionView.frame.width

        switch calculatorButton {
        case .number(let int) where int == 0:
            return CGSize(
                width: (width / 5) * 2 + ((width / 5) / 3),
                height: width / 5)
        default:
            return CGSize(
                width: width / 5,
                height: width / 5)
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

extension CalculatorViewController {
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

        updateView()
    }

    private func didSelectAllClear() {
        currentNumber = .firstNumber
        firstNumber = nil
        secondNumber = nil
        currentOperator = nil
        previousNumber = nil
        //     previousOperator = nil
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
            //   previousNumber = secondNumber
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

                //    previousNumber = firstNumber
            }
        } else {
            if let secondNumber, var number = secondNumber.toDouble {
                number /= 100

                if number.isInteger {
                    self.secondNumber = number.toInt?.description
                } else {
                    self.secondNumber = number.description
                }

                //    previousNumber = secondNumber
            }
        }
    }

    private func didSelectOperator(with calcOperator: CalculatorOperator) {
        if currentNumber == .firstNumber {
            /// 2"+"
            currentOperator = calcOperator
            currentNumber = .secondNumber
        } else if currentNumber == .secondNumber {
            /// 2+5"+"
            if let currentOperator = currentOperator, let firstNumber = firstNumber?.toDouble, let secondNumber = secondNumber?.toDouble {
                /// 5 + 5,2 = 6,2 if isInteger(6,2 == 6.0) ? print(toInt) :print(toDouble)
                let result = getOperatorResult(currentOperator, firstNumber, secondNumber)
                let resultString = result.isInteger ? result.toInt?.description : result.description

                self.secondNumber = nil
                self.firstNumber = resultString
                currentNumber = .firstNumber
                self.currentOperator = calcOperator
            }
        } else {
            /// 2+"+""
            currentOperator = calcOperator
        }
    }

    private func didSelectEquals() {
        if let currentOperator, let firstNumber = firstNumber?.toDouble, let secondNumber = secondNumber?.toDouble {
            let result = getOperatorResult(currentOperator, firstNumber, secondNumber)
            let resultString = result.isInteger ? result.toInt?.description : result.description
            print(resultString ?? "")
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
                //        previousNumber = firstNumber
            } else {
                /// İlk defa basıldığı zaman first number buradan değer almaktadır. Daha sonradan string'e bir veri ekleneği için yukarıda if bloğuna girer. Operation belirlenene kadar firstNumber'a veri eklenmesi devam eder.
                firstNumber = number.description
                //    previousNumber = number.description
            }
        } else {
            if var secondNumber {
                secondNumber.append(number.description)
                self.secondNumber = secondNumber
                //            previousNumber = secondNumber
            } else {
                secondNumber = number.description
                //         previousNumber = number.description
            }
        }
    }

    private func didSelectFloat() {
        if currentNumber == .firstNumber {
            if var firstNumber {
                guard !firstNumber.contains(".") else { return }

                firstNumber.append(".")
                self.firstNumber = firstNumber
                //  previousNumber = firstNumber
            } else {
                /// Eğer firstNumber nil iken .'ya basılıyor ise 0. diye başlanılır. Onun dışında ise "number + ." olur.
                firstNumber = "0."
                //    previousNumber = "0."
            }
        } else {
            if var secondNumber {
                guard !secondNumber.contains(".") else { return }

                secondNumber.append(".")
                self.secondNumber = secondNumber
                //        previousNumber = secondNumber
            } else {
                /// Eğer firstNumber nil iken .'ya basılıyor ise 0. diye başlanılır. Onun dışında ise "number + ." olur.
                secondNumber = "0."
                //         previousNumber = "0."
            }
        }
    }
}

extension CalculatorViewController {
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
    CalculatorViewController()
}
