//
//  ButtonCollectionViewCell.swift
//  Calculator
//
//  Created by Yunus Emre Berdibek on 1.02.2024.
//

import UIKit

final class ButtonCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier: String = "ButtonCollectionViewCell"

    // MARK: - Variables

    private(set) var calculatorButton: CalculatorButton!

    // MARK: - UI Components

    let bodyLabel: BodyLabel = .init(alignment: .center)

    override func prepareForReuse() {
        super.prepareForReuse()
        bodyLabel.removeFromSuperview()
    }

    public func configure(with calculatorButton: CalculatorButton) {
        self.calculatorButton = calculatorButton
        style()
        layout()
    }
}

extension ButtonCollectionViewCell {
    private func style() {
        bodyLabel.text = calculatorButton.title
        backgroundColor = calculatorButton.color

        switch calculatorButton {
        case .allClear, .plusMinus, .percentage:
            bodyLabel.textColor = .black
        default:
            bodyLabel.textColor = .white
        }
    }

    private func layout() {
        addSubview(bodyLabel)

        switch calculatorButton {
        case .number(let value) where value == 0:
            layer.cornerRadius = 36

            NSLayoutConstraint.activate([
                bodyLabel.topAnchor.constraint(equalTo: topAnchor),
                bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        default:
            layer.cornerRadius = frame.size.width / 2

            NSLayoutConstraint.activate([
                bodyLabel.topAnchor.constraint(equalTo: topAnchor),
                bodyLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
                bodyLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
                bodyLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
